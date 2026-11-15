import 'package:event_sharing/helpers/event_actions.dart';
import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/models/event_model.dart';
import 'package:event_sharing/services/api_service.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/utils/app_images.dart';
import 'package:event_sharing/utils/api_constants.dart';
import 'package:event_sharing/utils/media_url_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../base/app_remote_image.dart';
import '../../base/custom_text.dart';

class CategoriesSearchAppliedScreen extends StatefulWidget {
  final dynamic category;
  final bool isSubCategory;

  const CategoriesSearchAppliedScreen({
    super.key,
    required this.category,
    this.isSubCategory = false,
  });

  @override
  State<CategoriesSearchAppliedScreen> createState() =>
      _CategoriesSearchAppliedScreenState();
}

class _CategoriesSearchAppliedScreenState
    extends State<CategoriesSearchAppliedScreen> {
  List<EventModel> events = [];
  List<Map<String, dynamic>> subCategories = [];
  String? _bannerImageUrl;
  String? _title;
  bool isLoading = true;
  bool _isLoadingSubCategories = false;
  String? error;
  int _page = 1;
  final int _limit = 10;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final map = _asMap(widget.category);
    _title = map?['name']?.toString() ??
        (widget.isSubCategory ? 'Sub Category' : 'Category');
    _bannerImageUrl = MediaUrlUtils.fromMap(map);
    if (!widget.isSubCategory) {
      _fetchSubCategories();
    }
    _fetchEvents();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, val) => MapEntry(key.toString(), val));
    }
    return null;
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoadingMore &&
        _hasMore) {
      _loadMore();
    }
  }

  Future<void> _fetchSubCategories() async {
    setState(() => _isLoadingSubCategories = true);

    try {
      final apiService = Get.find<ApiService>();
      final String? categoryId = widget.category['id']?.toString();
      if (categoryId == null) {
        setState(() => _isLoadingSubCategories = false);
        return;
      }

      final response =
          await apiService.get(ApiConstants.subCategoriesEvent(categoryId));

      if (response['success'] == true) {
        final raw = response['data'];
        List<dynamic> data = [];
        if (raw is List) {
          data = raw;
        } else if (raw is Map) {
          data = (raw['data'] as List?) ??
              (raw['subcategories'] as List?) ??
              (raw['subCategories'] as List?) ??
              [];
        }

        setState(() {
          subCategories = data
              .whereType<Map>()
              .map((e) => e.map((k, v) => MapEntry(k.toString(), v)))
              .toList();
          _isLoadingSubCategories = false;
        });
      } else {
        setState(() => _isLoadingSubCategories = false);
      }
    } catch (_) {
      setState(() => _isLoadingSubCategories = false);
    }
  }

  String _eventsUrl({required int page}) {
    final id = widget.category['id']?.toString() ?? '';
    if (widget.isSubCategory) {
      // Prefer events filtered by subcategory; fall back handled in parser.
      return '${ApiConstants.createEvent}?subcategoryId=$id&page=$page&limit=$_limit';
    }
    return '${ApiConstants.categorieDetailsEvent(id)}?page=$page&limit=$_limit';
  }

  List<EventModel> _parseEvents(dynamic response) {
    if (response is! Map) return [];

    // Category details shape: data.events.data
    final categoryData = _asMap(response['data']);
    if (categoryData != null) {
      final eventsData = _asMap(categoryData['events']);
      if (eventsData != null && eventsData['data'] is List) {
        return (eventsData['data'] as List)
            .map<EventModel>((json) => EventModel.fromJson(json))
            .toList();
      }
      // Flat list under data
      if (categoryData['data'] is List) {
        return (categoryData['data'] as List)
            .map<EventModel>((json) => EventModel.fromJson(json))
            .toList();
      }
    }

    // Direct list: data: [...]
    if (response['data'] is List) {
      return (response['data'] as List)
          .map<EventModel>((json) => EventModel.fromJson(json))
          .toList();
    }

    return [];
  }

  bool _parseHasNext(dynamic response) {
    if (response is! Map) return false;
    final categoryData = _asMap(response['data']);
    final eventsMeta = _asMap(categoryData?['events'])?['meta'];
    if (eventsMeta is Map && eventsMeta['hasNext'] == true) return true;
    final meta = response['meta'];
    if (meta is Map && meta['hasNext'] == true) return true;
    final nestedMeta = categoryData?['meta'];
    if (nestedMeta is Map && nestedMeta['hasNext'] == true) return true;
    return false;
  }

  Future<void> _fetchEvents({bool reset = true}) async {
    if (reset) {
      setState(() {
        isLoading = true;
        error = null;
        _page = 1;
        _hasMore = true;
        events.clear();
      });
    }

    try {
      final apiService = Get.find<ApiService>();
      final String? id = widget.category['id']?.toString();

      if (id == null) {
        setState(() {
          error = widget.isSubCategory
              ? "Sub Category ID is missing"
              : "Category ID is missing";
          isLoading = false;
        });
        return;
      }

      final response = await apiService.get(_eventsUrl(page: _page));

      if (response['success'] == true) {
        if (!widget.isSubCategory) {
          final categoryData = _asMap(response['data']) ?? {};
          final detailsImage = MediaUrlUtils.fromMap(categoryData);
          final detailsName = categoryData['name']?.toString();

          if (subCategories.isEmpty) {
            final nested = categoryData['subcategories'] ??
                categoryData['subCategories'] ??
                categoryData['sub_categories'];
            List<dynamic> nestedList = [];
            if (nested is List) {
              nestedList = nested;
            } else if (nested is Map) {
              nestedList = (nested['data'] as List?) ?? [];
            }
            if (nestedList.isNotEmpty) {
              subCategories = nestedList
                  .whereType<Map>()
                  .map((e) => e.map((k, v) => MapEntry(k.toString(), v)))
                  .toList();
            }
          }

          setState(() {
            if (detailsImage != null) _bannerImageUrl = detailsImage;
            if (detailsName != null && detailsName.isNotEmpty) {
              _title = detailsName;
            }
          });
        }

        setState(() {
          events = _parseEvents(response);
          _hasMore = _parseHasNext(response);
          isLoading = false;
        });
      } else {
        setState(() {
          error = response['message'] ?? "Failed to fetch events";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _loadMore() async {
    if (!_hasMore || _isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
      _page++;
    });

    try {
      final apiService = Get.find<ApiService>();
      final String? id = widget.category['id']?.toString();
      if (id == null) return;

      final response = await apiService.get(_eventsUrl(page: _page));

      if (response['success'] == true) {
        setState(() {
          events.addAll(_parseEvents(response));
          _hasMore = _parseHasNext(response);
          _isLoadingMore = false;
        });
      } else {
        setState(() {
          _page--;
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      setState(() {
        _page--;
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _refresh() async {
    if (!widget.isSubCategory) {
      await _fetchSubCategories();
    }
    await _fetchEvents(reset: true);
  }

  void _onSubCategoryTap(Map<String, dynamic> subCategory) {
    Get.to(
      () => CategoriesSearchAppliedScreen(
        category: subCategory,
        isSubCategory: true,
      ),
      transition: Transition.rightToLeft,
    );
  }

  String _formatCost(String? cost) {
    if (cost == null || cost.isEmpty) return 'Free';
    try {
      return '\$${double.parse(cost).toStringAsFixed(0)}';
    } catch (e) {
      return cost;
    }
  }

  String _formatDeadline(DateTime? deadline) {
    if (deadline == null) return 'N/A';
    return '${deadline.month}/${deadline.day}/${deadline.year}';
  }

  Widget _networkOrLogo({
    required String? url,
    double? height,
    double? width,
  }) {
    return AppRemoteImage(
      url: url,
      height: height,
      width: width,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: _title ?? 'Category',
          fontsize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 18.w),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: SizedBox(
                    height: 180.h,
                    width: 345.w,
                    child: _networkOrLogo(url: _bannerImageUrl),
                  ),
                ),
                if (!widget.isSubCategory &&
                    (_isLoadingSubCategories || subCategories.isNotEmpty)) ...[
                  SizedBox(height: 16.h),
                  CustomText(
                    text: 'Sub Categories',
                    fontsize: 16.sp,
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 8.h),
                  _buildSubCategorySection(),
                ],
                SizedBox(height: 16.h),
                CustomText(
                  text: 'Total ${events.length} Events',
                  fontsize: 20.sp,
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 8.h),
                _buildEventList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubCategorySection() {
    if (_isLoadingSubCategories && subCategories.isEmpty) {
      return SizedBox(
        height: 110.h,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (subCategories.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 120.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: subCategories.length,
        separatorBuilder: (_, __) => SizedBox(width: 10.w),
        itemBuilder: (context, index) {
          final sub = subCategories[index];
          final name = sub['name']?.toString() ?? 'Unknown';
          final imageUrl = MediaUrlUtils.fromMap(sub);

          return GestureDetector(
            onTap: () => _onSubCategoryTap(sub),
            child: SizedBox(
              width: 110.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: _networkOrLogo(url: imageUrl),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  CustomText(
                    text: name,
                    fontsize: 11.sp,
                    fontWeight: FontWeight.w500,
                    maxline: 1,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEventList() {
    if (isLoading && events.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null && events.isEmpty) {
      return Center(
          child: Text(error!, style: const TextStyle(color: Colors.red)));
    }

    if (events.isEmpty) {
      return Center(
        child: Text(
          widget.isSubCategory
              ? 'No events found for this sub category'
              : 'No events found for this category',
        ),
      );
    }

    return ListView.builder(
      itemCount: events.length + (_isLoadingMore ? 1 : 0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        if (index == events.length) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final event = events[index];
        final schedule = event.schedule;
        final coverUrl = MediaUrlUtils.resolve(event.coverImage);

        return GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.eventDetailsScreen, arguments: event);
          },
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  color: const Color(0xffedf2f4),
                  border: Border.all(color: AppColors.colorC8D7DE, width: 1.w),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: SizedBox(
                          height: 75.h,
                          width: 75.w,
                          child: _networkOrLogo(url: coverUrl),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: event.eventName ?? 'Unknown Event',
                              fontsize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _metaRow(
                                        schedule?.eventType ?? 'Onsite Event'),
                                    _metaRow(
                                        event.location ?? 'Dhaka Bangladesh'),
                                    _metaRow('History: 2023-1st winner',
                                        color: AppColors.color808080),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _metaRow(
                                        'Cost: ${_formatCost(schedule?.cost)}'),
                                    _metaRow(
                                        'Deadline: ${_formatDeadline(schedule?.deadline)}'),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoutes.myInvitationPage);
                        },
                        child: SvgPicture.asset(
                          AppIcons.share,
                          width: 16.w,
                          height: 16.h,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: EventMoreMenuButton(
                  event: event,
                  iconColor: AppColors.greyColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _metaRow(String text, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          SvgPicture.asset(AppIcons.dotIconForFamily),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 8.sp,
              color: color ?? AppColors.color414141,
            ),
          ),
        ],
      ),
    );
  }
}
