import 'package:event_sharing/controllers/auth_controller.dart';
import 'package:event_sharing/views/base/app_remote_image.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/app_strings.dart';

class TopProfileCard extends StatefulWidget {
  final String? profileName;
  final String? profileUrl;
  final double? height;
  final String? badge;

  const TopProfileCard(
      {super.key, this.profileName, this.profileUrl, this.height, this.badge});

  @override
  State<TopProfileCard> createState() => _TopProfileCardState();
}

class _TopProfileCardState extends State<TopProfileCard> {
  final AuthController _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _authController.fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final profile = _authController.userProfile.value;
      final firstName = profile?['firstName'] ?? '';
      final lastName = profile?['lastName'] ?? '';
      final profilePicture = profile?['profilePicture'] ?? profile?['image'];

      return Container(
        height: 306.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.vertical(
            bottom: Radius.elliptical(MediaQuery.of(context).size.width, 40.w),
          ),

          /*    image: DecorationImage(
                image: AssetImage(AppImages.profileContainer), fit: BoxFit.-cover),*/
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
                  borderRadius: BorderRadius.circular(8.r),
                  color: Colors.grey[200],
                  shape: BoxShape.rectangle),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: profilePicture != null &&
                        profilePicture.toString().isNotEmpty
                    ? AppRemoteImage(
                        url: profilePicture,
                        fit: BoxFit.cover,
                        width: 120.w,
                        height: 120.h,
                      )
                    : Image.asset(
                        AppImages.logo,
                        fit: BoxFit.cover,
                        width: 120.w,
                        height: 120.h,
                      ),
              ),
            ),
            //=======================> Profile Image <===========================
            CustomText(
              text: "$firstName $lastName".trim().isNotEmpty
                  ? "$firstName $lastName"
                  : "",
              fontsize: 20.h,
              color: Colors.white,
              fontWeight: FontWeight.w500,
              top: 18.h,
            ),
          ],
        ),
      );
    });
  }
}
