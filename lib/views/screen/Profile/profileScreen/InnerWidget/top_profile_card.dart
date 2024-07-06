import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_images.dart';
import '../../../../../utils/app_strings.dart';
import '../../../../base/custom_text.dart';

class TopProfileCard extends StatelessWidget {
  final String? profileName;
  final String? profileUrl;
  final double? height;
  final String? badge;

  const TopProfileCard(
      {super.key, this.profileName, this.profileUrl, this.height, this.badge});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 395.h,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(AppImages.profileContainer), fit: BoxFit.cover),
      ),
      child: Column(
        children: [
          CustomText(
            text: AppStrings.profile,
            fontsize: 18.h,
            color: Colors.white,
            fontWeight: FontWeight.w500,
            bottom: 24.h,
            top: 65.h,
          ),
          Container(
              height: 120.h,
              width: 120.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.r),
                  ),
                  shape: BoxShape.rectangle,
                  border: Border.all(width: 2.w, color: AppColors.white)),

              //=======================> Profile Image <===========================
              child: profileUrl == null
                  ? Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  'https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg'),
                              fit: BoxFit.cover)),
                    )
                  : Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  'https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg'),
                              fit: BoxFit.cover)),
                    )),
          Expanded(
            child: CustomText(
              text: "Mr. Swapon" ?? "",
              fontsize: 20.h,
              color: Colors.white,
              fontWeight: FontWeight.w500,
              top: 18.h,
            ),
          ),
        ],
      ),
    );
  }
}
