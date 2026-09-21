import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../helpers/route.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../../controllers/auth_controller.dart';
import '../../../../controllers/notification_controller.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/media_url_utils.dart';
import '../../../base/custom_text.dart';

PreferredSize customHomeAppBar() {
  final AuthController controller = Get.find<AuthController>();
  final NotificationController notificationController =
      Get.find<NotificationController>();

  return PreferredSize(
    preferredSize: Size.fromHeight(50.h),
    child: AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 20.w,
      title: Obx(() {
        final user = controller.userProfile.value;
        final city = (user?['city'] ?? '').toString().trim();
        final state = (user?['state'] ?? '').toString().trim();
        final country = (user?['country'] ?? '').toString().trim();
        final locationLabel = (user?['location'] ?? '').toString().trim();

        final primaryLocation = city.isNotEmpty
            ? city
            : (locationLabel.isNotEmpty
                ? locationLabel.split(',').first.trim()
                : 'Select location');
        final secondaryLocation = [
          if (state.isNotEmpty) state,
          if (country.isNotEmpty) country,
        ].join(', ');
        final secondaryText = secondaryLocation.isNotEmpty
            ? secondaryLocation
            : (locationLabel.isNotEmpty ? locationLabel : '');

        final unread = notificationController.unreadCount.value;

        return Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final result = await Get.toNamed(AppRoutes.mapScreen);
                  if (result is Map) {
                    // Force refresh so city/country show immediately.
                    await controller.fetchUserProfile();
                  }
                },
                child: Row(
                  children: [
                    Image.asset(AppImages.logo, width: 42.h, height: 42.h),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Column(
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
                              Flexible(
                                child: CustomText(
                                  text: primaryLocation,
                                  fontsize: 14.h,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SvgPicture.asset(
                                AppIcons.downArrowIcon,
                                width: 20.w,
                                height: 22.h,
                              )
                            ],
                          ),
                          if (secondaryText.isNotEmpty)
                            CustomText(text: secondaryText),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10.w),
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
            GestureDetector(
              onTap: () async {
                await Get.toNamed(AppRoutes.notificationsScreen);
                notificationController.getNotifications();
              },
              child: unread > 0
                  ? Badge(
                      backgroundColor: Colors.red,
                      label: Text(
                        unread > 99 ? '99+' : '$unread',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: SvgPicture.asset(
                        AppIcons.notificationIcon,
                        color: AppColors.primaryColor,
                        height: 28.h,
                        width: 32.w,
                      ),
                    )
                  : SvgPicture.asset(
                      AppIcons.notificationIcon,
                      color: AppColors.primaryColor,
                      height: 28.h,
                      width: 32.w,
                    ),
            ),
            SizedBox(width: 13.w),
            InkWell(
              onTap: () {
                Get.toNamed(AppRoutes.personalInformationScreen);
              },
              child: Builder(builder: (context) {
                // Skip SVG / default-user placeholders (they 403 and are not
                // decodable by NetworkImage).
                final imageUrl = MediaUrlUtils.resolve(
                  user?['profilePicture'] ?? user?['image'],
                );
                final bool hasImage = imageUrl != null && imageUrl.isNotEmpty;
                return CircleAvatar(
                  radius: 20.r,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: AssetImage(AppImages.logo),
                  foregroundImage:
                      hasImage ? NetworkImage(imageUrl) : null,
                  onForegroundImageError: hasImage ? (_, __) {} : null,
                );
              }),
            ),
          ],
        );
      }),
    ),
  );
}
