import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';

import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:event_sharing/views/base/custom_text_field.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AppliedSearchEventListScreen extends StatefulWidget {
  AppliedSearchEventListScreen({super.key});

  @override
  State<AppliedSearchEventListScreen> createState() => _AppliedSearchEventListScreenState();
}

class _AppliedSearchEventListScreenState extends State<AppliedSearchEventListScreen> {
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
  ];
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:  IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Colors.black, size: 18.w),
          onPressed: () {
            Get.back();
          },
        ),
        title: CustomText(
          text: 'Applied Event',
          fontWeight: FontWeight.bold,
          fontsize: 18.sp,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 24.w,vertical: 10),
        child: Column(
          children: [
            //==============================> Create Event Button <=======================
            _searchBar(),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(

                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Total Event :',style: AppStyles.fontSize16(fontWeight: FontWeight.w600)),
                          Padding(
                            padding:   EdgeInsets.only(top: 1.8.h),
                            child: Text('  500',style: AppStyles.fontSize12()),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Total Cost :',style: AppStyles.fontSize16(fontWeight: FontWeight.w600)),
                          Padding(
                            padding:   EdgeInsets.only(top: 1.8.h),
                            child: Text('  200',style: AppStyles.fontSize12()),
                          ),

                        ],
                      ),

                    ],
                  ),
                ),
              ],
            ),

            //=================================> Event List view <========================
            Expanded(
              child: ListView.builder(
                itemCount: 2,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.eventDetailsScreen);
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
                                    child: Image.asset(
                                      event['imageUrl']!,
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
                                        Text(event['title']!,style: AppStyles.fontSize14(fontWeight: FontWeight.w600)),

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
                                                      Text('Onsite Event', style: TextStyle(fontSize: 8.sp, color: AppColors.color414141)),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                                                  child: Row(
                                                    children: [
                                                      SvgPicture.asset(AppIcons.dotIconForFamily),
                                                      SizedBox(width: 4.w),
                                                      Text('Dhaka Bangladesh', style: TextStyle(fontSize: 8.sp, color: AppColors.color414141)),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                                                  child: Row(
                                                    children: [
                                                      SvgPicture.asset(AppIcons.dotIconForFamily),
                                                      SizedBox(width: 4.w),
                                                      Text('History: 2023-1st winner', style: TextStyle(fontSize: 8.sp, color: AppColors.color808080)),
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
                                                      Text('Cost: \$100', style: TextStyle(fontSize: 8.sp, color: AppColors.color414141)),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                                                  child: Row(
                                                    children: [
                                                      SvgPicture.asset(AppIcons.dotIconForFamily),
                                                      SizedBox(width: 4.w),
                                                      Text('Deadline: 1-6-2025', style: TextStyle(fontSize: 8.sp, color: AppColors.color414141)),
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
              ),
            )
          ],
        ),
      ),
    );
  }
  //============================> Search Bar Section <=================================
  _searchBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: TextFormField(
            controller: _searchController,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.fillColor,
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              hintText: "Search Event",
              hintStyle: AppStyles.fontSize14(color: AppColors.greyColor),
              suffixIcon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: SvgPicture.asset(
                  AppIcons.search,
                  width: 24.w,
                  height: 24.h,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppColors.primaryColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppColors.primaryColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppColors.primaryColor, width: 2.w),
              ),
            ),
          ),
        ),
        SizedBox(width: 18.w),
        GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.filterScreen);
          },
          child: Container(
            height: 53.h,
            width: 53.h,
            decoration: BoxDecoration(
              color: AppColors.fillColor,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(width: 1.w, color: AppColors.primaryColor),
            ),
            child: Center(
              child: SvgPicture.asset(
                AppIcons.filterIcon,
                width: 24.w,
                height: 24.h,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
