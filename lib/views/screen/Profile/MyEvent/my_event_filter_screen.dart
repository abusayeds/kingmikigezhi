import 'package:event_sharing/controllers/home_controller.dart';
import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/utils/app_strings.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:event_sharing/views/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class MyEventFilterScreen extends StatefulWidget {
  const MyEventFilterScreen({super.key});

  @override
  State<MyEventFilterScreen> createState() => _MyEventFilterScreenState();
}

class _MyEventFilterScreenState extends State<MyEventFilterScreen> {
  final TextEditingController _categoriesCTRL = TextEditingController();
  final TextEditingController _locationCTRL = TextEditingController();
  final List<String> _program = ['Musical Instrument', 'Keyboard', 'Piano', 'Chess', 'Ballet'];
  final List<String> _type = ['Onsite', 'Online', 'Hybrid'];
  final List<String> _category = ['6 Year - 10 Year', '11 Year - 16 Year', '17 Year+'];
  RangeValues _currentRangeValues = RangeValues(20, 80);
  String? _selectedProgram;
  String? _selectedType;
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //=======================> App Bar Section <============================
      appBar: AppBar(
          title: CustomText(
            text: AppStrings.filter,
            fontsize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
          centerTitle: true),
      //=======================> Body Section <============================
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //==============================> Program Section <=======================
              CustomText(
                text: 'Program',
                fontWeight: FontWeight.w500,
                fontsize: 16.sp,
                bottom: 8.h,
              ),
              InputDecorator(
                decoration: InputDecoration(
                  fillColor: AppColors.fillColor,
                  // labelText: 'Select',
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
                    //focusColor:  AppColors.primaryColor,
                    iconDisabledColor: AppColors.primaryColor,
                    iconEnabledColor: AppColors.primaryColor,
                    isExpanded: true,
                    value: _selectedProgram,
                    hint: CustomText(text: 'Select Program', fontsize: 14.sp),
                    items: _program.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedProgram = newValue;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              //==============================> Type Section <=======================
              CustomText(
                text: 'Type',
                fontWeight: FontWeight.w500,
                fontsize: 16.sp,
                bottom: 8.h,
              ),
              InputDecorator(
                decoration: InputDecoration(
                  fillColor: AppColors.fillColor,
                  // labelText: 'Select',
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
                    //focusColor:  AppColors.primaryColor,
                    iconDisabledColor: AppColors.primaryColor,
                    iconEnabledColor: AppColors.primaryColor,
                    isExpanded: true,
                    value: _selectedType,
                    hint: CustomText(text: 'Select Type', fontsize: 14.sp),
                    items: _type.map((String value) {
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
              SizedBox(height: 16.h),
              //==============================> Location Section <=======================
              CustomText(
                text: AppStrings.location,
                fontWeight: FontWeight.w500,
                fontsize: 16.sp,
                bottom: 8.h,
              ),
              CustomTextField(
                controller: _locationCTRL,
                hintText: 'Type here',
                sufixicons: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: SvgPicture.asset(AppIcons.locationIcon,
                      color: AppColors.primaryColor),
                ),
              ),
              SizedBox(height: 16.h),
              //==============================> Category/Group Section <=======================
              CustomText(
                text: 'Category/Group',
                fontWeight: FontWeight.w500,
                fontsize: 16.sp,
                bottom: 8.h,
              ),
              InputDecorator(
                decoration: InputDecoration(
                  fillColor: AppColors.fillColor,
                  // labelText: 'Select',
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
                    //focusColor:  AppColors.primaryColor,
                    iconDisabledColor: AppColors.primaryColor,
                    iconEnabledColor: AppColors.primaryColor,
                    isExpanded: true,
                    value: _selectedCategory,
                    hint: CustomText(text: 'Select Category/Group', fontsize: 14.sp),
                    items: _category.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'Price Range',
                    fontWeight: FontWeight.w500,
                    fontsize: 16.sp,
                    bottom: 16.h,
                  ),
                  CustomText(
                    text: '\$20-\$4K',
                    fontWeight: FontWeight.w500,
                    fontsize: 16.sp,
                    bottom: 16.h,
                  ),
                ],
              ),
              //================================> Range Slider Section <================================
              RangeSlider(
                values: _currentRangeValues,
                min: 20,
                max: 4000,
                divisions: 80,
                labels: RangeLabels(
                  '\$${_currentRangeValues.start.round()}',
                  '\$${_currentRangeValues.end.round()}',
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    _currentRangeValues = values;
                  });
                },
                activeColor: AppColors.primaryColor,
                inactiveColor: Colors.blue.withOpacity(0.2),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(text: '\$${_currentRangeValues.start.round()}'),
                    CustomText(text: '\$${_currentRangeValues.end.round()}'),
                  ],
                ),
              ),
              SizedBox(height: 131.h),
              // const Spacer(),
              //===========================> Button Section <===============================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: 166.w,
                      child: CustomButton(
                        onTap: () {},
                        text: "Reset",
                        color: AppColors.fillColor,
                        textColor: Colors.black,
                      )),
                  SizedBox(
                      width: 166.w,
                      child: CustomButton(
                        onTap: () {
                          Get.toNamed(AppRoutes.appliedSearchScreen);
                        },
                        text: "Apply",
                        textColor: Colors.white,
                        color: AppColors.buttonColor,
                      )),
                ],
              ),
              SizedBox(height: 75.h),
            ],
          ),
        ),
      ),
    );
  }
}
