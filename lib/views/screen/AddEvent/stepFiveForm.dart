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
           Text('Session',
                style: AppStyles.fontSize16(fontWeight: FontWeight.w500)),
            SizedBox(height: 12.h),
            Container(
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
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Text('Record',
                  style: AppStyles.fontSize16(fontWeight: FontWeight.w500)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                  ),
                ),
              ],
            ),

            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Text('History',
                  style: AppStyles.fontSize16(fontWeight: FontWeight.w500)),
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
                        style: AppStyles.fontSize14(color: AppColors.hintColor)
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
                        style: AppStyles.fontSize14(color: AppColors.hintColor)
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
