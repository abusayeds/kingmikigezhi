import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/style.dart';
import '../../base/custom_button.dart';
import '../../base/custom_text.dart';
import '../../base/custom_text_field.dart';
import 'InnerWidget/dotted_border_container.dart';
import 'controller/addEventController.dart';

class Steponeform extends StatefulWidget {
  const Steponeform({super.key});

  @override
  State<Steponeform> createState() => _SteponeformState();
}

class _SteponeformState extends State<Steponeform> {
  final TextEditingController organizerController = TextEditingController();
  final TextEditingController eventName = TextEditingController();
  final TextEditingController eventPortal = TextEditingController();
  final TextEditingController registrationPortal = TextEditingController();
  final TextEditingController descriptionCRTL = TextEditingController();
  final TextEditingController noteCRTL = TextEditingController();

  var parameter = Get.parameters;
  Uint8List? coverImage;
  List<Uint8List?> eventImages = [null, null, null, null];
  File? selectedImage;

  final List<String> numberList = ['Concert', 'Sports', 'Show', 'Olympic game'];
  final List<String> programList = ['Program One', 'Program Two', 'Program Three'];
  final List<String> yearList = ['2020', '2021', '2024'];
  final List<String> sessionList = ['One', 'Two', 'Three'];

  // Get the existing controller instance instead of creating a new one
  final Addeventcontroller addEventController = Get.find<Addeventcontroller>();

  String? _selectedProgram;
  String? _selectedNumber;
  String? _selectedSession;
  String? _selectedYear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("This is a shared community. All events are public",
              style: AppStyles.fontSize12(color: AppColors.colorD9A951)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text('Step 1: Basic',
                style: AppStyles.fontSize20(fontWeight: FontWeight.bold)),
          ),
          // Cover Image Section
          DottedBorderContainer(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: coverImage != null
                  ? Image.memory(coverImage!, fit: BoxFit.cover)
                  : _addImageButton(() => _pickImage(
                      (image) => setState(() => coverImage = image))),
            ),
          ),
          SizedBox(height: 23.h),
          DottedBorderContainer(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Session Number',
                      style: AppStyles.fieldTitle()),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    decoration: BoxDecoration(
                      color: AppColors.fillColor,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: AppColors.primaryColor, width: 1),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        padding: EdgeInsets.symmetric(vertical: 0.w),
                        value: _selectedNumber,
                        dropdownColor: AppColors.fillColor,
                        menuWidth: 240.w,
                        borderRadius: BorderRadius.circular(8.r),
                        hint: Text("Select Number",
                            style: AppStyles.fontSize14(color: AppColors.color414141)),
                        icon: SvgPicture.asset(
                          AppIcons.downArrowIcon,
                          width: 16.w,
                          color: AppColors.primaryColor,
                        ),
                        isExpanded: true,
                        items: numberList.map((String value) {
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
                            _selectedNumber = newValue;
                          });
                        },
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          'Year',
                          style: AppStyles.fieldTitle(
                              color: AppColors.blackColor),
                        ),
                      ),
                      SizedBox(width: 120.w),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          'Session',
                          style: AppStyles.fieldTitle(
                              color: AppColors.blackColor),
                        ),
                      ),
                    ],
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
                              padding: EdgeInsets.symmetric(vertical: 0.w),
                              value: _selectedYear,
                              dropdownColor: AppColors.fillColor,
                              menuWidth: 240.w,
                              borderRadius: BorderRadius.circular(8.r),
                              hint: Text("Year",
                                  style: AppStyles.fontSize14(color: AppColors.color414141)),
                              icon: SvgPicture.asset(
                                AppIcons.downArrowIcon,
                                width: 16.w,
                                color: AppColors.primaryColor,
                              ),
                              isExpanded: true,
                              items: yearList.map((String value) {
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
                                  _selectedYear = newValue;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
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
                              padding: EdgeInsets.symmetric(vertical: 0.w),
                              value: _selectedSession,
                              dropdownColor: AppColors.fillColor,
                              menuWidth: 240.w,
                              borderRadius: BorderRadius.circular(8.r),
                              hint: Text("Session",
                                  style: AppStyles.fontSize14(color: AppColors.color414141)),
                              icon: SvgPicture.asset(
                                AppIcons.downArrowIcon,
                                width: 16.w,
                                color: AppColors.primaryColor,
                              ),
                              isExpanded: true,
                              items: sessionList.map((String value) {
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
                                  _selectedSession = newValue;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),

          Text('Program', style: AppStyles.fieldTitle()),
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
                padding: EdgeInsets.symmetric(vertical: 0.w),
                value: _selectedProgram,
                dropdownColor: AppColors.fillColor,
                menuWidth: 240.w,
                borderRadius: BorderRadius.circular(8.r),
                hint: Text("Select Program",
                    style: AppStyles.fontSize14(color: AppColors.color414141)),
                icon: SvgPicture.asset(
                  AppIcons.downArrowIcon,
                  width: 16.w,
                  color: AppColors.primaryColor,
                ),
                isExpanded: true,
                items: programList.map((String value) {
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
                    _selectedProgram = newValue;
                  });
                },
              ),
            ),
          ),

          // Organization Name
          SizedBox(height: 16.h),
          Text('Organizer', style: AppStyles.fieldTitle()),
          SizedBox(height: 12.h),
          SizedBox(
            height: 50.h,
            child: CustomTextField(
              controller: organizerController,
              hintText: 'Type Organizer',
              hintTextStyle: AppStyles.fieldContent(color: AppColors.color414141),
              sufixicons: Padding(
                padding: EdgeInsets.all(16.w),
              ),
            ),
          ),

          // Event Name
          SizedBox(height: 16.h),
          Text('Event Name', style: AppStyles.fieldTitle()),
          SizedBox(height: 12.h),
          SizedBox(
            height: 50.h,
            child: CustomTextField(
              controller: eventName,
              hintText: 'Type Event Name',
              hintTextStyle: AppStyles.fieldContent(color: AppColors.color414141),
              sufixicons: Padding(
                padding: EdgeInsets.all(16.w),
              ),
            ),
          ),

          // Event Portal Name
          SizedBox(height: 16.h),
          Text('Event Portal', style: AppStyles.fieldTitle()),
          SizedBox(height: 12.h),
          SizedBox(
            height: 50.h,
            child: CustomTextField(
              controller: eventPortal,
              hintText: 'Type Event Portal',
              hintTextStyle: AppStyles.fieldContent(color: AppColors.color414141),
              sufixicons: Padding(
                padding: EdgeInsets.all(16.w),
              ),
            ),
          ),

          // Registration Portal Name
          SizedBox(height: 16.h),
          Text('Registration Portal', style: AppStyles.fieldTitle()),
          SizedBox(height: 12.h),
          SizedBox(
            height: 50.h,
            child: CustomTextField(
              controller: registrationPortal,
              hintText: 'Type Registration Portal',
              hintTextStyle: AppStyles.fieldContent(color: AppColors.color414141),
              sufixicons: Padding(
                padding: EdgeInsets.all(16.w),
              ),
            ),
          ),

          // Description
          SizedBox(height: 16.h),
          Text('Description', style: AppStyles.fieldTitle()),
          SizedBox(height: 12.h),
          CustomTextField(
            maxLines: 3,
            controller: descriptionCRTL,
            hintText: 'Type your Description...',
            hintTextStyle: AppStyles.fontSize14(color: AppColors.color414141),
            sufixicons: Padding(
              padding: EdgeInsets.all(16.w),
            ),
          ),

          // Note
          SizedBox(height: 16.h),
          Text('Note', style: AppStyles.fieldTitle()),
          SizedBox(height: 12.h),
          CustomTextField(
            maxLines: 3,
            controller: noteCRTL,
            hintText: 'Type your event note',
            hintTextStyle: AppStyles.fontSize14(color: AppColors.color414141),
            sufixicons: Padding(
              padding: EdgeInsets.all(16.w),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 166.w,
                child: CustomButton(
                  onTap: () {
                    // Only go back if not on the first step
                    if (addEventController.activeStepIndex.value > 0) {
                      addEventController.activeStepIndex.value--;
                    }
                  },
                  text: "Back",
                  borderColor: AppColors.buttonColor,
                  color: AppColors.fillColor,
                  textColor: Colors.black,
                ),
              ),
              SizedBox(
                width: 166.w,
                child: CustomButton(
                  onTap: () {
                    // Move to next step using the controller
                    if (addEventController.activeStepIndex.value < 4) {
                      addEventController.activeStepIndex.value++;
                    }
                  },
                  text: "Next",
                  borderColor: AppColors.buttonColor,
                  textColor: Colors.white,
                  color: AppColors.buttonColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 25.h),
        ],
      ),
    );
  }

  _addImageButton(VoidCallback onPressed) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: onPressed,
            icon: Icon(
              Icons.add_circle_outlined,
              color: AppColors.primaryColor,
              size: 20.w,
            ),
          ),
          CustomText(
            text: AppStrings.addCoverPhoto,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  // Pick Image
  Future _pickImage(Function(Uint8List) setImage) async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setImage(File(pickedImage.path).readAsBytesSync());
    }
  }
}