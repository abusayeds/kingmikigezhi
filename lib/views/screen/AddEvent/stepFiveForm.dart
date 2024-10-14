import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_text.dart';

import 'package:event_sharing/views/base/custom_text_field.dart';
import 'package:event_sharing/views/screen/AddEvent/InnerWidget/dotted_border_container.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/app_strings.dart';


class StepFiveForm extends StatefulWidget {
  const StepFiveForm({super.key});

  @override
  State<StepFiveForm> createState() => _StepFiveFormState();
}

class _StepFiveFormState extends State<StepFiveForm> {
  final List<String> round = ['1st', '2nd','Silver','Gold'];
  final List<String> typeSession = ['Online', 'Offline','Hybrid'];


  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();


  final TextEditingController finalDatelineMonthController = TextEditingController();
  final TextEditingController finalDatelineDayController = TextEditingController();
  final TextEditingController finalDatelineYearController = TextEditingController();

  bool isSharedCommunityChecked = true;
  bool isUserAgreementChecked = false;

  String? _selectedType;
  String? _selectedRound;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CustomText(
                text: "Step 5: Own History",
                fontsize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            //registration date
            SizedBox(height: 12.h),
            //registration date
            CustomText(
              text: 'Session',
              fontsize: 14,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 12.h),
            InputDecorator(
              decoration: InputDecoration(
                fillColor: AppColors.colorEDF2F4,
                border: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: AppColors.primaryColor, width: 1.w),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: AppColors.primaryColor, width: 1.w),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: AppColors.primaryColor, width: 1.w),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  iconDisabledColor: AppColors.primaryColor,
                  iconEnabledColor: AppColors.primaryColor,
                  isExpanded: true,
                  value: _selectedType,
                  hint: CustomText(text: 'Type Session', fontsize: 14.sp),
                  items: typeSession.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedType = newValue;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Text('Record',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child:InputDecorator(
                    decoration: InputDecoration(
                      fillColor: AppColors.colorEDF2F4,
                      border: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: AppColors.primaryColor, width: 1.w),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: AppColors.primaryColor, width: 1.w),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: AppColors.primaryColor, width: 1.w),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        iconDisabledColor: AppColors.primaryColor,
                        iconEnabledColor: AppColors.primaryColor,
                        isExpanded: true,
                        value: _selectedRound,
                        hint: CustomText(text: 'Type Round', fontsize: 14.sp),
                        items: round.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedRound = newValue;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: CustomButton(
                    onTap: (){},
                    text: 'Add',
                    textColor: AppColors.textColor,
                  ),
                ),
              ],
            ),

            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Text('History',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.colorEDF2F4,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.all(color: AppColors.primaryColor, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(AppIcons.dotIconForFamily),
                              SizedBox(width: 4.w),
                              CustomText(
                                text: '2021 - 1st place winner',
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: SvgPicture.asset(AppIcons.editIcon)),
                              SizedBox(width: 4),
                              InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: SvgPicture.asset(AppIcons.trashIcon))
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(AppIcons.dotIconForFamily),
                              SizedBox(width: 4.w),
                              CustomText(
                                text: '2022 - 1st place winner',
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: SvgPicture.asset(AppIcons.editIcon)),
                              SizedBox(width: 4),
                              InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: SvgPicture.asset(AppIcons.trashIcon))
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(AppIcons.dotIconForFamily),
                              SizedBox(width: 4.w),
                              CustomText(
                                text: '2023 - 1st place winner',
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              InkWell(
                                  onTap: () {
                                    //  Get.back();
                                  },
                                  child: SvgPicture.asset(AppIcons.editIcon)),
                              SizedBox(width: 4),
                              InkWell(
                                  onTap: () {
                                    //Get.back();
                                  },
                                  child: SvgPicture.asset(AppIcons.trashIcon))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.h),
            // Shared community checkbox
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CheckboxListTile(
                  value: isSharedCommunityChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isSharedCommunityChecked = value ?? false;
                    });
                  },
                  title: Text("This is a shared community. All events are public"),
                  activeColor: AppColors.primaryColor,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                CheckboxListTile(
                  value: isUserAgreementChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isUserAgreementChecked = value ?? false;
                    });
                  },
                  title: Text("User agreement"),
                  activeColor: AppColors.primaryColor,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ],
            ),
            SizedBox(height: 50.h),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onTap: () {},
                    text: "Back",
                    color: AppColors.fillColor,
                    textColor: Colors.black,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: CustomButton(
                    onTap: () {},
                    text: "Next",
                    textColor: Colors.white,
                    color: AppColors.buttonColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
          ],
        ),
      )
    ]);
  }
}
