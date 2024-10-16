import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:event_sharing/views/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';


class HomePageAddBottomSheetWidget extends StatefulWidget {
  @override
  State<HomePageAddBottomSheetWidget> createState() => _HomePageAddBottomSheetWidgetState();
  /// HomePage AddBottomSheet
  static addBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return HomePageAddBottomSheetWidget();
      },
    );
  }
}

class _HomePageAddBottomSheetWidgetState extends State<HomePageAddBottomSheetWidget> {
  final TextEditingController _typeCTRL = TextEditingController();
  final TextEditingController _startsDateCTRL = TextEditingController();
  final TextEditingController _startsTimeCTRL = TextEditingController();
  final TextEditingController _endsDateCTRL = TextEditingController();
  final TextEditingController _endsTimeCTRL = TextEditingController();
  String? _selectedMember;
  String? _selectedRepeat;
  final List<String> _member = ['Family', 'Member', 'Owner'];
  final List<String> _repeat = ['Never', 'One', 'Two'];

  @override
  Widget build(BuildContext context) {
    double sheetHeight = MediaQuery
        .of(context)
        .size
        .height * 0.9;

    return SizedBox(
      height: sheetHeight,
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: AppColors.backgroundColor,
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type Section
              CustomText(text: 'Title',
                  fontWeight: FontWeight.w600,
                  fontsize: 16,
                  bottom: 8),
              CustomTextField(
                controller: _typeCTRL,
                hintText: 'Type Title',
              ),
              SizedBox(height: 8.h),
              // Location
              CustomText(text: 'Location',
                  fontWeight: FontWeight.w600,
                  fontsize: 16,
                  bottom: 8),
              CustomTextField(
                controller: _typeCTRL,
                hintText: 'Type Location',
              ),
              SizedBox(height: 8.h),
              // Member
              CustomText(text: 'Member', fontWeight: FontWeight.w600, fontsize: 16, bottom: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  color: AppColors.fillColor,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.primaryColor, width: 1),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedMember,
                    dropdownColor: AppColors.fillColor,
                    menuWidth: 240.w,
                    borderRadius: BorderRadius.circular(8.r),
                    hint: Text("Select Member", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),),
                    icon: SvgPicture.asset(AppIcons.downArrowIcon, width: 16.w, color: AppColors.primaryColor,
                    ),
                    isExpanded: true,
                    items: _member.map((String value) {
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
                        _selectedMember = newValue;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              // Status
              CustomText(
                  text: 'Status', fontsize: 16, fontWeight: FontWeight.w600),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomTextField(
                      prifixicon: IconButton(onPressed: () {},
                          icon: Icon(Icons.calendar_today_rounded)),
                      controller: _startsDateCTRL,
                      hintText: 'Date',
                      sufixicons: Padding(
                        padding: EdgeInsets.only(right: 12.w),
                      ),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: CustomTextField(
                      prifixicon: IconButton(onPressed: () {},
                          icon: Icon(Icons.watch_later_rounded)),
                      controller: _startsTimeCTRL,
                      hintText: 'Time',
                      sufixicons: Padding(
                        padding: EdgeInsets.only(right: 12.w),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              // ends
              CustomText(text: 'Ends', fontsize: 16, fontWeight: FontWeight.w600),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomTextField(
                      prifixicon: IconButton(onPressed: () {},
                          icon: Icon(Icons.calendar_today_rounded)),
                      controller: _endsDateCTRL,
                      hintText: 'Date',
                      sufixicons: Padding(
                        padding: EdgeInsets.only(right: 12.w),
                      ),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: CustomTextField(
                      prifixicon: IconButton(onPressed: () {},
                          icon: Icon(Icons.watch_later_rounded)),
                      controller: _endsTimeCTRL,
                      hintText: 'Time',
                      sufixicons: Padding(
                        padding: EdgeInsets.only(right: 12.w),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              // Repeat Function
              CustomText(text: 'Repeat Function', fontWeight: FontWeight.w600, fontsize: 16, bottom: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  color: AppColors.fillColor,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.primaryColor, width: 1),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedRepeat,
                    dropdownColor: AppColors.fillColor,
                    menuWidth: 240.w,
                    borderRadius: BorderRadius.circular(8.r),
                    hint: Text("Select Repeat", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),),
                    icon: SvgPicture.asset(AppIcons.downArrowIcon, width: 16.w, color: AppColors.primaryColor,
                    ),
                    isExpanded: true,
                    items: _repeat.map((String value) {
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
                        _selectedRepeat = newValue;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              //Url
              CustomText(text: 'URL',
                  fontWeight: FontWeight.w600,
                  fontsize: 16,
                  bottom: 8),
              CustomTextField(
                controller: _typeCTRL,
                hintText: 'Type URL',
              ),
              SizedBox(height: 8.h),
              // Note
              CustomText(text: 'Note',
                  fontWeight: FontWeight.w600,
                  fontsize: 16,
                  bottom: 8),
              CustomTextField(
                controller: _typeCTRL,
                maxLines: 2,
                hintText: 'Type Note',
              ),
              SizedBox(height: 20),
              // Row for buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomButton(
                      onTap: () {},
                      text: "Cancel",
                      color: AppColors.colorEDF2F4,
                      textColor: Colors.black,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: CustomButton(
                      onTap: () {},
                      text: "Add",
                      textColor: Colors.white,
                      color: AppColors.buttonColor,
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
