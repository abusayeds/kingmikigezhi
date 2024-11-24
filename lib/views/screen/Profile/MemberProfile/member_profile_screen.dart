import 'package:event_sharing/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../base/custom_text.dart';
import '../../../base/custom_list_tile.dart';
import 'InnerWidget/top_card.dart';

class MemberProfileScreen extends StatelessWidget {
  const MemberProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:  IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Colors.black, size: 18.w),
          onPressed: () {
            Get.back();
          },
        ),
        title: CustomText(
          text: 'Member Profile',
          fontWeight: FontWeight.bold,
          fontsize: 18.sp,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            children: [
              TopCard(),
              SizedBox(height: 24.h),
              //=================================> Profile Name <==========================
              CustomListTile(
                  title: 'Labu Bashar Islam'??'',
                  prefixIcon: _prefixIcon(AppIcons.singlePerson)),
              //=================================> Email Name <==========================
              CustomListTile(
                  title: 'Bashar12@gmail.com'??'',
                  prefixIcon: _prefixIcon(AppIcons.mailIcon)),
              //=================================> Phone Number <==========================
              CustomListTile(
                  title: '+88452416645'??'',
                  prefixIcon: _prefixIcon(AppIcons.phoneIcon)),
              //=================================> Location Name <==========================
              CustomListTile(
                  title: 'Rangpur Bangladesh'??'',
                  prefixIcon: _prefixIcon(AppIcons.locationIcon)),
              //=================================> Gender Number <========================
              CustomListTile(
                  title: 'Male'??'',
                  prefixIcon: _prefixIcon(
                    AppIcons.singlePerson,
                  )),
              //=================================> Birthday <========================
              CustomListTile(
                  title: '05-12-1995'??'',
                  prefixIcon: _prefixIcon(
                    AppIcons.cake,
                  )),
              //=================================> Address Number <========================
              CustomListTile(
                  title: 'Partner'?? '',
                  prefixIcon: _prefixIcon(
                    AppIcons.ownershipIcon,
                  )),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),

    );
  }

  _prefixIcon(String icon) {
    return SvgPicture.asset(icon, color: AppColors.primaryColor);
  }
}