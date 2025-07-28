import 'package:event_sharing/utils/style.dart';
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
import 'controller/addEventController.dart';

class StepThreeForm extends StatefulWidget {
  const StepThreeForm({super.key});

  @override
  State<StepThreeForm> createState() => _StepThreeFormState();
}

class _StepThreeFormState extends State<StepThreeForm> {
  final List<String> costList = ['Has Final Deadline', 'Has Late Fee'];
  final List<String> typeList = ['First', 'Second'];

  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  final TextEditingController finalDatelineMonthController =
      TextEditingController();
  final TextEditingController finalDatelineDayController =
      TextEditingController();
  final TextEditingController finalDatelineYearController =
      TextEditingController();

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController deadLineDateController = TextEditingController();
  final TextEditingController deadLineTimeController = TextEditingController();
  final TextEditingController lateFee = TextEditingController();
  final Addeventcontroller addeventcontroller = Get.find<Addeventcontroller>();

  final TextEditingController payment = TextEditingController();
  String? _selectedCost;
  String? _selectedType;

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
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text('Step 3: Group/Category',
                    style: AppStyles.fontSize20(fontWeight: FontWeight.bold)),
              ),
              //registration date
              SizedBox(height: 12.h),
              //registration date
              Text('Define Group/Category',
                  style: AppStyles.fontSize16(fontWeight: FontWeight.bold)),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: dateController,
                      hintText: 'Group/Category',
                      hintTextStyle:
                          AppStyles.fontSize14(color: AppColors.color414141),
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
                      hintTextStyle:
                          AppStyles.fontSize14(color: AppColors.color414141),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomTextField(

                      // Fixed height - won't change with device height
                      controller: payment,
                      hintText: '\$',
                      hintTextStyle:
                          AppStyles.fontSize14(color: AppColors.color414141),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  // Width-based spacing (scales with width, not height)
                  SizedBox(
                    width: 90.w, // Width-based sizing
                    child: CustomButton(
                      height: 48.5,
                      // Fixed height - won't change with device height
                      width: 90.w,
                      color: AppColors.buttonA47059,
                      borderColor: Colors.transparent,
                      onTap: () {},
                      text: 'Add',
                      textColor: AppColors.textColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text('Added Group / Category',
                    style: AppStyles.fontSize16(fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 8.h),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.colorEDF2F4,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: AppColors.primaryColor, width: 1),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 8.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('1 Age up to 10 years old',
                                style: AppStyles.fontSize14(
                                    color: AppColors.color414141)),
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
                      SizedBox(
                        height: 2.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('2 Age up to 15 years old',
                                style: AppStyles.fontSize14(
                                    color: AppColors.color414141)),
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
                      SizedBox(
                        height: 2.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('3 Age up to 18 years old',
                                style: AppStyles.fontSize14(
                                    color: AppColors.color414141)),
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
                      Text('Defile Round',
                          style: AppStyles.fontSize16(
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 0.w),
                        decoration: BoxDecoration(
                          color: AppColors.fillColor,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                              color: AppColors.primaryColor, width: 1),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedType,
                            dropdownColor: AppColors.fillColor,
                            menuWidth: 240.w,
                            borderRadius: BorderRadius.circular(8.r),
                            hint: Text("Select Round",
                                style: AppStyles.fontSize14(
                                    color: AppColors.color414141)),
                            icon: SvgPicture.asset(
                              AppIcons.downArrowIcon,
                              width: 16.w,
                              color: AppColors.primaryColor,
                            ),
                            isExpanded: true,
                            items: typeList.map((String value) {
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
                      SizedBox(height: 12.h),
                      //deadline date
                      Text("Deadline",
                          style: AppStyles.fontSize16(
                              fontWeight: FontWeight.bold)),
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
                              hintTextStyle: AppStyles.fontSize14(
                                  color: AppColors.color414141),
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
                              hintTextStyle: AppStyles.fontSize14(
                                  color: AppColors.color414141),
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
                      Text("Cost",
                          style: AppStyles.fontSize16(
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 12.h),
                      CustomTextField(
                        controller: dateController,
                        hintText: '\$',
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        decoration: BoxDecoration(
                          color: AppColors.fillColor,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                              color: AppColors.primaryColor, width: 1),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            padding: EdgeInsets.symmetric(vertical: 0.w,),                    //focusColor:  AppColors.primaryColor,

                            value: _selectedCost,
                            dropdownColor: AppColors.fillColor,
                            menuWidth: 240.w,
                            borderRadius: BorderRadius.circular(8.r),
                            hint: Text(
                              "Select Cost",
                              style: AppStyles.fontSize14(
                                  color: AppColors.color414141),
                            ),
                            icon: SvgPicture.asset(
                              AppIcons.downArrowIcon,
                              width: 16.w,
                              color: AppColors.primaryColor,
                            ),
                            isExpanded: true,
                            items: costList.map((String value) {
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
                                _selectedCost = newValue;
                              });
                            },
                          ),
                        ),
                      ),
                      //final date
                      SizedBox(height: 12.h),
                      Text("Final Deadline",
                          style: AppStyles.fontSize16(
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 108.w,
                            child: CustomTextField(
                              controller: finalDatelineYearController,
                              hintText: 'Year',
                              hintTextStyle: AppStyles.fontSize14(
                                  color: AppColors.color414141),
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
                              hintTextStyle: AppStyles.fontSize14(
                                  color: AppColors.color414141),
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
                              hintTextStyle: AppStyles.fontSize14(
                                  color: AppColors.color414141),
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
                      Text("Late fee",
                          style: AppStyles.fontSize16(
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 12.h),
                      CustomTextField(
                        controller: lateFee,
                        hintText: '\$',
                        hintTextStyle:
                            AppStyles.fontSize14(color: AppColors.color414141),
                      ),
                      SizedBox(height: 12.h),
                      Text("Type",
                          style: AppStyles.fontSize16(
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 12.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        decoration: BoxDecoration(
                          color: AppColors.fillColor,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                              color: AppColors.primaryColor, width: 1),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            padding: EdgeInsets.symmetric(vertical: 0.w,),                    //focusColor:  AppColors.primaryColor,

                            value: _selectedType,
                            dropdownColor: AppColors.fillColor,
                            menuWidth: 240.w,
                            borderRadius: BorderRadius.circular(8.r),
                            hint: Text(
                              "Select Type",
                              style: AppStyles.fontSize14(
                                  color: AppColors.color414141),
                            ),
                            icon: SvgPicture.asset(
                              AppIcons.downArrowIcon,
                              width: 16.w,
                              color: AppColors.primaryColor,
                            ),
                            isExpanded: true,
                            items: typeList.map((String value) {
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
                      SizedBox(height: 12.h),
                      Text("Description",
                          style: AppStyles.fontSize16(
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 12.h),
                      CustomTextField(
                        controller: lateFee,
                        hintText: 'Type your Description...',
                        hintTextStyle:
                            AppStyles.fontSize14(color: AppColors.color414141),
                      ),

                      SizedBox(height: 10.h),
                      CustomButton(
                        color: AppColors.buttonA47059,
                        borderColor: Colors.white,
                        onTap: () {},
                        text: "Add",
                        textColor: Colors.white,
                      ),
                      SizedBox(height: 10.h),
                      Text("Added Round",
                          style: AppStyles.fontSize16(
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 8.h),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.colorEDF2F4,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                              color: AppColors.primaryColor, width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8..w,vertical: 0.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      text: '1. Bangla',
                                      color: AppColors.color414141,
                                      fontsize: 14.sp,
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              Get.back();
                                            },
                                            child: SvgPicture.asset(
                                                AppIcons.editIcon)),
                                        SizedBox(width: 4),
                                        InkWell(
                                            onTap: () {
                                              Get.back();
                                            },
                                            child: SvgPicture.asset(
                                                AppIcons.trashIcon))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      text: '2. English',
                                      color: AppColors.color414141,
                                      fontsize: 14.sp,
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              Get.back();
                                            },
                                            child: SvgPicture.asset(
                                                AppIcons.editIcon)),
                                        SizedBox(width: 4),
                                        InkWell(
                                            onTap: () {
                                              Get.back();
                                            },
                                            child: SvgPicture.asset(
                                                AppIcons.trashIcon))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      text: '3. Math',
                                      color: AppColors.color414141,
                                      fontsize: 14.sp,
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              //  Get.back();
                                            },
                                            child: SvgPicture.asset(
                                                AppIcons.editIcon)),
                                        SizedBox(width: 4.w),
                                        InkWell(
                                            onTap: () {
                                              //Get.back();
                                            },
                                            child: SvgPicture.asset(
                                                AppIcons.trashIcon))
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
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onTap: () {
                        setState(() {
                          if (addeventcontroller.activeStepIndex.value == 2) {
                            addeventcontroller.activeStepIndex.value--;
                            //StepThreeForm();
                          } // In create_event_one.dart, modify the step widgets to pass the activeStepIndex and update function:
                        });
                      },
                      text: "Back",
                      color: AppColors.fillColor,
                      textColor: Colors.black,
                      borderColor: AppColors.buttonColor,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: CustomButton(
                      onTap: () {
                        setState(() {
                          if (addeventcontroller.activeStepIndex.value == 2) {
                            addeventcontroller.activeStepIndex.value++;
                            //StepThreeForm();
                          } // In create_event_one.dart, modify the step widgets to pass the activeStepIndex and update function:
                        });
                      },
                      text: "Next",
                      textColor: Colors.white,
                      borderColor: AppColors.buttonColor,
                      color: AppColors.buttonColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25.h),
            ],
          ),
        )
      ]),
    );
  }
}
