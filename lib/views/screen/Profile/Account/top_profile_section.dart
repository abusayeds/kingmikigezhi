import 'package:event_sharing/controllers/auth_controller.dart';
import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_images.dart';
import '../../../base/custom_text.dart';

class TopProfileSection extends StatelessWidget {
  final String? name;
  final String? image;
  final VoidCallback? ontap;

  const TopProfileSection({super.key, this.name, this.image, this.ontap});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Obx(() {
      final profile = authController.userProfile.value;
      final firstName = profile?['firstName'] ?? '';
      final lastName = profile?['lastName'] ?? '';
      final profilePicture = profile?['profilePicture'] ?? profile?['image'];
      final hasPicture =
          profilePicture != null && profilePicture.toString().trim().isNotEmpty;

      return Container(
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
                  // Same avatar style as Profile screen (TopProfileCard)
                  Container(
                    height: 120.h,
                    width: 120.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: Colors.grey[200],
                      shape: BoxShape.rectangle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: hasPicture
                          ? Image.network(
                              profilePicture.toString(),
                              fit: BoxFit.cover,
                              width: 120.w,
                              height: 120.h,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                AppImages.logo,
                                fit: BoxFit.cover,
                                width: 120.w,
                                height: 120.h,
                              ),
                            )
                          : Image.asset(
                              AppImages.logo,
                              fit: BoxFit.cover,
                              width: 120.w,
                              height: 120.h,
                            ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "$firstName $lastName".trim().isNotEmpty
                              ? "$firstName $lastName"
                              : '',
                          textAlign: TextAlign.start,
                          fontsize: 20.sp,
                          color: Colors.white,
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.toNamed(AppRoutes.editProfileScreen);
                              },
                              child: SvgPicture.asset(
                                AppIcons.editIcon,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () {
                                Get.toNamed(AppRoutes.changePasswordScreen);
                              },
                              child: SvgPicture.asset(
                                AppIcons.keyIcon,
                                color: Colors.white,
                              ),
                            ),
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
    });
  }
}
