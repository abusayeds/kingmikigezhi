import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../base/custom_text.dart';

class CategoriesSearchAppliedScreen extends StatefulWidget {
  @override
  State<CategoriesSearchAppliedScreen> createState() =>
      _CategoriesSearchAppliedScreenState();
}

class _CategoriesSearchAppliedScreenState
    extends State<CategoriesSearchAppliedScreen> {
  final List<Map<String, String>> events = [
    {
      "imageUrl": "assets/images/music.png",
      "title": "Bangla Music",
      "location": "Dhaka, Bangladesh",
      "time": "10:00 AM",
    },
    {
      "imageUrl": "assets/images/music.png",
      "title": "Bangla Music",
      "location": "Dhaka, Bangladesh",
      "time": "10:00 AM",
    },
    {
      "imageUrl": "assets/images/music.png",
      "title": "Bangla Music",
      "location": "Dhaka, Bangladesh",
      "time": "10:00 AM",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //=======================> App Bar Section <============================
      appBar: AppBar(
        title: CustomText(
          text: 'Concert',
          fontsize: 18.sp,
          fontWeight: FontWeight.w500,
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
              Stack(
                children: [
                  Image.asset('assets/images/upcoming.png'),
                  Positioned(
                    right: -5.w,
                    top: 5.h,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        border: Border.all(width: 1.w, color: Colors.white),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 16.h),
                        child: CustomText(
                          text: '20 Feb',
                          fontsize: 10.sp,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              CustomText(
                text: 'Total 50 Events', fontsize: 20.sp, color: AppColors.blackColor,fontWeight: FontWeight.w600),
              //=======================> Event Name Section <============================
              ListView.builder(
                itemCount: events.length,
                shrinkWrap: true, // Prevent ListView from taking infinite height
                physics: const NeverScrollableScrollPhysics(), // Disable scrolling inside ListView
                itemBuilder: (context, index) {
                  final event = events[index];

                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.eventDetailsScreen);
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(vertical: 8.h),
                      color: const Color(0xffedf2f4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 12.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //=====================> Event Image Section <=========================
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: Image.asset(
                                event['imageUrl']!,
                                height: 75.0.h,
                                width: 75.0.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            //=====================> Event Details Section <=========================
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: event['title']!,
                                    fontsize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  SizedBox(height: 8.h),
                                  //=====================> Event Info Section <=========================
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              SvgPicture.asset(AppIcons.dotIconForFamily),
                                              const SizedBox(width: 4),
                                              const Text(
                                                'Onsite Event',
                                                style: TextStyle(fontSize: 8),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              SvgPicture.asset(AppIcons.dotIconForFamily),
                                              const SizedBox(width: 4),
                                              const Text(
                                                'Dhaka Bangladesh',
                                                style: TextStyle(fontSize: 8),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              SvgPicture.asset(AppIcons.dotIconForFamily),
                                              const SizedBox(width: 4),
                                              const Text(
                                                'History: 2023-1st winner',
                                                style: TextStyle(fontSize: 8),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              SvgPicture.asset(AppIcons.dotIconForFamily),
                                              const SizedBox(width: 4),
                                              const Text(
                                                'Cost : \$100',
                                                style: TextStyle(fontSize: 8),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              SvgPicture.asset(AppIcons.dotIconForFamily),
                                              const SizedBox(width: 4),
                                              const Text(
                                                'Deadline: 1-6-2025',
                                                style: TextStyle(fontSize: 8),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // Aligning the More options icon to the right
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: const [
                                      Icon(
                                        Icons.more_horiz,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            //=====================> Share Icon <=========================
                            Padding(
                              padding: EdgeInsets.only(top: 8.h),
                              child: SvgPicture.asset(
                                AppIcons.share, // Share icon
                                width: 16.w,
                                height: 16.h,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
