import 'package:country_code_picker/country_code_picker.dart';
import 'package:event_sharing/controllers/auth_controller.dart';
import 'package:event_sharing/utils/app_strings.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/base/custom_text_field.dart';
import 'package:event_sharing/views/screen/Profile/Account/top_profile_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
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
    final AuthController authController = Get.find<AuthController>();

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
      body: Obx(() {
        final profile = authController.userProfile.value;
        final accountId = profile?['accountId'] ?? '';
        final firstName = profile?['firstName'] ?? '';
        final lastName = profile?['lastName'] ?? '';
        final username = profile?['username'] ?? '';
        final gender = profile?['gender'] ?? '';
        final birthDate = profile?['birthDate'] ?? '';
        final email = profile?['email'] ?? '';
        final country = profile?['country'] ?? '';
        final state = profile?['state'] ?? '';
        final city = profile?['city'] ?? '';
        final skills = profile?['skills'] as List? ?? [];
        final profilePicture = profile?['profilePicture'] ?? profile?['image'];

        String genderDisplay = '';
        if (gender.isNotEmpty) {
          genderDisplay = gender == 'MALE'
              ? 'Male'
              : (gender == 'FEMALE' ? 'Female' : 'Other');
        }

        String day = '';
        String month = '';
        String year = '';
        if (birthDate.isNotEmpty) {
          try {
            final date = DateTime.parse(birthDate);
            day = date.day.toString();
            month = date.month.toString();
            year = date.year.toString();
          } catch (_) {}
        }

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TopProfileSection(),
                SizedBox(height: 24.h),
                Padding(
                  padding: EdgeInsets.all(4.r),
                  child: Text('Account ID',
                      style: TextStyle(
                          fontSize: 13.sp, fontWeight: FontWeight.w600)),
                ),
                CustomListTile(
                    title: accountId.toString(),
                    backgroundColor: AppColors.colorEDF2F4,
                    titleColor: AppColors.color414141),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text('First Name',
                      style: TextStyle(
                          fontSize: 13.sp, fontWeight: FontWeight.w600)),
                ),
                CustomListTile(
                    title: firstName,
                    backgroundColor: AppColors.colorEDF2F4,
                    titleColor: AppColors.color414141),
                Padding(
                  padding: EdgeInsets.all(4),
                  child: Text('Last Name',
                      style: TextStyle(
                          fontSize: 13.sp, fontWeight: FontWeight.w600)),
                ),
                CustomListTile(
                    title: lastName,
                    backgroundColor: AppColors.colorEDF2F4,
                    titleColor: AppColors.color414141),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text('Public Display Name',
                      style: TextStyle(
                          fontSize: 13.sp, fontWeight: FontWeight.w600)),
                ),
                CustomListTile(
                    title: username,
                    backgroundColor: AppColors.colorEDF2F4,
                    titleColor: AppColors.color414141),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text('Gender',
                      style: TextStyle(
                          fontSize: 13.sp, fontWeight: FontWeight.w600)),
                ),
                CustomListTile(
                    title: genderDisplay,
                    backgroundColor: AppColors.colorEDF2F4,
                    titleColor: AppColors.color414141),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text('Birthday',
                      style: TextStyle(
                          fontSize: 13.sp, fontWeight: FontWeight.w600)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 108.w,
                      child: CustomTextField(
                        controller: birthDayDayController..text = day,
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
                        controller: birthDayMonthController..text = month,
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
                        controller: birthDayYearController..text = year,
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
                Padding(
                  padding: EdgeInsets.all(4.r),
                  child: Text('Email',
                      style: TextStyle(
                          fontSize: 13.sp, fontWeight: FontWeight.w600)),
                ),
                CustomListTile(
                  prefixIcon:
                      Icon(Icons.email_rounded, color: AppColors.primaryColor),
                  title: email,
                  backgroundColor: AppColors.colorEDF2F4,
                ),
                Padding(
                  padding: EdgeInsets.all(4.r),
                  child: Text('Phone Number',
                      style: TextStyle(
                          fontSize: 13.sp, fontWeight: FontWeight.w600)),
                ),
                SizedBox(
                  height: _getResponsiveHeight(context),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: 2.2,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  showFlag: false,
                                  showFlagDialog: true,
                                  onChanged: (countryCode) {
                                    setState(() {
                                      selectedCountryCodes =
                                          countryCode.dialCode!;
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
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text('Location',
                      style: TextStyle(
                          fontSize: 13.sp, fontWeight: FontWeight.w600)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 108.w,
                      child: CustomTextField(
                        controller: locationCountryController..text = country,
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
                        controller: locationStateController..text = state,
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
                        controller: locationCityController..text = city,
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
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text('Skill',
                      style: TextStyle(
                          fontSize: 13.sp, fontWeight: FontWeight.w600)),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.colorEDF2F4,
                    borderRadius: BorderRadius.all(Radius.circular(8.r)),
                    border:
                        Border.all(color: AppColors.primaryColor, width: 1.w),
                  ),
                  child: skills.isEmpty
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 16.h, horizontal: 8.w),
                          child: Text('No skills added',
                              style: AppStyles.fontSize14(
                                  color: AppColors.color414141)),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: skills.map((skill) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 4.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                              text: skill.toString(),
                                              style: AppStyles.fontSize14(
                                                  color:
                                                      AppColors.color414141)),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                        onTap: () {
                                          Get.back();
                                        },
                                        child: SvgPicture.asset(
                                            AppIcons.editIcon,
                                            color: AppColors.buttonColor))
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  double _getResponsiveHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    if (screenHeight < 600) {
      return 48.h;
    } else if (screenHeight > 800) {
      return 50;
    }
    return 53.h;
  }
}
