import 'package:event_sharing/utils/app_strings.dart';
import 'package:event_sharing/views/screen/Profile/Personalinform/InnerWidget/top_profile_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../base/custom_text.dart';
import '../../../base/custom_list_tile.dart';

class PersonalInformationScreen extends StatelessWidget {
  const PersonalInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: AppStrings.personalInformation,
          fontWeight: FontWeight.w500,
          fontsize: 18.sp,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            children: [
              TopProfileSection(),
              SizedBox(height: 24.h),
              //=================================> Profile Name <==========================
              CustomListTile(
                  title: 'Mr Swapon'??'',
                  prefixIcon: _prefixIcon(AppIcons.singlePerson)),
              //=================================> Email Name <==========================
              CustomListTile(
                  title: 'mrswapon15@gmail.com'??'',
                  prefixIcon: _prefixIcon(AppIcons.mailIcon)),
              //=================================> Phone Number <========================
              CustomListTile(
                  title: '+8801610663268'??'',
                  prefixIcon: _prefixIcon(
                    AppIcons.phoneIcon,
                  )),
              //=================================> Address Number <========================
              CustomListTile(
                  title: '05 Banasree Rd. Santa Tower, Rampura 1212 '??'',
                  prefixIcon: _prefixIcon(
                    AppIcons.locationIcon,
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