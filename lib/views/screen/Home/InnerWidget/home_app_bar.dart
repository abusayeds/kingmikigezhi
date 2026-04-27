import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../helpers/route.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../../controllers/auth_controller.dart';
import '../../../../utils/app_images.dart';
import '../../../base/custom_text.dart';

PreferredSize customHomeAppBar() {
  final AuthController controller = Get.find<AuthController>();
  return PreferredSize(
    preferredSize: Size.fromHeight(50.h), // Adjust height as needed
    child: AppBar(
      automaticallyImplyLeading: false,
      // backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 20.w,
      title: Obx(() {
        final user = controller.userProfile.value;
        return Row(
          children: [
            //==========================> Profile image <=============================
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.mapScreen);
                },
                child: Row(
                  children: [
                    Image.asset(AppImages.logo, width: 42.h, height: 42.h),
                    SizedBox(width: 6.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              AppIcons.locationIcon,
                              height: 20.h,
                              width: 20.w,
                              color: AppColors.primaryColor,
                            ),
                            SizedBox(width: 5.w),
                            CustomText(
                              text: user?['city'] ?? 'Dhaka',
                              fontsize: 14.h,
                              fontWeight: FontWeight.w500,
                            ),
                            SvgPicture.asset(
                              AppIcons.downArrowIcon,
                              width: 20.w,
                              height: 22.h,
                            )
                          ],
                        ),
                        CustomText(
                          text: user?['country'] ?? 'Banasree, Rampura',
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10.w),
            //=======================> Heart Button <=======================
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.suggestionDonationPage);
              },
              child: SvgPicture.asset(
                AppIcons.heart,
                color: AppColors.colorD9A951,
                height: 28.h,
                width: 32.w,
              ),
            ),
            SizedBox(width: 10.w),
            //=======================> Notifications Button <=======================
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.notificationsScreen);
              },
              child: Badge(
                backgroundColor: Colors.red,
                smallSize: 10,
                child: SvgPicture.asset(
                  AppIcons.notificationIcon,
                  color: AppColors.primaryColor,
                  height: 28.h,
                  width: 32.w,
                ),
              ),
            ),
            SizedBox(width: 13.w),
            //=======================> Profile Icon <=======================
            InkWell(
              onTap: () {
                Get.toNamed(AppRoutes.personalInformationScreen);
              },
              child: CircleAvatar(
                radius: 20.r,
                backgroundImage: user?['profilePicture'] != null &&
                        user!['profilePicture'].toString().isNotEmpty
                    ? NetworkImage(user['profilePicture'])
                    : const AssetImage('assets/images/ownerImage.png')
                        as ImageProvider,
              ),
            ),
          ],
        );
      }),
    ),
  );
}
