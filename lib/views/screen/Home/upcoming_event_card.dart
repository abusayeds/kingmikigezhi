import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_icons.dart';

class EventCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(

      color: const Color(0xffedf2f4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24.r),
                  child: Image.asset(
                    'assets/images/shoot.png',
                    height: 144.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  right: -4.w,
                  top: 6.h,
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
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Snowboard Festival', style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                          color: const Color(0xFF111111)
                        )),
                        SvgPicture.asset(
                          AppIcons.share,
                          color: AppColors.primaryColor,
                          height: 20.h,
                          width: 20.w,
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
                              Icon(Icons.circle, color: AppColors.primaryColor, size: 8.w),
                              SizedBox(width: 4.w),
                              Text('Onsite Event',style: GoogleFonts.poppins(color: AppColors.color414141,fontSize: 10.sp,fontWeight: FontWeight.w400))
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.circle,
                                  color: AppColors.primaryColor, size: 8.w),
                              SizedBox(width: 4.w),
                              Text('Dhaka Bangladesh',style: GoogleFonts.poppins(color: AppColors.color414141,fontSize: 10.sp,fontWeight: FontWeight.w400),)
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.circle,
                                  color: AppColors.primaryColor, size: 8.w),
                              SizedBox(width: 4.w),
                              Text('Cost-100',style: GoogleFonts.poppins(color: AppColors.color414141,fontSize: 10.sp,fontWeight: FontWeight.w400),)
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.circle, color: AppColors.primaryColor, size: 8.w),
                              SizedBox(width: 4.w),
                              Text('Deadline: 1-6-2025',style: GoogleFonts.poppins(color: AppColors.color414141,fontSize: 10.sp,fontWeight: FontWeight.w400),)
                            ],
                          ),
                        ],
                      ),
                      const Spacer()
                    ],
                  ),
                  //SizedBox(height: 8.h),
                   Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(
                        Icons.more_horiz_outlined,
                        color: AppColors.greyColor,
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
