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
                  image: const DecorationImage(
                   // image: NetworkImage('https://static.gltjp.com/glt/data/directory/13000/12058/20210822_040201_6908e9ec_w1920.webp'),
                    image: AssetImage('assets/images/concert.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              CustomText(
                text: 'Total 50 Events', fontsize: 20.sp, color: AppColors.blackColor,fontWeight: FontWeight.w500),
              //=======================> Event Name Section <============================

              SizedBox(height: 8.h,),
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
                                    height: 75.h,
                                    width: 75.w,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                //===================== >> Event Details Section << =========================
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: event['title']!,
                                        fontsize: 14.sp,
                                        fontWeight: FontWeight.w500
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
            ],
          ),
        ),
      ),
    );
  }
}
