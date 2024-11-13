
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/utils/app_strings.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';


class SettingsScreen extends StatefulWidget {
   SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final List<String> _language = ['Bangla', 'English', 'English (US)'];
  final List<String> _currency = ['USD', 'EURO', 'TAKA'];
  final List<String> _notification = ['ON', 'OFF'];
  final List<String> _timeZone = ['Dhaka(+6)', 'Canada(-6)'];
  final List<String> _updateOption = ['Option 1', 'Option 2'];


  String? _selectedlanguage;
  String? _selectedCurrency;
  String? _selectedNotification;
  String? _selectedTimeZone;
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      appBar: AppBar(
        leading:  IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Colors.black, size: 18.w),
          onPressed: () {
            Get.back();
          },
        ),
        title: CustomText(
          text: 'Settings',
          fontWeight: FontWeight.bold,
          fontsize: 18.sp,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //=================================> Language Section <=======================
              CustomText(
                text: 'Display language',
                fontWeight: FontWeight.w500,
                fontsize: 16.sp,
                bottom: 8.h,
              ),
              InputDecorator(
                decoration: InputDecoration(
                  fillColor: AppColors.fillColor,
                  filled: true,
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
                    icon: SvgPicture.asset(AppIcons.downArrowIcon,color: AppColors.primaryColor),
                    isExpanded: true,
                    value: _selectedlanguage,
                    hint: CustomText(text: 'Select language',fontsize: 14.sp,color: AppColors.color666666),
                    items: _language.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedlanguage = newValue;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              //=================================> Date time format Section <=======================
              CustomText(
                text: 'Date time format',
                fontWeight: FontWeight.w500,
                fontsize: 16.sp,
                bottom: 8.h,
              ),
              InputDecorator(
                decoration: InputDecoration(
                  fillColor: AppColors.fillColor,
                  filled: true,
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
                    icon: SvgPicture.asset(AppIcons.downArrowIcon,color: AppColors.primaryColor),
                    isExpanded: true,
                    value: _selectedlanguage,
                    hint: CustomText(text: 'Select Date Time', fontsize: 14.sp,color: AppColors.color666666),
                    items: _language.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedlanguage = newValue;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              //=================================> Time zone Section <=======================
              CustomText(
                text: 'Time zone',
                fontWeight: FontWeight.w500,
                fontsize: 16.sp,
                bottom: 8.h,
              ),
              InputDecorator(
                decoration: InputDecoration(
                  fillColor: AppColors.fillColor,
                  filled: true,
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
                    icon: SvgPicture.asset(AppIcons.downArrowIcon,color: AppColors.primaryColor),
                    isExpanded: true,
                    value: _selectedTimeZone,
                    hint: CustomText(text: 'Select Time Zone', fontsize: 14.sp,color: AppColors.color666666),
                    items: _timeZone.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedTimeZone = newValue;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              //=================================> Currency Section <=======================
              CustomText(
                text: 'Currency',
                fontWeight: FontWeight.w500,
                fontsize: 16.sp,
                bottom: 8.h,
              ),
              InputDecorator(
                decoration: InputDecoration(
                  fillColor: AppColors.fillColor,
                  filled: true,
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
                    icon: SvgPicture.asset(AppIcons.downArrowIcon,color: AppColors.primaryColor),
                    isExpanded: true,
                    value: _selectedCurrency,
                    hint: CustomText(text: 'Select Currency', fontsize: 14.sp, color: AppColors.color666666 ,
                    ),
                    items: _currency.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCurrency = newValue;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Divider(thickness: .5,color: AppColors.color808080),
              //=================================> Notifications Section <=======================
              CustomText(
                text: 'Notifications',
                fontWeight: FontWeight.w500,
                fontsize: 16.sp,
                bottom: 8.h,
              ),
              InputDecorator(
                decoration: InputDecoration(
                  fillColor: AppColors.fillColor,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryColor, width: 1.w),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryColor, width: 1.w),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryColor, width: 1.w),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    icon: SvgPicture.asset(AppIcons.downArrowIcon,color: AppColors.primaryColor),
                    isExpanded: true,
                    value: _selectedNotification,
                    hint: CustomText(
                      text: 'Select Notifications',
                      color: AppColors.color666666 ,
                      fontsize: 14.sp,
                    ),
                    items: _notification.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedNotification = newValue;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Share Section
                  Text('Event Share', style: AppStyles.h3()),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.blackColor,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              height: 52.h,
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color:AppColors.borderColor),
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.fillColor,
                              ),
                              child: DropdownButton<String>(
                                icon: SvgPicture.asset(
                                  AppIcons.downArrowIcon,
                                  color: AppColors.primaryColor,
                                ),
                                isExpanded: true,
                                underline: SizedBox(),
                                hint: Text('', style: TextStyle(color: AppColors.color414141, fontSize: 14.sp),),
                                items: <String>['Option 1', 'Option 2', 'Option 3']
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {},
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SMS',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.blackColor,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              height: 52.h,
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.borderColor),
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.fillColor,
                              ),
                              child: DropdownButton<String>(
                                icon: SvgPicture.asset(
                                  AppIcons.downArrowIcon,
                                  color: AppColors.primaryColor,
                                ),
                                isExpanded: true,
                                underline: SizedBox(),
                                hint: Text('', style: TextStyle(color: AppColors.color414141, fontSize: 14.sp),),
                                items: <String>['Option 1', 'Option 2', 'Option 3']
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  // Applied Event Update Section
                  Text('Applied Event Update',  style: AppStyles.h3()),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.blackColor,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              height: 52.h,
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color:AppColors.borderColor),
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.fillColor,
                              ),
                              child: DropdownButton<String>(
                                icon: SvgPicture.asset(
                                  AppIcons.downArrowIcon,
                                  color: AppColors.primaryColor,
                                ),
                                isExpanded: true,
                                underline: SizedBox(),
                                hint: Text('', style: TextStyle(color: AppColors.color414141, fontSize: 14.sp),),
                                items: <String>['Option 1', 'Option 2', 'Option 3']
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {},
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SMS',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.blackColor,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              height: 52.h,
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.borderColor),
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.fillColor,
                              ),
                              child: DropdownButton<String>(
                                icon: SvgPicture.asset(
                                  AppIcons.downArrowIcon,
                                  color: AppColors.primaryColor,
                                ),
                                isExpanded: true,
                                underline: SizedBox(),
                                hint: Text('', style: TextStyle(color: AppColors.color414141, fontSize: 14.sp),),
                                items: <String>['Option 1', 'Option 2', 'Option 3']
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                ],
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
