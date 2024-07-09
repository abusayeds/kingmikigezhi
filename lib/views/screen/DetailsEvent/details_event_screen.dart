import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../base/custom_text.dart';

class DetailsEventScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //=======================> App Bar Section <============================
      appBar: AppBar(
          title: CustomText(
            text: AppStrings.detailsEvent,
            fontsize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
          centerTitle: true),
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
                          shape: BoxShape.circle),
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
              //=======================> Event Name Section <============================
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: 'Snowboard Festival',
                        fontWeight: FontWeight.w500,
                        fontsize: 16.sp,
                      ),
                      //===========================> Share Icon Button <======================
                      InkWell(
                          onTap: () {},
                          child: Icon(
                            Icons.share,
                            color: AppColors.primaryColor,
                            size: 20.h,
                          )),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //===========================> Location Row <======================
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: AppColors.primaryColor,
                          ),
                          SizedBox(width: 4.w),
                          CustomText(
                            text: 'Dhaka, Bangladesh',
                            fontsize: 10.sp,
                          ),
                        ],
                      ),
                      CustomText(text: 'Starting from', fontsize: 10.sp),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //===========================> Online Event Row <======================
                      Row(
                        children: [
                          SvgPicture.asset(
                            AppIcons.myEventIcon,
                            color: AppColors.primaryColor,
                          ),
                          SizedBox(width: 4.w),
                          CustomText(text: 'Online Event', fontsize: 10.sp),
                        ],
                      ),
                      CustomText(
                        text: '\$100',
                        fontsize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  //=======================> About Event Section <============================
                  SizedBox(height: 16.h),
                  CustomText(
                    text: AppStrings.aboutEvent,
                    fontsize: 16.sp,
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
                  //=======================> Start Time Section <============================
                  Container(
                    decoration: BoxDecoration(
                        color: const Color(0xff4a7b92),
                        borderRadius: BorderRadius.all(Radius.circular(33.w))),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.w, vertical: 13.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              CustomText(
                                text: AppStrings.startTime,
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
                                text: AppStrings.endTime,
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
                  //=======================> Event Map Section <============================
                  CustomText(
                    text: AppStrings.eventMap,
                    fontsize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: Image.asset(
                        'assets/images/map.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
