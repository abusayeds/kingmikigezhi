import 'package:country_code_picker/country_code_picker.dart';
import 'package:event_sharing/utils/app_strings.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/base/custom_text_field.dart';
import 'package:event_sharing/views/screen/Profile/Account/top_profile_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../base/custom_text.dart';
import '../../../base/custom_list_tile.dart';

class PersonalInformationScreen extends StatefulWidget {
  PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  final TextEditingController birthDayYearController = TextEditingController();
  final TextEditingController birthDayMonthController = TextEditingController();
  final TextEditingController birthDayDayController = TextEditingController();

  final TextEditingController locationCountryController =
      TextEditingController();
  final TextEditingController locationStateController = TextEditingController();
  final TextEditingController locationCityController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  String selectedCountryCodes = '+880';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 18.w),
          onPressed: () {
            Get.back();
          },
        ),
        title: CustomText(
          text: AppStrings.account,
          fontWeight: FontWeight.w500,
          fontsize: 18.sp,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopProfileSection(),
              SizedBox(height: 24.h),
              //=================================> Profile Name <==========================
              Padding(
                padding: EdgeInsets.all(4.r),
                child: Text('Account ID',
                    style: AppStyles.fieldTitle()),
              ),
              CustomListTile(
                  title: '20103200' ?? '',
                  backgroundColor: AppColors.colorEDF2F4,
                  titleColor: AppColors.color414141),
              //=================================> Email Name <==========================
              Padding(
                padding: const EdgeInsets.all(4),
                child: Text('First Name',
                    style: AppStyles.fieldTitle()),
              ),
              CustomListTile(
                  title: 'Bashar Islam' ?? '',
                  backgroundColor: AppColors.colorEDF2F4,
                  titleColor: AppColors.color414141),
              //=================================> Phone Number <========================
              Padding(
                padding: EdgeInsets.all(4),
                child: Text('Last Name',
                    style: AppStyles.fieldTitle()),
              ),
              CustomListTile(
                  title: 'Rahman' ?? '',
                  backgroundColor: AppColors.colorEDF2F4,
                  titleColor: AppColors.color414141),
              //=================================> Address Number <========================
              Padding(
                padding: const EdgeInsets.all(4),
                child: Text('Public Display Name',
                    style: AppStyles.fieldTitle()),
              ),
              CustomListTile(
                  title: 'Dhaka' ?? '',
                  backgroundColor: AppColors.colorEDF2F4,
                  titleColor: AppColors.color414141),
              //=================================> Gender <========================
              Padding(
                padding: const EdgeInsets.all(4),
                child: Text('Gender',
                    style: AppStyles.fieldTitle()),
              ),
              CustomListTile(
                  title: 'Male' ?? '',
                  backgroundColor: AppColors.colorEDF2F4,
                  titleColor: AppColors.color414141),
              //==========================> Birth Date Text Field Row <=======================
              Padding(
                padding: const EdgeInsets.all(4),
                child: Text('Birthday',
                    style: AppStyles.fieldTitle()),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 108.w,
                    child: CustomTextField(
                      controller: birthDayYearController,
                      hintText: 'Day',
                      hintTextStyle: TextStyle(
                          color: AppColors.color414141, fontSize: 14.sp),
                      sufixicons: Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: SvgPicture.asset(
                          AppIcons.downArrowIcon,
                          width: 16.w,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 108.w,
                    child: CustomTextField(
                      controller: birthDayMonthController,
                      hintText: 'Month',
                      hintTextStyle: TextStyle(
                          color: AppColors.color414141, fontSize: 14.sp),
                      sufixicons: Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: SvgPicture.asset(
                          AppIcons.downArrowIcon,
                          width: 16.w,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 108.w,
                    child: CustomTextField(
                      controller: birthDayYearController,
                      hintText: 'Year',
                      hintTextStyle: TextStyle(
                          color: AppColors.color414141, fontSize: 14.sp),
                      sufixicons: Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: SvgPicture.asset(
                          AppIcons.downArrowIcon,
                          width: 16.w,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              //=================================> Email <========================
              Padding(
                padding: EdgeInsets.all(4.r),
                child: Text('Email',
                    style: AppStyles.fieldTitle()),
              ),
              CustomListTile(
                prefixIcon:
                    Icon(Icons.email_rounded, color: AppColors.primaryColor),
                title: 'email@gmail.com' ?? '',
                backgroundColor: AppColors.colorEDF2F4,
              ),
              //=======================> Phone Number Text Field <======================
              Padding(
                padding: EdgeInsets.all(4.r),
                child: Text('Phone Number',
                    style: AppStyles.fieldTitle()),
              ),
              SizedBox(
                // Solution 7: MediaQuery-based responsive height with constraints
                height: _getResponsiveHeight(context),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Country Code Container with fixed aspect ratio
                    AspectRatio(
                      aspectRatio: 2.2, // Maintains consistent proportions
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.fillColor,
                          border: Border.all(
                            width: 1.0,
                            color: AppColors.primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: CountryCodePicker(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                showFlag: false,
                                showFlagDialog: true,
                                onChanged: (countryCode) {
                                  setState(() {
                                    selectedCountryCodes = countryCode.dialCode!;
                                  });
                                },
                                initialSelection: 'BD',
                                favorite: const ['+880', 'BD'],
                                showCountryOnly: false,
                                showOnlyCountryWhenClosed: false,
                                alignLeft: false,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: SvgPicture.asset(
                                AppIcons.downArrowIcon,
                                width: 16.0,
                                height: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                     SizedBox(width: 10.w),

                    Expanded(
                      child: CustomTextField(
                        controller: phoneNumberController,
                        keyboardType: TextInputType.phone,
                        hintText: AppStrings.phoneNumberHintText,
                        hintTextStyle: TextStyle(
                          color: AppColors.color414141,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              //=================================> Location <========================
              Padding(
                padding: const EdgeInsets.all(4),
                child: Text('Location',
                    style: AppStyles.fieldTitle()),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 108.w,
                    child: CustomTextField(
                      controller: locationCountryController,
                      hintText: 'Country',
                      hintTextStyle: TextStyle(
                          color: AppColors.color414141, fontSize: 14.sp),
                      sufixicons: Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: SvgPicture.asset(
                          AppIcons.downArrowIcon,
                          width: 16.w,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 108.w,
                    child: CustomTextField(
                      controller: locationStateController,
                      hintText: 'State',
                      hintTextStyle: TextStyle(
                          color: AppColors.color414141, fontSize: 14.sp),
                      sufixicons: Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: SvgPicture.asset(
                          AppIcons.downArrowIcon,
                          width: 16.w,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 108.w,
                    child: CustomTextField(
                      controller: locationCityController,
                      hintText: 'City',
                      hintTextStyle: TextStyle(
                          color: AppColors.color414141, fontSize: 14.sp),
                      sufixicons: Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: SvgPicture.asset(
                          AppIcons.downArrowIcon,
                          width: 16.w,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              //=================================> Skill <========================
              Padding(
                padding: const EdgeInsets.all(4),
                child: Text('Skill',
                    style: AppStyles.fieldTitle()),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.colorEDF2F4,
                  borderRadius: BorderRadius.all(Radius.circular(8.r)),
                  border: Border.all(color: AppColors.primaryColor, width: 1.w),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '\u2022 ',
                                    style: TextStyle(
                                        color: AppColors.primaryColor),
                                  ),
                                  TextSpan(
                                      text: 'Chess since 2020',
                                      style: AppStyles.fontSize14(
                                          color: AppColors.color414141)),
                                ],
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: SvgPicture.asset(AppIcons.editIcon,color: AppColors.buttonColor))
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '\u2022 ',
                                    style: TextStyle(
                                        color: AppColors.primaryColor),
                                  ),
                                  TextSpan(
                                      text: 'Math since 2021',
                                      style: AppStyles.fontSize14(
                                          color: AppColors.color414141)),
                                ],
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: SvgPicture.asset(AppIcons.editIcon,color: AppColors.buttonColor))
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '\u2022 ',
                                    style: TextStyle(
                                        color: AppColors.primaryColor),
                                  ),
                                  TextSpan(
                                      text: 'Piano since 2023',
                                      style: AppStyles.fontSize14(
                                          color: AppColors.color414141)),
                                ],
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: SvgPicture.asset(AppIcons.editIcon,color: AppColors.buttonColor,))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  double _getResponsiveHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    // Base height with controlled scaling
    if (screenHeight < 600) {
      return 48.h; // Smaller screens
    } else if (screenHeight > 800) {
      return 50; // Larger screens
    }
    return 53.h; // Default
  }
}
