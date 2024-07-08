import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../helpers/route.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/app_strings.dart';
import '../../../base/custom_list_tile.dart';
import '../../../base/custom_text.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      appBar: AppBar(
        title: CustomText(
          text: AppStrings.settings,
          fontsize: 18.h,
          fontWeight: FontWeight.w500,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          children: [
            //=================================> Change Password Section <=======================
            CustomListTile(
              onTap: () {
                Get.toNamed(AppRoutes.changePasswordScreen);
              },
              title: AppStrings.changePassword,
              prefixIcon: SvgPicture.asset(
                AppIcons.lockIcon,
                color: AppColors.primaryColor,
              ),
              suffixIcon: SvgPicture.asset(
                AppIcons.rightArrow,
                color: Colors.black,
              ),
            ),
            //=================================> Privacy Policy Section <=======================
            CustomListTile(
              onTap: () {
                 Get.toNamed(AppRoutes.privacyPolicyScreen);
              },
              title: AppStrings.privacyPolicy,
              prefixIcon: SvgPicture.asset(
                AppIcons.privacyIcon,
                color: AppColors.primaryColor,
              ),
              suffixIcon: SvgPicture.asset(
                AppIcons.rightArrow,
                color: Colors.black,
              ),
            ),
            //=================================> Terms & Conditions Section <=======================
            CustomListTile(
              onTap: () {
                 Get.toNamed(AppRoutes.termsConditionScreen);
              },
              title: AppStrings.termsAndConditions,
              prefixIcon: SvgPicture.asset(
                AppIcons.termsIcon,
                color: AppColors.primaryColor,
              ),
              suffixIcon: SvgPicture.asset(
                AppIcons.rightArrow,
                color: Colors.black,
              ),
            ),
            //=================================> About Us Section <=======================
            CustomListTile(
              onTap: () {
                 Get.toNamed(AppRoutes.aboutusScreen);
              },
              title: AppStrings.aboutUs,
              prefixIcon: SvgPicture.asset(
                AppIcons.aboutIcon,
                color: AppColors.primaryColor,
              ),
              suffixIcon: SvgPicture.asset(
                AppIcons.rightArrow,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
