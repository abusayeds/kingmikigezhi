import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';



class StepFiveForm extends StatefulWidget {
  const StepFiveForm({super.key});

  @override
  State<StepFiveForm> createState() => _StepFiveFormState();
}

class _StepFiveFormState extends State<StepFiveForm> {
  final List<String> roundList = ['1st', '2nd','Silver','Gold'];
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Text("Step 5: Own History", style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600)),
              ),
              //registration date
              SizedBox(height: 12.h),
             Text('Session', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              SizedBox(height: 12.h),
              Container(
                height: AppStyles.standardHeight,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  color: AppColors.fillColor,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.primaryColor, width: 1),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(

                    value: _selectedType,
                    dropdownColor: AppColors.fillColor,
                    menuWidth: 240.w,
                    borderRadius: BorderRadius.circular(8.r),
                    hint: Text("Type Session", style: AppStyles.fontSize14(color: AppColors.color414141)),
                    icon: SvgPicture.asset(AppIcons.downArrowIcon, width: 16.w, color: AppColors.primaryColor,
                    ),
                    isExpanded: true,
                    items:typeSession.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedType = newValue;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Text('Record', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      height: AppStyles.standardHeight,
                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                      decoration: BoxDecoration(
                        color: AppColors.fillColor,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: AppColors.primaryColor, width: 1),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedRound,
                          dropdownColor: AppColors.fillColor,
                          menuWidth: 240.w,
                          borderRadius: BorderRadius.circular(8.r),
                          hint: Text("Type Score",style: AppStyles.fontSize14(color: AppColors.color414141)),
                          icon: SvgPicture.asset(AppIcons.downArrowIcon, width: 16.w, color: AppColors.primaryColor,
                          ),
                          isExpanded: true,
                          items: roundList.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
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
                      borderColor: AppColors.buttonA47059,
                      color: AppColors.buttonA47059,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.all(4.r),
                child: Text('History', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.colorEDF2F4,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: AppColors.primaryColor, width: 1.w),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(AppIcons.dotIconForFamily),
                                SizedBox(width: 4.w),
                                CustomText(
                                  text: '2021 - 1st place winner',
                                  color: AppColors.color414141,
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
                                SizedBox(width: 4.w),
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
                        padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(AppIcons.dotIconForFamily),
                                SizedBox(width: 4.w),
                                CustomText(
                                  text: '2022 - 1st place winner',
                                  color: AppColors.color414141,
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
                                  color: AppColors.color414141,
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
              SizedBox(height: 16.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16.sp,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          'This is a shared community. All events are public',
                          style: AppStyles.fontSize12(color: AppColors.hintColor)
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 20.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueGrey),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'User agreement',
                          style: AppStyles.fontSize12(color: AppColors.hintColor)
                      ),
                    ],
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
                      borderColor: AppColors.buttonColor,
                      color: AppColors.fillColor,
                      textColor: Colors.black,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: CustomButton(
                      onTap: () {},
                      text: "Add & Share",
                      textColor: Colors.white,
                      borderColor: AppColors.buttonColor,
                      color: AppColors.buttonColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
            ],
          ),
        )
      ]),
    );
  }
}
