import 'package:event_sharing/views/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_icons.dart';

class EventCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xffedf2f4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/shoot.png',
                    height: 160.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  right: -5.w,
                  top: 5.h,
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        border: Border.all(width: 1.w, color: Colors.white),
                        shape: BoxShape.circle
                        // borderRadius: BorderRadius.circular(20.r),
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: 'Snowboard Festival',
                          fontWeight: FontWeight.w500,
                        ),
                        SvgPicture.asset(
                          AppIcons.share,
                          color: AppColors.primaryColor,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.circle,
                                  color: AppColors.primaryColor, size: 12.w),
                              SizedBox(width: 8.w),
                              CustomText(text: 'Onsite Event'),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.circle,
                                  color: AppColors.primaryColor, size: 12.w),
                              SizedBox(width: 8.w),
                              CustomText(text: 'Dhaka Bangladesh'),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.circle,
                                  color: AppColors.primaryColor, size: 12.w),
                              SizedBox(width: 8.w),
                              CustomText(text: ' Cost-100'),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.circle,
                                  color: AppColors.primaryColor, size: 12.w),
                              SizedBox(width: 8.w),
                              CustomText(text: 'Deadline: 1-6-2025'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  const Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(
                        Icons.more_horiz_outlined,
                        color: Colors.grey,
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
