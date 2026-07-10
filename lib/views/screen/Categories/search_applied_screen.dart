import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/models/event_model.dart';
import 'package:event_sharing/services/api_service.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/utils/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../base/custom_text.dart';

class CategoriesSearchAppliedScreen extends StatefulWidget {
  final dynamic category;

  const CategoriesSearchAppliedScreen({super.key, required this.category});

  @override
  State<CategoriesSearchAppliedScreen> createState() =>
      _CategoriesSearchAppliedScreenState();
}

class _CategoriesSearchAppliedScreenState
    extends State<CategoriesSearchAppliedScreen> {
  List<EventModel> events = [];
  bool isLoading = true;
  String? error;
  int _page = 1;
  final int _limit = 10;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchEvents();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
        !_isLoadingMore &&
        _hasMore) {
      _loadMore();
    }
  }

  Future<void> _fetchEvents() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final apiService = Get.find<ApiService>();
      final String? categoryId = widget.category['id']?.toString();
      
      if (categoryId == null) {
        setState(() {
          error = "Category ID is missing";
          isLoading = false;
        });
        return;
      }

      final response = await apiService.get(
        '${ApiConstants.categorieDetailsEvent(categoryId)}?page=$_page&limit=$_limit',
      );

      if (response['success'] == true) {
        final categoryData = response['data'] ?? {};
        final eventsData = categoryData['events'] ?? {};
        final List<dynamic> data = eventsData['data'] ?? [];
        final Map<String, dynamic> meta = eventsData['meta'] ?? {};

        setState(() {
          events = data.map<EventModel>((json) => EventModel.fromJson(json)).toList();
          _hasMore = meta['hasNext'] == true;
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
      final String? categoryId = widget.category['id']?.toString();
      
      if (categoryId == null) return;

      final response = await apiService.get(
        '${ApiConstants.categorieDetailsEvent(categoryId)}?page=$_page&limit=$_limit',
      );

      if (response['success'] == true) {
        final categoryData = response['data'] ?? {};
        final eventsData = categoryData['events'] ?? {};
        final List<dynamic> data = eventsData['data'] ?? [];
        final Map<String, dynamic> meta = eventsData['meta'] ?? {};

        setState(() {
          events.addAll(data.map<EventModel>((json) => EventModel.fromJson(json)));
          _hasMore = meta['hasNext'] == true;
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

  Future<void> _refreshEvents() async {
    setState(() {
      _page = 1;
      _hasMore = true;
      events.clear();
    });
    await _fetchEvents();
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

  @override
  Widget build(BuildContext context) {
    final categoryName = widget.category['name'] ?? 'Category';
    final categoryImage = widget.category['imageUrl'];

    return Scaffold(
      //=======================> App Bar Section <============================
      appBar: AppBar(
        title: CustomText(
          text: categoryName,
          fontsize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Colors.black, size: 18.w),
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
      ),
      //=======================> Body Section <============================
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //=======================> Event Image Section <============================
              Container(
                height: 180.h,
                width: 345.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  color: Colors.transparent,
                  image: categoryImage != null && categoryImage.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(categoryImage),
                          fit: BoxFit.cover,
                        )
                      : const DecorationImage(
                          image: AssetImage('assets/images/concert.jpg'),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              SizedBox(height: 16.h),
              CustomText(
                text: 'Total ${events.length} Events',
                fontsize: 20.sp,
                color: AppColors.blackColor,
                fontWeight: FontWeight.w500,
              ),
              //=======================> Event Name Section <============================
              SizedBox(height: 8.h),
              _buildEventList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventList() {
    if (isLoading && events.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null && events.isEmpty) {
      return Center(child: Text(error!, style: const TextStyle(color: Colors.red)));
    }

    if (events.isEmpty) {
      return const Center(child: Text('No events found for this category'));
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
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //=====================> Event Image Section <=========================
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: event.coverImage != null && event.coverImage!.isNotEmpty
                            ? Image.network(
                                event.coverImage!,
                                height: 75.h,
                                width: 75.w,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildEventPlaceholder(event.eventName);
                                },
                              )
                            : _buildEventPlaceholder(event.eventName),
                      ),
                      SizedBox(width: 12.w),
                      //===================== >> Event Details Section << =========================
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
                            //=====================> Event Info Section <=========================
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(AppIcons.dotIconForFamily),
                                          SizedBox(width: 4.w),
                                          Text(
                                            schedule?.eventType ?? 'Onsite Event',
                                            style: TextStyle(fontSize: 8.sp, color: AppColors.color414141),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(AppIcons.dotIconForFamily),
                                          SizedBox(width: 4.w),
                                          Text(
                                            event.location ?? 'Dhaka Bangladesh',
                                            style: TextStyle(fontSize: 8.sp, color: AppColors.color414141),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(AppIcons.dotIconForFamily),
                                          SizedBox(width: 4.w),
                                          Text(
                                            'History: 2023-1st winner',
                                            style: TextStyle(fontSize: 8.sp, color: AppColors.color808080),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(AppIcons.dotIconForFamily),
                                          SizedBox(width: 4.w),
                                          Text(
                                            'Cost: ${_formatCost(schedule?.cost)}',
                                            style: TextStyle(fontSize: 8.sp, color: AppColors.color414141),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(AppIcons.dotIconForFamily),
                                          SizedBox(width: 4.w),
                                          Text(
                                            'Deadline: ${_formatDeadline(schedule?.deadline)}',
                                            style: TextStyle(fontSize: 8.sp, color: AppColors.color414141),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      //=====================> Share Icon <=========================
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
              //=====================> Positioned More Icon at Top Right <=========================
              Positioned(
                bottom: 10,
                right: 10,
                child: Icon(Icons.more_horiz, color: AppColors.greyColor),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEventPlaceholder(String? title) {
    return Container(
      height: 75.h,
      width: 75.w,
      color: Colors.grey[300],
      child: Center(
        child: CustomText(
          text: title?.isNotEmpty == true ? title![0].toUpperCase() : '?',
          fontsize: 24.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

