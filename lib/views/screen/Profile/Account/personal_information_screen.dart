import 'package:country_code_picker/country_code_picker.dart';
import 'package:event_sharing/controllers/auth_controller.dart';
import 'package:event_sharing/utils/app_strings.dart';
import 'package:event_sharing/utils/phone_utils.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/base/custom_text_field.dart';
import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/pull_to_refresh.dart';
import 'package:event_sharing/views/screen/Profile/Account/top_profile_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../base/custom_text.dart';
import '../../../base/custom_list_tile.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState
    extends State<PersonalInformationScreen> {
  final AuthController _authController = Get.find<AuthController>();

  final TextEditingController birthDayYearController =
      TextEditingController();
  final TextEditingController birthDayMonthController =
      TextEditingController();
  final TextEditingController birthDayDayController =
      TextEditingController();
  final TextEditingController locationCountryController =
      TextEditingController();
  final TextEditingController locationStateController =
      TextEditingController();
  final TextEditingController locationCityController =
      TextEditingController();
  final TextEditingController phoneNumberController =
      TextEditingController();

  String selectedCountryCodes = '+880';
  String selectedCountryIso = 'BD';

  // Skill dropdown state
  String? _selectedProgramId;
  int? _selectedYear;

  @override
  void initState() {
    super.initState();
    if (_authController.editOptionPrograms.isEmpty ||
        _authController.editOptionYears.isEmpty) {
      _authController.fetchEditOptions();
    }
  }

  @override
  void dispose() {
    birthDayYearController.dispose();
    birthDayMonthController.dispose();
    birthDayDayController.dispose();
    locationCountryController.dispose();
    locationStateController.dispose();
    locationCityController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 18.w),
          onPressed: () => Get.back(),
        ),
        title: CustomText(
          text: AppStrings.account,
          fontWeight: FontWeight.w500,
          fontsize: 18.sp,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        final profile = _authController.userProfile.value;
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
        final phoneNumber = profile?['phoneNumber'] ?? '';

        // Use skillLabels list (list of strings like "programName since year")
        final skillLabels =
            (profile?['skillLabels'] as List?)?.cast<String>() ?? [];

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

        // Pre-fill phone number once
        if (phoneNumber.isNotEmpty &&
            phoneNumberController.text.isEmpty) {
          // Strip dial code prefix if present, show local part
          phoneNumberController.text = phoneNumber;
          // Detect country from saved number so the flag matches
          final detected = PhoneUtils.detectCountry(phoneNumber);
          if (detected != null) {
            selectedCountryIso = detected.iso;
            selectedCountryCodes = detected.dialCode;
          }
        }

        final programs = _authController.editOptionPrograms;
        final years = _authController.editOptionYears;

        return PullToRefresh(
          onRefresh: () => _authController.fetchUserProfile(),
          child: SingleChildScrollView(
          physics: PullToRefresh.alwaysScrollable(),
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TopProfileSection(),
                SizedBox(height: 24.h),

                //============ Account ID ============
                Padding(
                  padding: EdgeInsets.all(4.r),
                  child: Text('Account ID',
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600)),
                ),
                CustomListTile(
                  title: accountId.toString(),
                  backgroundColor: AppColors.colorEDF2F4,
                  titleColor: AppColors.color414141,
                ),

                //============ First Name ============
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text('First Name',
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600)),
                ),
                CustomListTile(
                  title: firstName,
                  backgroundColor: AppColors.colorEDF2F4,
                  titleColor: AppColors.color414141,
                ),

                //============ Last Name ============
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text('Last Name',
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600)),
                ),
                CustomListTile(
                  title: lastName,
                  backgroundColor: AppColors.colorEDF2F4,
                  titleColor: AppColors.color414141,
                ),

                //============ Public Display Name ============
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text('Public Display Name',
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600)),
                ),
                CustomListTile(
                  title: username,
                  backgroundColor: AppColors.colorEDF2F4,
                  titleColor: AppColors.color414141,
                ),

                //============ Gender ============
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text('Gender',
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600)),
                ),
                CustomListTile(
                  title: genderDisplay,
                  backgroundColor: AppColors.colorEDF2F4,
                  titleColor: AppColors.color414141,
                ),

                //============ Birthday ============
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text('Birthday',
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 108.w,
                      child: CustomTextField(
                        controller: birthDayDayController..text = day,
                        hintText: 'Day',
                        readOnly: true,
                        hintTextStyle: TextStyle(
                            color: AppColors.color414141,
                            fontSize: 14.sp),
                      ),
                    ),
                    SizedBox(
                      width: 108.w,
                      child: CustomTextField(
                        controller:
                            birthDayMonthController..text = month,
                        hintText: 'Month',
                        readOnly: true,
                        hintTextStyle: TextStyle(
                            color: AppColors.color414141,
                            fontSize: 14.sp),
                      ),
                    ),
                    SizedBox(
                      width: 108.w,
                      child: CustomTextField(
                        controller: birthDayYearController..text = year,
                        hintText: 'Year',
                        readOnly: true,
                        hintTextStyle: TextStyle(
                            color: AppColors.color414141,
                            fontSize: 14.sp),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                //============ Email ============
                Padding(
                  padding: EdgeInsets.all(4.r),
                  child: Text('Email',
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600)),
                ),
                CustomListTile(
                  prefixIcon: Icon(Icons.email_rounded,
                      color: AppColors.primaryColor),
                  title: email,
                  backgroundColor: AppColors.colorEDF2F4,
                ),

                //============ Phone Number ============
                Padding(
                  padding: EdgeInsets.all(4.r),
                  child: Text('Phone Number',
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600)),
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
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: CountryCodePicker(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  enabled: false,
                                  showFlag: true,
                                  hideMainText: true,
                                  showFlagDialog: true,
                                  initialSelection: selectedCountryIso,
                                  favorite: const ['+880', 'BD'],
                                  showCountryOnly: false,
                                  showOnlyCountryWhenClosed: false,
                                  alignLeft: false,
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.only(right: 8.0),
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
                          readOnly: true,
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

                //============ Location ============
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text('Location',
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 108.w,
                      child: CustomTextField(
                        controller:
                            locationCountryController..text = country,
                        hintText: 'Country',
                        readOnly: true,
                        hintTextStyle: TextStyle(
                            color: AppColors.color414141,
                            fontSize: 14.sp),
                      ),
                    ),
                    SizedBox(
                      width: 108.w,
                      child: CustomTextField(
                        controller:
                            locationStateController..text = state,
                        hintText: 'State',
                        readOnly: true,
                        hintTextStyle: TextStyle(
                            color: AppColors.color414141,
                            fontSize: 14.sp),
                      ),
                    ),
                    SizedBox(
                      width: 108.w,
                      child: CustomTextField(
                        controller:
                            locationCityController..text = city,
                        hintText: 'City',
                        readOnly: true,
                        hintTextStyle: TextStyle(
                            color: AppColors.color414141,
                            fontSize: 14.sp),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                //============ Skill ============
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text('Skill',
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600)),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.colorEDF2F4,
                    borderRadius:
                        BorderRadius.all(Radius.circular(8.r)),
                    border: Border.all(
                        color: AppColors.primaryColor, width: 1.w),
                  ),
                  child: skillLabels.isEmpty
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 16.h, horizontal: 8.w),
                          child: Text(
                            'No skills added',
                            style: AppStyles.fontSize14(
                                color: AppColors.color414141),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: skillLabels.map((label) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 4.h),
                                child: Row(
                                  children: [
                                    // bullet + text — wrap in Expanded to prevent overflow
                                    Expanded(
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '\u2022 ',
                                              style: TextStyle(
                                                  color: AppColors
                                                      .primaryColor),
                                            ),
                                            TextSpan(
                                              text: label,
                                              style: AppStyles.fontSize14(
                                                  color: AppColors
                                                      .color414141),
                                            ),
                                          ],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    InkWell(
                                      onTap: () => Get.toNamed(
                                          AppRoutes.editProfileScreen),
                                      child: SvgPicture.asset(
                                        AppIcons.editIcon,
                                        colorFilter: ColorFilter.mode(
                                            AppColors.buttonColor,
                                            BlendMode.srcIn),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                ),
                SizedBox(height: 12.h),

                // ── Add Skill: Program + Year dropdowns from API ──
                // Obx(() {
                //   if (_authController.isLoadingEditOptions.value) {
                //     return Padding(
                //       padding: EdgeInsets.symmetric(vertical: 8.h),
                //       child: const Center(
                //           child: CircularProgressIndicator()),
                //     );
                //   }
                //   return Container(
                //     width: double.infinity,
                //     decoration: BoxDecoration(
                //       color: AppColors.colorEDF2F4,
                //       borderRadius:
                //           BorderRadius.all(Radius.circular(8.r)),
                //       border: Border.all(
                //           color: AppColors.primaryColor, width: 1.w),
                //     ),
                //     padding: EdgeInsets.symmetric(
                //         horizontal: 12.w, vertical: 12.h),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text(
                //           'Add Skill',
                //           style: AppStyles.fontSize14(
                //               color: AppColors.color414141,
                //               fontWeight: FontWeight.w600),
                //         ),
                //         SizedBox(height: 10.h),
                //         _buildDropdown<String>(
                //           hint: 'Select Program',
                //           value: _selectedProgramId,
                //           items: programs
                //               .map((p) => DropdownMenuItem<String>(
                //                     value: p['id'],
                //                     child: Text(p['name'] ?? ''),
                //                   ))
                //               .toList(),
                //           onChanged: (v) =>
                //               setState(() => _selectedProgramId = v),
                //         ),
                //         SizedBox(height: 10.h),
                //         _buildDropdown<int>(
                //           hint: 'Select Year',
                //           value: _selectedYear,
                //           items: years
                //               .map((y) => DropdownMenuItem<int>(
                //                     value: y,
                //                     child: Text(y.toString()),
                //                   ))
                //               .toList(),
                //           onChanged: (v) =>
                //               setState(() => _selectedYear = v),
                //         ),
                //       ],
                //     ),
                //   );
                // }),
                SizedBox(height: 16.h),
                CustomButton(
                  onTap: () => Get.toNamed(AppRoutes.editProfileScreen),
                  text: AppStrings.editProfile,
                  textColor: Colors.white,
                  color: AppColors.buttonColor,
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
        );
      }),
    );
  }

  Widget _buildDropdown<T>({
    required String hint,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.fillColor,
        border: Border.all(color: AppColors.primaryColor, width: 1.w),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: true,
          value: value,
          iconEnabledColor: AppColors.primaryColor,
          iconDisabledColor: AppColors.primaryColor,
          hint: Text(
            hint,
            style: TextStyle(
                color: AppColors.hintColor, fontSize: 14.sp),
          ),
          items: items,
          onChanged: items.isNotEmpty ? onChanged : null,
        ),
      ),
    );
  }

  double _getResponsiveHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    if (screenHeight < 600) return 48.h;
    if (screenHeight > 800) return 50;
    return 53.h;
  }
}
