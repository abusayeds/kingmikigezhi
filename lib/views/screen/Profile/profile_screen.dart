import 'package:event_sharing/utils/app_strings.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/base/profile_ListTile.dart';
import 'package:event_sharing/views/screen/Profile/LogOut/logout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../helpers/route.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icons.dart';
import '../../base/bottom_menu..dart';
import 'top_profile_card.dart';

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
                  ProfileListTile(
                    onTap: (){
                        Get.toNamed(AppRoutes.personalInformationScreen);
                    },
                    title:AppStrings.account,
                    prefixIcon: SvgPicture.asset(AppIcons.accountIcon, color: AppColors.primaryColor),
                    suffixIcon: SvgPicture.asset(AppIcons.rightArrow,color: AppColors.primaryColor),),

                  //============================> My Family List Tile <=================
                  ProfileListTile(
                    onTap: () {
                      Get.toNamed(AppRoutes.myFamilyScreen);
                    },
                    title:AppStrings.myFamily,
                    prefixIcon: SvgPicture.asset(AppIcons.ownershipIcon, color: AppColors.primaryColor),
                    suffixIcon: SvgPicture.asset(AppIcons.rightArrow,color: AppColors.primaryColor),),

                  //============================> My Event List Tile <=================
                  ProfileListTile(
                    onTap: () {
                      Get.toNamed(AppRoutes.myEventScreen);
                    },
                    title:AppStrings.myEvent,
                    prefixIcon: SvgPicture.asset(AppIcons.myEventIcon, color: AppColors.primaryColor),
                    suffixIcon: SvgPicture.asset(AppIcons.rightArrow,color: AppColors.primaryColor),),

                  //============================> Connection List Tile <=================
                  ProfileListTile(
                    onTap: () {
                      Get.toNamed(AppRoutes.myConnectionScreen);
                    },
                    title:AppStrings.connection,
                    prefixIcon: SvgPicture.asset(AppIcons.myEventIcon, color: AppColors.primaryColor),
                    suffixIcon: SvgPicture.asset(AppIcons.rightArrow,color: AppColors.primaryColor),),
                  //============================> Contribution List Tile <=================
                  ProfileListTile(
                    onTap: () {
                      Get.toNamed(AppRoutes.myContributionScreen);
                    },
                    title:AppStrings.contribution,
                    prefixIcon: SvgPicture.asset(AppIcons.contribution, color: AppColors.primaryColor),
                    suffixIcon: SvgPicture.asset(AppIcons.rightArrow,color: AppColors.primaryColor),),

                  //============================> Invitation List Tile <=================
                  ProfileListTile(
                    onTap: () {
                      Get.toNamed(AppRoutes.myInvitationPage);
                    },
                    title:AppStrings.invitation,
                    prefixIcon: SvgPicture.asset(AppIcons.share, color: AppColors.primaryColor),
                    suffixIcon: SvgPicture.asset(AppIcons.rightArrow,color: AppColors.primaryColor),),
                  //============================> Settings List Tile <=================
                  ProfileListTile(
                    onTap: () {
                      Get.toNamed(AppRoutes.settingsScreen);
                    },
                    title:AppStrings.settings,
                    prefixIcon: SvgPicture.asset(AppIcons.settingsIcon, color: AppColors.primaryColor),
                    suffixIcon: SvgPicture.asset(AppIcons.rightArrow,color: AppColors.primaryColor),),

                  //============================> About Us List Tile <=================
                  ProfileListTile(
                    onTap: () {
                      Get.toNamed(AppRoutes.aboutusScreen);
                    },
                    title:AppStrings.aboutUs,
                    prefixIcon: SvgPicture.asset(AppIcons.aboutIcon, color: AppColors.primaryColor),
                    suffixIcon: SvgPicture.asset(AppIcons.rightArrow,color: AppColors.primaryColor),),

                  //============================> Terms and Conditions List Tile <=================
                  ProfileListTile(
                    onTap: () {
                      Get.toNamed(AppRoutes.termsConditionScreen);
                    },
                    title:AppStrings.termsAndConditions,
                    prefixIcon: SvgPicture.asset(AppIcons.documentIcon, color: AppColors.primaryColor),
                    suffixIcon: SvgPicture.asset(AppIcons.rightArrow,color: AppColors.primaryColor),),

                  //============================> Privacy Policy List Tile <=================
                  ProfileListTile(
                    onTap: () {
                      Get.toNamed(AppRoutes.privacyPolicyScreen);
                    },
                    title:AppStrings.privacyPolicy,
                    prefixIcon: SvgPicture.asset(AppIcons.shieldIcon, color: AppColors.primaryColor),
                    suffixIcon: SvgPicture.asset(AppIcons.rightArrow,color: AppColors.primaryColor),),

                    //============================> Log Out List Tile <=================
                  ProfileListTile(
                    onTap: () {
                      _showCustomBottomSheet(context);
                    },
                    title:AppStrings.logout,
                    prefixIcon: SvgPicture.asset(AppIcons.logOutIcon, color: AppColors.primaryColor),
                    suffixIcon: SvgPicture.asset(AppIcons.rightArrow,color: AppColors.primaryColor),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  //=========================>>>>>  Log out Custom BottomSheet    <<<================================
  void _showCustomBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.r),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
            color: AppColors.backgroundColor,
          ),
          height: 265,
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Divider(thickness: 1, color: AppColors.greyColor),
              SizedBox(height: 20.h),
              Text("Logout", style: AppStyles.h2(color: AppColors.primaryColor,fontWeight: FontWeight.w600),),
              Text("Are you sure you want to log out ?",
                style: AppStyles.h3(color: AppColors.borderColor),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 58),
                        backgroundColor:  AppColors.colorEDF2F4,
                        side: BorderSide(
                          width: 1,
                          color: AppColors.greyColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child:Text('Cancel',
                        style: AppStyles.h4(color: AppColors.primaryColor),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return const LogoutDialog();
                            });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 58),
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                      ),
                      child: Text('Yes',
                        style:  AppStyles.h4(color: AppColors.backgroundColor),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
