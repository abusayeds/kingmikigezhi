
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../base/custom_text.dart';

class TopCard extends StatelessWidget {
  final String? name;
  final String? image;
  final VoidCallback? ontap;

  const TopCard({super.key, this.name, this.image, this.ontap});

  @override
  Widget build(BuildContext context) {
    return
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryColor),
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 11.h),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //=================================> Profile image <==========================
                  Container(
                    height: 120.h,
                    width: 120.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.r),
                        ),
                        shape: BoxShape.rectangle,
                        border: Border.all(width: 2.w, color: AppColors.white)),
                    child: Image.network(
                      'https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 8.w),

                  //=================================> Profile Name <==========================
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: 'Labu Bashar',
                          textAlign: TextAlign.start,
                          fontsize: 24.sp,
                          color: Colors.white,
                        ),
                        SizedBox(height: 16.h),
                        //==========================> Edit Profile Button <==============================
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10.w)),
                            border: Border.all(width: 2.w, color: Colors.white),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                            child: const CustomText(
                              text: 'User ID: 2010',
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
  }
}