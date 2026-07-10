import 'package:event_sharing/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../helpers/route.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icons.dart';
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

  String _mapCategoryGroup(String? displayValue) {
    if (displayValue == null) return '';
    switch (displayValue) {
      case '6 Year - 10 Year':
        return '6year-10year';
      case '11 Year - 16 Year':
        return '11year-16year';
      case '17 Year+':
        return '17year+';
      default:
        return displayValue.toLowerCase().replaceAll(' ', '');
    }
  }

  void _performSearch(Map<String, dynamic> filters, {bool isLoadMore = false}) {
    RangeValues? priceRange = filters['priceRange'];
    
    _homeController.searchEvents(
      isLoadMore: isLoadMore,
      searchTerm: _searchController.text,
      programId: filters['program'], // Assuming program contains ID or name as needed by API
      type: filters['type'],
      location: filters['location'],
      categoryGroup: _mapCategoryGroup(filters['category']),
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
                        Get.toNamed(AppRoutes.eventDetailsScreen, arguments: event.id);
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
                                    ? Image.network(
                                        event.coverImage!,
                                        width: 77.w,
                                        height: 76.h,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => 
                                          Container(width: 77.w, height: 76.h, color: Colors.grey[300], child: const Icon(Icons.image)),
                                      )
                                    : Container(
                                        width: 77.w,
                                        height: 76.h,
                                        color: AppColors.primaryColor.withOpacity(0.2),
                                        child: Icon(Icons.event, color: AppColors.primaryColor),
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
                                      onTap: () {
                                        Get.toNamed(AppRoutes.myInvitationPage);
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
