import 'package:event_sharing/controllers/home_controller.dart';
import 'package:event_sharing/helpers/feed_search_query.dart';
import 'package:event_sharing/utils/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../../helpers/route.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_images.dart';
import '../../base/app_remote_image.dart';
import '../../base/custom_text.dart';
import '../../base/custom_text_field.dart';

class SearchEventScreen extends StatefulWidget {
  const SearchEventScreen({super.key});

  @override
  State<SearchEventScreen> createState() => _SearchEventScreenState();
}

class _SearchEventScreenState extends State<SearchEventScreen> {
  final HomeController _homeController = Get.find<HomeController>();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Map<String, dynamic> _activeFilters = {};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dynamic args = Get.arguments;
      if (args != null && args is Map<String, dynamic>) {
        if (args.containsKey('searchTerm')) {
          _searchController.text = args['searchTerm'] ?? '';
        }
        _performSearch(args);
      } else if (args != null && args is String) {
        _searchController.text = args;
        _performSearch({'searchTerm': args});
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (_homeController.searchHasNext.value && !_homeController.isLoadingSearch.value) {
        _performSearch({}, isLoadMore: true);
      }
    }
  }

  void _performSearch(Map<String, dynamic> filters, {bool isLoadMore = false}) {
    if (!isLoadMore) {
      _activeFilters = Map<String, dynamic>.from(filters);
    }
    final merged = {..._activeFilters, ...filters};
    RangeValues? priceRange = merged['priceRange'] as RangeValues?;

    var searchTerm = _searchController.text.trim();
    if (searchTerm.isEmpty) {
      searchTerm = (merged['searchTerm'] as String?)?.trim() ?? '';
    }
    if (searchTerm.isEmpty) {
      final loc = (merged['location'] as String?)?.trim();
      if (loc != null && loc.isNotEmpty) {
        searchTerm = loc;
      }
    }

    _homeController.searchEvents(
      isLoadMore: isLoadMore,
      searchTerm: searchTerm.isNotEmpty ? searchTerm : null,
      programId: merged['program']?.toString(),
      type: merged['type']?.toString(),
      location: merged['location']?.toString(),
      categoryGroup: FeedSearchQuery.normalizeCategoryGroup(
        merged['category']?.toString(),
      ),
      priceMin: priceRange?.start,
      priceMax: priceRange?.end,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'Search Results',
          fontsize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
        child: Column(
          children: [
            //==========================> Search Bar <=====================
            CustomTextField(
              controller: _searchController,
              hintText: 'Find Upcoming Event',
              onFieldSubmitted: (value) {
                _performSearch({'searchTerm': value});
              },
              sufixicons: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => _performSearch({'searchTerm': _searchController.text}),
                  child: Icon(
                    Icons.search,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            //=================================> Event List view <========================
            Expanded(
              child: Obx(() {
                if (_homeController.isLoadingSearch.value && _homeController.searchedEvents.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (_homeController.searchedEvents.isEmpty) {
                  return const Center(child: Text("No events found matching your search."));
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: _homeController.searchedEvents.length + (_homeController.isLoadingSearch.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _homeController.searchedEvents.length) {
                      return const Center(child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ));
                    }

                    final event = _homeController.searchedEvents[index];
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.eventDetailsScreen, arguments: event);
                      },
                      child: Card(
                        color: const Color(0xffedf2f4),
                        margin: EdgeInsets.symmetric(vertical: 8.h),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          child: Row(
                            children: [
                              //=====================> Event Image Section <=========================
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: event.coverImage != null && event.coverImage!.isNotEmpty
                                    ? AppRemoteImage(
                                        url: event.coverImage,
                                        width: 77.w,
                                        height: 76.h,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        AppImages.logo,
                                        width: 77.w,
                                        height: 76.h,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              SizedBox(width: 16.h),
                              //=====================> Event Title Section <=========================
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: event.eventName ?? 'Unknown Event',
                                      fontsize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      maxline: 1,
                                    ),
                                    SizedBox(height: 8.h),
                                    //=====================> Event Location Section <=========================
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppIcons.locationIcon,
                                          color: AppColors.primaryColor,
                                          width: 12.w,
                                        ),
                                        SizedBox(width: 4.w),
                                        Expanded(
                                          child: CustomText(
                                            text: event.location ?? 'N/A',
                                            fontsize: 10.sp,
                                            maxline: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  //===========================> Share Icon Button <======================
                                  InkWell(
                                      onTap: () async {
                                        final link = (event.eventPortal?.trim().isNotEmpty == true)
                                            ? event.eventPortal!.trim()
                                            : (event.id != null
                                                ? '${ApiConstants.baseUrl}/events/${event.id}'
                                                : null);
                                        if (link == null || link.isEmpty) {
                                          Fluttertoast.showToast(msg: 'No event link available');
                                          return;
                                        }
                                        await Clipboard.setData(ClipboardData(text: link));
                                        Fluttertoast.showToast(msg: 'Event link copied');
                                      },
                                      child: Icon(
                                        Icons.share,
                                        color: AppColors.primaryColor,
                                        size: 20.h,
                                      )),
                                  SizedBox(height: 8.h),
                                  //=====================> Event Time Section <=========================
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SvgPicture.asset(
                                        AppIcons.timeIcon,
                                        color: AppColors.primaryColor,
                                        width: 12.w,
                                      ),
                                      SizedBox(width: 5.w),
                                      CustomText(
                                        text: event.schedule?.registrationDate != null 
                                          ? "${event.schedule!.registrationDate!.hour}:${event.schedule!.registrationDate!.minute.toString().padLeft(2, '0')}"
                                          : 'N/A',
                                        fontsize: 10.sp,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
