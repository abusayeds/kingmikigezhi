
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';


class SettingsScreen extends StatefulWidget {
   const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final List<String> _language = ['Bangla', 'English', 'English (US)'];
  final List<String> _currency = ['USD', 'EURO', 'TAKA'];
  final List<String> _notification = ['ON', 'OFF'];
  final List<String> _timeZone = ['Dhaka(+6)', 'Canada(-6)'];



  String? _selectedlanguage;
  String? _selectedCurrency;
  String? _selectedNotification;
  String? _selectedTimeZone;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading:  IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Colors.black, size: 18.w),
          onPressed: () {
            Get.back();
          },
        ),
        title: CustomText(
          text: 'Settings',
          fontWeight: FontWeight.w500,
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
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6.h),
                child: Text('Display language',style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              ),
              SizedBox(
                height: AppStyles.standardHeight,
                child: InputDecorator(
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
                      padding: EdgeInsets.symmetric(vertical: 5.h),
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
              ),
              //=================================> Date time format Section <=======================
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6.h),
                child: Text('Date time format',style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              ),
              SizedBox(
                height: AppStyles.standardHeight,
                child: InputDecorator(
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
                      padding: EdgeInsets.symmetric(vertical: 5.h),
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
              ),
              //=================================> Time zone Section <=======================
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6.h),
                child: Text('Time zone',style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              ),
              SizedBox(
                height: AppStyles.standardHeight,
                child: InputDecorator(
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
                      padding: EdgeInsets.symmetric(vertical: 5.h),
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
              ),
              //=================================> Currency Section <=======================
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6.h),
                child: Text('Currency',style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              ),
              SizedBox(
                height: AppStyles.standardHeight,
                child: InputDecorator(
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
                      padding: EdgeInsets.symmetric(vertical: 5.h),
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
              ),
              SizedBox(height: 14.h),
              Divider(thickness: .5,color: AppColors.color808080),
              //=================================> Notifications Section <=======================
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6.h),
                child: Text('Notifications',style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              ),
              SizedBox(
               height: AppStyles.standardHeight,
                child: InputDecorator(
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
                      padding: EdgeInsets.symmetric(vertical: 5.h),
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
              ),
              SizedBox(height: 14.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Share Section
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Text('Event Share',style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email',
                              style: AppStyles.fontSize14()
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              height: 52.h,
                              padding: EdgeInsets.symmetric(horizontal: 12.w, ),
                              decoration: BoxDecoration(
                                border: Border.all(color:AppColors.borderColor),
                                borderRadius: BorderRadius.circular(8.r),
                                color: AppColors.fillColor,
                              ),
                              child: DropdownButton<String>(
                                padding: EdgeInsets.symmetric(vertical: 5.h),
                                icon: SvgPicture.asset(
                                  AppIcons.downArrowIcon,
                                  color: AppColors.primaryColor,
                                ),
                                isExpanded: true,
                                underline: const SizedBox(),
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
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SMS',
                                style: AppStyles.fontSize14()
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              height: 52.h,
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.borderColor),
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.fillColor,
                              ),
                              child: DropdownButton<String>(
                                padding: EdgeInsets.symmetric(vertical: 5.h),
                                icon: SvgPicture.asset(
                                  AppIcons.downArrowIcon,
                                  color: AppColors.primaryColor,
                                ),
                                isExpanded: true,
                                underline: const SizedBox(),
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

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.w),
                    child: Text('Applied Event Update',style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                  ),
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
                                style: AppStyles.fontSize14()
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              height: 52.h,
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                border: Border.all(color:AppColors.borderColor),
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.fillColor,
                              ),
                              child: DropdownButton<String>(
                                padding: EdgeInsets.symmetric(vertical: 5.h),
                                icon: SvgPicture.asset(
                                  AppIcons.downArrowIcon,
                                  color: AppColors.primaryColor,
                                ),
                                isExpanded: true,
                                underline: const SizedBox(),
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
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SMS',
                                style: AppStyles.fontSize14()
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              height: 52.h,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.borderColor),
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.fillColor,
                              ),
                              child: DropdownButton<String>(
                                padding: EdgeInsets.symmetric(vertical: 5.h),

                                icon: SvgPicture.asset(
                                  AppIcons.downArrowIcon,
                                  color: AppColors.primaryColor,
                                ),
                                isExpanded: true,
                                underline: const SizedBox(),
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
