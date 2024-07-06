import 'package:event_sharing/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../helpers/route.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../base/bottom_menu..dart';
import '../../../base/custom_text.dart';
import 'InnerWidget/custom_alert.dart';
import 'InnerWidget/custom_list_tile.dart';
import 'InnerWidget/top_profile_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomMenu(3),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const TopProfileCard(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              child: Column(
                children: [
                  //============================> Personal Information List Tile <=================
                  CustomListTile(
                    onTap: () {
                      Get.toNamed(AppRoutes.personalInformationScreen);
                    },
                    title: AppStrings.personalInformation,
                    prefixIcon: SvgPicture.asset(AppIcons.singlePerson,
                        color: AppColors.primaryColor),
                    suffixIcon: SvgPicture.asset(AppIcons.rightArrow,
                        color: AppColors.primaryColor),
                  ),

                  //============================> OwnerShip List Tile <=================
                  CustomListTile(
                    onTap: () {
                      //Get.toNamed(AppRoutes.ownershipScreen);
                    },
                    title: AppStrings.ownership,
                    prefixIcon: SvgPicture.asset(AppIcons.ownershipIcon,
                        color: AppColors.primaryColor),
                    suffixIcon: SvgPicture.asset(AppIcons.rightArrow,
                        color: AppColors.primaryColor),
                  ),

                  //============================> Member Profile List Tile <=================
                  CustomListTile(
                    onTap: () {
                      Get.toNamed(AppRoutes.memberProfileScreen);
                    },
                    title: AppStrings.memberProfile,
                    prefixIcon: SvgPicture.asset(AppIcons.memberProfileIcon,
                        color: AppColors.primaryColor),
                    suffixIcon: SvgPicture.asset(AppIcons.rightArrow,
                        color: AppColors.primaryColor),
                  ),

                  //============================> My Donate List Tile <=================
                  CustomListTile(
                    onTap: () {
                      //Get.toNamed(AppRoutes.myDonateScreen);
                    },
                    title: AppStrings.myDonate,
                    prefixIcon: SvgPicture.asset(AppIcons.myDonateIcon,
                        color: AppColors.primaryColor),
                    suffixIcon: SvgPicture.asset(AppIcons.rightArrow,
                        color: AppColors.primaryColor),
                  ),

                  //============================> My Event List Tile <=================
                  CustomListTile(
                    onTap: () {
                      //Get.toNamed(AppRoutes.myEventScreen);
                    },
                    title: AppStrings.myEvent,
                    prefixIcon: SvgPicture.asset(AppIcons.myEventIcon,
                        color: AppColors.primaryColor),
                    suffixIcon: SvgPicture.asset(AppIcons.rightArrow,
                        color: AppColors.primaryColor),
                  ),

                  //============================> Settings List Tile <=================
                  CustomListTile(
                    onTap: () {
                      //Get.toNamed(AppRoutes.settingsScreen);
                    },
                    title: AppStrings.settings,
                    prefixIcon: SvgPicture.asset(AppIcons.settingsIcon,
                        color: AppColors.primaryColor),
                    suffixIcon: SvgPicture.asset(AppIcons.rightArrow,
                        color: AppColors.primaryColor),
                  ),

                  //============================> Logout List Tile <=================
                  CustomListTile(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return CustomAlert();
                          });
                    },
                    title: AppStrings.logout,
                    prefixIcon: SvgPicture.asset(AppIcons.logOutIcon,
                        color: AppColors.primaryColor),
                    suffixIcon: SvgPicture.asset(AppIcons.rightArrow,
                        color: AppColors.primaryColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
