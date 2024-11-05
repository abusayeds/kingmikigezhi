import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../base/custom_text.dart';

class TopProfileSection extends StatelessWidget {
  final String? name;
  final String? image;
  final VoidCallback? ontap;

  TopProfileSection({this.name, this.image, this.ontap});

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
                          border: Border.all(width: 2.w, color: AppColors.primaryColor)),
                      child: Image.asset('assets/images/ownerImage.png',fit: BoxFit.cover)

                     // Image.network('https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg', fit: BoxFit.cover,),
                    ),
                    SizedBox(width: 8),
                    //=================================> Profile Name <==========================
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: 'Bashar Islam',
                            textAlign: TextAlign.start,
                            fontsize: 20.sp,
                            color: Colors.white,
                          ),
                          //==========================> Edit Profile Button <==============================
                          Row(
                            children: [
                              InkWell(
                                  onTap:(){
                                    Get.toNamed(AppRoutes.editProfileScreen);
                                    },
                                  child: SvgPicture.asset(AppIcons.editIcon,color: Colors.white)),
                              SizedBox(width: 8),
                              InkWell(
                                  onTap:(){
                                    Get.toNamed(AppRoutes.changePasswordScreen);
                                    },
                                  child: SvgPicture.asset(AppIcons.keyIcon,color: Colors.white)),
                            ],
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