import 'package:event_sharing/utils/app_strings.dart';
import 'package:event_sharing/views/base/profile_ListTile.dart';
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
import '../../../base/custom_list_tile.dart';
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

                  //============================> Account List Tile <=================
                  ProfileListTile(title:AppStrings.account,
                    prefixIcon: SvgPicture.asset(AppIcons.ownershipIcon, color: AppColors.primaryColor),
                    suffixIcon: SvgPicture.asset(AppIcons.rightArrow,color: AppColors.primaryColor),),
                  //============================> My Family List Tile <=================
                  ProfileListTile(title:AppStrings.myFamily,
                    prefixIcon: SvgPicture.asset(AppIcons.ownershipIcon, color: AppColors.primaryColor),
                    suffixIcon: SvgPicture.asset(AppIcons.rightArrow,color: AppColors.primaryColor),),
                  //============================> My Event List Tile <=================
                  ProfileListTile(title:AppStrings.myEvent,
                    prefixIcon: SvgPicture.asset(AppIcons.ownershipIcon, color: AppColors.primaryColor),
                    suffixIcon: SvgPicture.asset(AppIcons.rightArrow,color: AppColors.primaryColor),),
                  //============================> Connection List Tile <=================
                  ProfileListTile(title:AppStrings.connection,
                    prefixIcon: SvgPicture.asset(AppIcons.ownershipIcon, color: AppColors.primaryColor),
                    suffixIcon: SvgPicture.asset(AppIcons.rightArrow,color: AppColors.primaryColor),),
                  //============================> Contribution List Tile <=================
                  ProfileListTile(title:AppStrings.contribution,
                    prefixIcon: SvgPicture.asset(AppIcons.ownershipIcon, color: AppColors.primaryColor),
                    suffixIcon: SvgPicture.asset(AppIcons.rightArrow,color: AppColors.primaryColor),),
                  //============================> Invitation List Tile <=================
                  ProfileListTile(title:AppStrings.invitation,
                    prefixIcon: SvgPicture.asset(AppIcons.ownershipIcon, color: AppColors.primaryColor),
                    suffixIcon: SvgPicture.asset(AppIcons.rightArrow,color: AppColors.primaryColor),),
                  //============================> Settings List Tile <=================
                  ProfileListTile(title:AppStrings.settings,
                    prefixIcon: SvgPicture.asset(AppIcons.ownershipIcon, color: AppColors.primaryColor),
                    suffixIcon: SvgPicture.asset(AppIcons.rightArrow,color: AppColors.primaryColor),),
                  //============================> About Us List Tile <=================
                  ProfileListTile(title:AppStrings.aboutUs,
                    prefixIcon: SvgPicture.asset(AppIcons.ownershipIcon, color: AppColors.primaryColor),
                    suffixIcon: SvgPicture.asset(AppIcons.rightArrow,color: AppColors.primaryColor),),
                  //============================> Terms and Conditions List Tile <=================
                  ProfileListTile(title:AppStrings.termsAndConditions,
                    prefixIcon: SvgPicture.asset(AppIcons.ownershipIcon, color: AppColors.primaryColor),
                    suffixIcon: SvgPicture.asset(AppIcons.rightArrow,color: AppColors.primaryColor),),
                  //============================> Privacy Policy List Tile <=================
                  ProfileListTile(title:AppStrings.privacyPolicy,
                    prefixIcon: SvgPicture.asset(AppIcons.ownershipIcon, color: AppColors.primaryColor),
                    suffixIcon: SvgPicture.asset(AppIcons.rightArrow,color: AppColors.primaryColor),),
                  //============================> Log Out List Tile <=================
                  ProfileListTile(title:AppStrings.logout,
                    prefixIcon: SvgPicture.asset(AppIcons.ownershipIcon, color: AppColors.primaryColor),
                    suffixIcon: SvgPicture.asset(AppIcons.rightArrow,color: AppColors.primaryColor),),

                  ///=====================================
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
                      Get.toNamed(AppRoutes.ownershipScreen);
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
                      Get.toNamed(AppRoutes.myEventScreen);
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
                      Get.toNamed(AppRoutes.settingsScreen);
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
