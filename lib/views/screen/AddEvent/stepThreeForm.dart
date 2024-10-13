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

class StepThreeForm extends StatefulWidget {
  const StepThreeForm({super.key});

  @override
  State<StepThreeForm> createState() => _StepThreeFormState();
}

class _StepThreeFormState extends State<StepThreeForm> {
  final List<String> cost = ['Has Final Deadline', 'Has Late Fee'];
  final List<String> round = ['First', 'Second'];


  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  final TextEditingController finalDatelineMonthController = TextEditingController();
  final TextEditingController finalDatelineDayController = TextEditingController();
  final TextEditingController finalDatelineYearController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController deadLineDateController = TextEditingController();
  final TextEditingController deadLineTimeController = TextEditingController();
  final TextEditingController lateFee = TextEditingController();

  final TextEditingController payment = TextEditingController();
  String? _selectedCost;
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
                text: "Step 3: Group/Category",
                fontsize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            //registration date
            SizedBox(height: 12.h),
            //registration date
            CustomText(
              text: 'Define Group/Category',
              fontsize: 14,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: dateController,
                    hintText: 'Group/Category',
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
                SizedBox(width: 15.w),
                Expanded(
                  child: CustomTextField(
                    controller: dateController,
                    hintText: 'Condition',
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
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: payment,
                    hintText: '\$',
                  ),
                ),
                SizedBox(width: 15.w),
                SizedBox(
                  width: 80.w,
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
              child: Text('Added Group/Category',
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
                         CustomText(
                           text: '1 Age up to 10 years old',
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
                          CustomText(
                            text: '2 Age up to 15 years old',
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
                          CustomText(
                            text: '3 Age up to 18 years old',
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
            //======================>> Defile Round
            DottedBorderContainer(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Defile Round ',
                      fontsize: 16,
                      fontWeight: FontWeight.w600,
                    ),
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
                          value: _selectedRound,
                          hint: CustomText(text: 'Select Cost', fontsize: 14.sp),
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
                    SizedBox(height: 12.h),
                    //deadline date
                    CustomText(
                      text: 'Deadline ',
                      fontsize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomTextField(
                            prifixicon: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.calendar_today_rounded)),
                            controller: deadLineDateController,
                            hintText: 'Date',
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
                        SizedBox(width: 15.w),
                        Expanded(
                          child: CustomTextField(
                            prifixicon: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.watch_later_rounded)),
                            controller: deadLineTimeController,
                            hintText: 'Time',
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
                    //cost
                    SizedBox(height: 12.h),
                    CustomText(
                      text: 'Cost ',
                      fontsize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 12.h),
                    CustomTextField(
                      controller: dateController,
                      hintText: '\$',
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
                          value: _selectedCost,
                          hint: CustomText(text: 'Select Cost', fontsize: 14.sp),
                          items: cost.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCost = newValue;
                            });
                          },
                        ),
                      ),
                    ),

                    //final date
                    SizedBox(height: 12.h),
                    CustomText(
                      text: 'Final Deadline',
                      fontsize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 108.w,
                          child: CustomTextField(
                            controller: finalDatelineYearController,
                            hintText: 'Year',
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
                            controller: finalDatelineMonthController,
                            hintText: 'Month',
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
                            controller: finalDatelineDayController,
                            hintText: 'Day',
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
                    SizedBox(height: 16.h),
                    CustomText(
                      text: 'Late fee',
                      fontsize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 12.h),
                    CustomTextField(
                      controller: lateFee,
                      hintText: '\$',
                    ),
                    SizedBox(height: 12.h),
                    CustomText(
                      text: 'Type',
                      fontsize: 16,
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
                          value: _selectedRound,
                          hint: CustomText(text: 'Select Type', fontsize: 14.sp),
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
                    CustomText(
                      text: 'Description',
                      fontsize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 12.h),
                    CustomTextField(
                      controller: lateFee,
                      hintText: 'Type your Description',
                    ),

                    SizedBox(height: 10),
                    CustomButton(
                      color: AppColors.buttonColor,
                      borderColor: Colors.white,
                      onTap: () {},
                      text: "Add",
                      textColor: Colors.white,
                    ),
                    SizedBox(height: 10.h),
                    CustomText(
                      text: 'Added Round',
                      fontsize: 16,
                      fontWeight: FontWeight.w600,
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
                                  CustomText(
                                    text: '1. Bangla',
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
                                  CustomText(
                                    text: '2. English',
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
                                  CustomText(
                                    text: '3. Math',
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
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onTap: () {
                      Get.back();
                    },
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
