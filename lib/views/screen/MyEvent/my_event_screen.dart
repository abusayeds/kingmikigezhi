import 'package:event_sharing/views/screen/MyEvent/InnerWidget/delete_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../helpers/route.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_strings.dart';
import '../../base/custom_text.dart';

class MyEventScreen extends StatefulWidget {
  const MyEventScreen({super.key});

  @override
  State<MyEventScreen> createState() => _MyEventScreenState();
}

class _MyEventScreenState extends State<MyEventScreen> {
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
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //=======================> App Bar Section <============================
      appBar: AppBar(
          title: CustomText(
            text: AppStrings.myEvent,
            fontsize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
          centerTitle: true),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            //==============================> Create Event Button <=======================
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: (){
                  Get.toNamed(AppRoutes.createEventOne);
                },
                child: Container(
                  width: 118.w,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(20.r)),
                      border: Border.all(width: 1.w, color: AppColors.primaryColor)
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    child: Row(
                      children: [
                        Icon(Icons.add_circle_outlined, color: Colors.white,size: 16.h,),
                        SizedBox(width: 5.w),
                        CustomText(
                          text: 'Create Event',
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            //=================================> Event List view <========================
            Expanded(
              child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return GestureDetector(
                    onTap: (){
                      Get.toNamed(AppRoutes.detailsEventScreen);
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(vertical: 8.h),
                      color: const Color(0xffedf2f4),
                      child: Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        child: Row(
                          children: [
                            //=====================> Event Image Section <=========================
                            Container(
                              width: 77.w,
                              height: 76.h,
                              decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10.r))),
                              child: Image.asset(
                                event['imageUrl']!,
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
                                    text: event['title']!,
                                    fontsize: 14.sp,
                                  ),
                                  SizedBox(height: 8.h),
                                  //=====================> Event Location Section <=========================
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        AppIcons.locationIcon,
                                        color: AppColors.primaryColor,
                                      ),
                                      CustomText(
                                        text: event['location']!,
                                        fontsize: 10.sp,
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
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return DeleteAlert();
                                          });
                                    },
                                    child:  SvgPicture.asset(
                                      AppIcons.delete,width: 32.w,height: 32.h,
                                    ),),
                                SizedBox(height: 8.h),
                                //=====================> Event Time Section <=========================
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    SvgPicture.asset(
                                      AppIcons.timeIcon,
                                      color: AppColors.primaryColor,
                                    ),
                                    SizedBox(width: 5.w),
                                    CustomText(text: event['time']!),
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
              ),
            ),
          ],
        ),
      ),

    );
  }
}
