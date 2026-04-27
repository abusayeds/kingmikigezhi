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
  final TextEditingController sessionNumberController = TextEditingController();

  var parameter = Get.parameters;
  Uint8List? coverImage;
  List<Uint8List?> eventImages = [null, null, null, null];
  File? selectedImage;

  final List<String> programList = ['Program One', 'Program Two', 'Program Three'];

  // Generate year list: current year -4 to +4
  List<String> get yearList {
    final currentYear = DateTime.now().year;
    return List.generate(9, (i) => (currentYear - 4 + i).toString());
  }

  // Session frequency options
  final List<String> sessionFrequencyList = ['Daily', 'Weekly', 'Monthly', 'Quarterly', 'Yearly'];

  // Sub-options per frequency
  final Map<String, List<String>> sessionSubOptions = {
    'Daily': ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
    'Weekly': ['Week One', 'Week Two', 'Week Three', 'Week Four'],
    'Monthly': [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ],
    'Quarterly': ['Quarter One', 'Quarter Two', 'Quarter Three', 'Quarter Four'],
    'Yearly': [],
  };

  // Is Repeated toggle & dropdown
  bool _isRepeated = false;
  String? _selectedRepeatOption;

  // Repeat options shown in toggle dropdown
  final List<String> repeatOptions = [
    'Don\'t Repeat',
    'Daily',
    'Weekly',
    'Monthly',
    'Quarterly',
    'Yearly',
  ];

  // Session section fields
  String? _selectedYear;
  String? _selectedSessionFrequency;
  String? _selectedSessionSubOption;

  final Addeventcontroller addEventController = Get.find<Addeventcontroller>();
  String? _selectedProgram;

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
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
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
          SizedBox(height: 16.h),

          // ── Is Repeated Toggle ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Is Repeated ?',
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
                  ),
                  if (_isRepeated && _selectedRepeatOption != null) ...[
                    SizedBox(width: 8.w),
                    Text(
                      '($_selectedRepeatOption)',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF4C7E95),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ]
                ],
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isRepeated = !_isRepeated;
                    if (!_isRepeated) {
                      _selectedRepeatOption = null;
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 46.w,
                  height: 26.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13.r),
                    color: _isRepeated
                        ? const Color(0xFF4C7E95)
                        : Colors.grey.shade400,
                  ),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 200),
                    alignment: _isRepeated
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      child: Container(
                        width: 20.w,
                        height: 20.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ── Repeat Dropdown (shown when toggle is ON) ──
          if (_isRepeated) ...[
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
                  value: _selectedRepeatOption,
                  dropdownColor: AppColors.fillColor,
                  menuWidth: 240.w,
                  borderRadius: BorderRadius.circular(8.r),
                  hint: Text("Select Repeat Option",
                      style: AppStyles.fontSize14(color: AppColors.color414141)),
                  icon: SvgPicture.asset(
                    AppIcons.downArrowIcon,
                    width: 16.w,
                    color: AppColors.primaryColor,
                  ),
                  isExpanded: true,
                  items: repeatOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: const TextStyle(color: Colors.black)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedRepeatOption = newValue;
                    });
                  },
                ),
              ),
            ),
          ],

          SizedBox(height: 23.h),

          // ── Session Section (shown when toggle is OFF) ──
          if (!_isRepeated)
            DottedBorderContainer(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Session Number - TextField
                    Text('Session Number',
                        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                    SizedBox(height: 8.h),
                    SizedBox(
                      height: 50.h,
                      child: CustomTextField(
                        controller: sessionNumberController,
                        hintText: 'Enter Session Number',
                        hintTextStyle: AppStyles.fieldContent(color: AppColors.color414141),
                        sufixicons: Padding(padding: EdgeInsets.all(16.w)),
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Year & Session row labels
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text('Year',
                              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                        ),
                        SizedBox(width: 120.w),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text('Session',
                              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),

                    // Year & Session Frequency row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Year Dropdown
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
                                    child: Text(value,
                                        style: const TextStyle(color: Colors.black)),
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

                        // Session Frequency Dropdown
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
                                value: _selectedSessionFrequency,
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
                                items: sessionFrequencyList.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value,
                                        style: const TextStyle(color: Colors.black)),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedSessionFrequency = newValue;
                                    _selectedSessionSubOption = null; // reset sub
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Sub-option Dropdown (shown when frequency is selected and has sub-options)
                    if (_selectedSessionFrequency != null &&
                        (sessionSubOptions[_selectedSessionFrequency!]?.isNotEmpty ?? false)) ...[
                      SizedBox(height: 12.h),
                      Text(_selectedSessionFrequency!,
                          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                      SizedBox(height: 8.h),
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
                            value: _selectedSessionSubOption,
                            dropdownColor: AppColors.fillColor,
                            menuWidth: 240.w,
                            borderRadius: BorderRadius.circular(8.r),
                            hint: Text("Select ${_selectedSessionFrequency!}",
                                style: AppStyles.fontSize14(color: AppColors.color414141)),
                            icon: SvgPicture.asset(
                              AppIcons.downArrowIcon,
                              width: 16.w,
                              color: AppColors.primaryColor,
                            ),
                            isExpanded: true,
                            items: sessionSubOptions[_selectedSessionFrequency!]!
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,
                                    style: const TextStyle(color: Colors.black)),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedSessionSubOption = newValue;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

          SizedBox(height: 16.h),

          // ── Program ──
          Text('Program', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
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
                    child: Text(value, style: const TextStyle(color: Colors.black)),
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

          // ── Organizer ──
          SizedBox(height: 16.h),
          Text('Organizer', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 12.h),
          SizedBox(
            height: 50.h,
            child: CustomTextField(
              controller: organizerController,
              hintText: 'Type Organizer',
              hintTextStyle: AppStyles.fieldContent(color: AppColors.color414141),
              sufixicons: Padding(padding: EdgeInsets.all(16.w)),
            ),
          ),

          // ── Event Name ──
          SizedBox(height: 16.h),
          Text('Event Name', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 12.h),
          SizedBox(
            height: 50.h,
            child: CustomTextField(
              controller: eventName,
              hintText: 'Type Event Name',
              hintTextStyle: AppStyles.fieldContent(color: AppColors.color414141),
              sufixicons: Padding(padding: EdgeInsets.all(16.w)),
            ),
          ),

          // ── Event Portal ──
          SizedBox(height: 16.h),
          Text('Event Portal', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 12.h),
          SizedBox(
            height: 50.h,
            child: CustomTextField(
              controller: eventPortal,
              hintText: 'Type Event Portal',
              hintTextStyle: AppStyles.fieldContent(color: AppColors.color414141),
              sufixicons: Padding(padding: EdgeInsets.all(16.w)),
            ),
          ),

          // ── Registration Portal ──
          SizedBox(height: 16.h),
          Text('Registration Portal',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 12.h),
          SizedBox(
            height: 50.h,
            child: CustomTextField(
              controller: registrationPortal,
              hintText: 'Type Registration Portal',
              hintTextStyle: AppStyles.fieldContent(color: AppColors.color414141),
              sufixicons: Padding(padding: EdgeInsets.all(16.w)),
            ),
          ),

          // ── Description ──
          SizedBox(height: 16.h),
          Text('Description', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 12.h),
          CustomTextField(
            maxLines: 3,
            controller: descriptionCRTL,
            hintText: 'Type your Description...',
            hintTextStyle: AppStyles.fontSize14(color: AppColors.color414141),
            sufixicons: Padding(padding: EdgeInsets.all(16.w)),
          ),

          // ── Note ──
          SizedBox(height: 16.h),
          Text('Note', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 12.h),
          CustomTextField(
            maxLines: 3,
            controller: noteCRTL,
            hintText: 'Type your event note',
            hintTextStyle: AppStyles.fontSize14(color: AppColors.color414141),
            sufixicons: Padding(padding: EdgeInsets.all(16.w)),
          ),

          SizedBox(height: 16.h),

          // ── Back / Next Buttons ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 166.w,
                child: CustomButton(
                  onTap: () {
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

  Widget _addImageButton(VoidCallback onPressed) {
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

  Future _pickImage(Function(Uint8List) setImage) async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setImage(File(pickedImage.path).readAsBytesSync());
    }
  }
}