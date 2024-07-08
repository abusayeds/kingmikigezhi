import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../base/custom_text.dart';

class DetailsEventScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: CustomText(
            text: 'Details Event',
            fontsize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
          centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/images/upcoming.png'),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       CustomText(
                         text:  'Snowboard Festival',
                          fontWeight: FontWeight.w500,
                          fontsize: 18.sp,
                        ),
                       Icon(Icons.share, color: AppColors.primaryColor,),
                     ],
                   ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on, color: AppColors.primaryColor,),
                            SizedBox(width: 4.w),
                            Text('Dhaka, Bangladesh'),
                          ],
                        ),
                        CustomText(
                         text:  'Starting from',
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(AppIcons.myEventIcon, color: AppColors.primaryColor,),
                            SizedBox(width: 4.w),
                            Text('Online Event'),
                          ],
                        ),
                        Text(
                          '\$100',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    CustomText(
                      text: 'About Event',
                      fontsize: 18.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 8.h),
                    CustomText(
                      maxline: 20,
                      textAlign: TextAlign.start,
                      text:
                          'There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don\'t look even slightly believable.',
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      decoration: BoxDecoration(
                          color: const Color(0xff4a7b92),
                          borderRadius:
                              BorderRadius.all(Radius.circular(33.w))),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.w, vertical: 13.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                CustomText(
                                  text: 'Start Time',
                                  color: Colors.white,
                                ),
                                SizedBox(height: 4.h),
                                CustomText(
                                  text: '10.30AM',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontsize: 18.sp,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                CustomText(
                                  text: 'End Time',
                                  color: Colors.white,
                                ),
                                SizedBox(height: 4.h),
                                CustomText(
                                  text: '8.30PM',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontsize: 18.sp,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    CustomText(
                     text:  'Event Map',
                      fontsize: 18.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: Image.asset(
                          'assets/images/map.png', // Replace with actual map image or use a Map widget
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
