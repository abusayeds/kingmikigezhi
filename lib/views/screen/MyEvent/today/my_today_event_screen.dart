import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../helpers/route.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_icons.dart';
import '../../../../../controllers/home_controller.dart';
import '../../../../../models/event_model.dart';

class MyTodayEventScreen extends StatefulWidget {
   const MyTodayEventScreen({super.key});

  @override
  State<MyTodayEventScreen> createState() => _MyTodayEventScreenState();
}

class _MyTodayEventScreenState extends State<MyTodayEventScreen> {
  final HomeController _homeController = Get.find<HomeController>();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _homeController.fetchTodayEvents(isLoadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 24.w,vertical: 10),
        child: Column(
          children: [
            //==============================> Create Event Button <=======================
            _searchBar(),
            SizedBox(height: 16.h),
            //=================================> Event List view <========================
            Expanded(
              child: Obx(() {
                if (_homeController.isLoadingToday.value && _homeController.todayEvents.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (_homeController.todayEvents.isEmpty) {
                  return const Center(child: Text("No events today"));
                }
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: _homeController.todayEvents.length + (_homeController.todayHasNext.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _homeController.todayEvents.length) {
                      return const Center(child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ));
                    }
                    final EventModel event = _homeController.todayEvents[index];
                    String deadline = '';
                    if (event.schedule?.deadline != null) {
                      deadline = DateFormat('d-M-yyyy').format(event.schedule!.deadline!);
                    }

                    return GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoutes.eventDetailsScreen, arguments: event.id);
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
                                      child: event.coverImage != null
                                          ? Image.network(
                                              event.coverImage!,
                                              height: 75.0.h,
                                              width: 75.0.w,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) =>
                                                  Container(height: 75.h, width: 75.w, color: Colors.grey, child: const Icon(Icons.image)),
                                            )
                                          : Image.asset(
                                              "assets/images/music.png",
                                              height: 75.0.h,
                                              width: 75.0.w,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                    SizedBox(width: 12.w),
                                    //=====================> Event Details Section <=========================
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(event.eventName ?? '',style: AppStyles.fontSize14(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                                          //=====================> Event Info Section <=========================
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(AppIcons.dotIconForFamily),
                                                          SizedBox(width: 4.w),
                                                          Flexible(child: Text(event.schedule?.eventType ?? 'Onsite Event', style: TextStyle(fontSize: 8.sp, color: AppColors.color414141), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(AppIcons.dotIconForFamily),
                                                          SizedBox(width: 4.w),
                                                          Flexible(child: Text(event.location ?? 'Dhaka Bangladesh', style: TextStyle(fontSize: 8.sp, color: AppColors.color414141), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(AppIcons.dotIconForFamily),
                                                          SizedBox(width: 4.w),
                                                          Flexible(child: Text('History: 2023-1st winner', style: TextStyle(fontSize: 8.sp, color: AppColors.color808080), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
                                                        Text('Cost: \$${event.schedule?.cost ?? '100'}', style: TextStyle(fontSize: 8.sp, color: AppColors.color414141)),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                                                    child: Row(
                                                      children: [
                                                        SvgPicture.asset(AppIcons.dotIconForFamily),
                                                        SizedBox(width: 4.w),
                                                        Text('Deadline: ${deadline.isNotEmpty ? deadline : '1-6-2025'}', style: TextStyle(fontSize: 8.sp, color: AppColors.color414141)),
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
                                      onTap: (){
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
                              child: Icon(Icons.more_horiz, color:AppColors.greyColor),
                            ),
                          ],
                        )

                    );
                  },
                );
              }),
            )

          ],
        ),
      ),

    );
  }

  //============================> Search Bar Section <=================================
  _searchBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 271.w,
          child: CustomTextField(
            controller: _searchController,
            contenpaddingHorizontal: 12.w,
            contenpaddingVertical: 12.h,
            hintText: "Search Event",
            onFieldSubmitted: (value) {
              if (value.isNotEmpty) {
                Get.toNamed(AppRoutes.searchEventScreen,
                    arguments: {'searchTerm': value});
              }
            },
            sufixicons: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: GestureDetector(
                onTap: () {
                  if (_searchController.text.isNotEmpty) {
                    Get.toNamed(AppRoutes.searchEventScreen,
                        arguments: {'searchTerm': _searchController.text});
                  }
                },
                child: SvgPicture.asset(
                  AppIcons.search,
                  width: 24.w,
                  height: 24.h,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.myEventFilterScreen);
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.fillColor,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(width: 1.w, color: AppColors.primaryColor),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: SvgPicture.asset(
                AppIcons.filterIcon,
                width: 24.w,
                height: 24.h,
              ),
            ),
          ),
        )
      ],

    );
  }
}
