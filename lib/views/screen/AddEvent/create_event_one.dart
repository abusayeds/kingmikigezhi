import 'dart:io';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_text_field.dart';
import 'package:event_sharing/views/screen/AddEvent/stepFiveForm.dart';
import 'package:event_sharing/views/screen/AddEvent/stepFourForm.dart';
import 'package:event_sharing/views/screen/AddEvent/stepThreeForm.dart';
import 'package:event_sharing/views/screen/AddEvent/stepTwoForm.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../utils/app_strings.dart';
import '../../base/custom_text.dart';
import 'InnerWidget/dotted_border_container.dart';

class CreateEventOne extends StatefulWidget {
  const CreateEventOne({super.key});

  @override
  State<CreateEventOne> createState() => _CreateEventOneState();
}

class _CreateEventOneState extends State<CreateEventOne> {


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

  String? _selectedProgram;
  String? _selectedNumber;
  String? _selectedSession;
  String? _selectedYear;

  int _activeStepIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: AppStrings.createNewEvent,
          fontsize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100.h,
                child: EasyStepper(
                  activeStep: _activeStepIndex,
                  stepShape: StepShape.rRectangle,
                  stepBorderRadius: 20,
                  borderThickness: 2,
                  stepRadius: 20,
                  finishedStepBorderColor: AppColors.primaryColor,
                  finishedStepTextColor:  AppColors.primaryColor,
                  finishedStepBackgroundColor: AppColors.primaryColor,
                  activeStepIconColor: AppColors.primaryColor,
                  showLoadingAnimation: false,
                  steps: [
                    EasyStep(
                      customStep: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Opacity(
                          opacity: _activeStepIndex >= 0 ? 1 : 0.3,
                          child: Container(
                            color: AppColors.primaryColor,
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            child: const Text(
                              '1',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      customTitle: Text(
                        'Basic', style: TextStyle(fontSize: 12.sp),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    EasyStep(
                      customStep: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Opacity(
                          opacity: _activeStepIndex >= 1 ? 1 : 0.3,
                          child: Container(
                            color: AppColors.primaryColor,
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            child: const Text(
                              '2',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      customTitle: Text(
                        'Details',style: TextStyle(fontSize: 12.sp),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    EasyStep(
                      customStep: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Opacity(
                          opacity: _activeStepIndex >= 2 ? 1 : 0.3,
                          child: Container(
                            color: AppColors.primaryColor,
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            child: const Text(
                              '3',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      customTitle: Text(
                        'Group/Category',style: TextStyle(fontSize: 12.sp),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    EasyStep(
                      customStep: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Opacity(
                          opacity: _activeStepIndex >= 3 ? 1 : 0.3,
                          child: Container(
                            color: AppColors.primaryColor,
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            child: const Text(
                              '4',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      customTitle:  Text(
                        'Configuration',style:TextStyle(fontSize: 12.sp),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    EasyStep(
                      customStep: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Opacity(
                          opacity: _activeStepIndex >= 4 ? 1 : 0.3,
                          child: Container(
                            color: AppColors.primaryColor,
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            child: const Text(
                              '5',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      customTitle: const Text(
                        'History',style: TextStyle(fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                  onStepReached: (index) => setState(() => _activeStepIndex = index),
                ),
              ),
              if (_activeStepIndex == 0)
                _buildStepOneContent()
              else if (_activeStepIndex == 1)
                StepTwoForm()
              else if (_activeStepIndex == 2)
                  StepThreeForm()
                else if (_activeStepIndex == 3)
                  StepFourForm()
                  else if (_activeStepIndex == 4)
                  StepFiveForm()
            ],
          ),
        ),
      ),
    );
  }

  // Step 1 Content
  Widget _buildStepOneContent() {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 12.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: "This is a shared community. All events are public",color: AppColors.colorD9A951),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: CustomText(text: "Step 1: Basic",fontsize: 20,fontWeight: FontWeight.w600,),
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
                  CustomText(text: 'Session Number', fontWeight: FontWeight.w700, fontsize: 16.sp, bottom: 8.h,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    decoration: BoxDecoration(
                      color: AppColors.fillColor,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: AppColors.primaryColor, width: 1),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedNumber,
                        dropdownColor: AppColors.fillColor,
                        menuWidth: 240.w,
                        borderRadius: BorderRadius.circular(8.r),
                        hint: Text("Select Number", style:AppStyles.fontSize14(color: AppColors.color414141)),
                        icon: SvgPicture.asset(AppIcons.downArrowIcon, width: 16.w, color: AppColors.primaryColor,
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
                          style: AppStyles.fontSize16(color: AppColors.blackColor,fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(width: 120.w),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          'Session',
                          style:AppStyles.fontSize16(color: AppColors.blackColor,fontWeight: FontWeight.w600),
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
                              value: _selectedYear,
                              dropdownColor: AppColors.fillColor,
                              menuWidth: 240.w,
                              borderRadius: BorderRadius.circular(8.r),
                              hint: Text("Year",style:AppStyles.fontSize14(color: AppColors.color414141)),
                              icon: SvgPicture.asset(AppIcons.downArrowIcon, width: 16.w, color: AppColors.primaryColor,
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
                              value: _selectedSession,
                              dropdownColor: AppColors.fillColor,
                              menuWidth: 240.w,
                              borderRadius: BorderRadius.circular(8.r),
                              hint: Text("Session", style:AppStyles.fontSize14(color: AppColors.color414141)),
                              icon: SvgPicture.asset(AppIcons.downArrowIcon, width: 16.w, color: AppColors.primaryColor,
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
          CustomText(text: 'Program',fontsize: 16,fontWeight: FontWeight.w600,),
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
                value: _selectedProgram,
                dropdownColor: AppColors.fillColor,
                menuWidth: 240.w,
                borderRadius: BorderRadius.circular(8.r),
                hint: Text("Select Program", style:AppStyles.fontSize14(color: AppColors.color414141)),
                icon: SvgPicture.asset(AppIcons.downArrowIcon, width: 16.w, color: AppColors.primaryColor,
                ),
                isExpanded: true,
                items:programList.map((String value) {
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
          //organization Name
          SizedBox(height: 16.h),
          CustomText(text: 'Organizer',fontsize: 16,fontWeight: FontWeight.w600,),
          SizedBox(height: 12.h),
          CustomTextField(
            controller: organizerController,
            hintText: 'Type Organizer',
            hintTextStyle: AppStyles.fontSize14(color: AppColors.color414141),
            sufixicons: Padding(
              padding: EdgeInsets.all(16.w),
            ),
          ),
          //organization Name
          SizedBox(height: 16.h),
          CustomText(text: 'Event Name',fontsize: 16,fontWeight: FontWeight.w600,),
          SizedBox(height: 12.h),
          CustomTextField(
            controller: eventName,
            hintText: 'Type Event Name',
            hintTextStyle: AppStyles.fontSize14(color: AppColors.color414141),
            sufixicons: Padding(
              padding: EdgeInsets.all(16.w),
            ),
          ),
          //event portal Name
          SizedBox(height: 16.h),
          CustomText(text: 'Event Portal',fontsize: 16,fontWeight: FontWeight.w600,),
          SizedBox(height: 12.h),
          CustomTextField(
            controller: eventPortal,
            hintText: 'Type Event Portal',
            hintTextStyle: AppStyles.fontSize14(color: AppColors.color414141),
            sufixicons: Padding(
              padding: EdgeInsets.all(16.w),
            ),
          ),
          //registartion portal Name
          SizedBox(height: 16.h),
          CustomText(text: 'Registartion Portal',fontsize: 16,fontWeight: FontWeight.w600,),
          SizedBox(height: 12.h),
          CustomTextField(
            controller: registrationPortal,
            hintText: 'Type Registartion Portal',
            hintTextStyle: AppStyles.fontSize14(color: AppColors.color414141),
            sufixicons: Padding(
              padding: EdgeInsets.all(16.w),
            ),
          ),

          //description portal Name
          SizedBox(height: 16.h),
          CustomText(text: 'Description',fontsize: 16,fontWeight: FontWeight.w600,),
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

          //note portal Name
          SizedBox(height: 16.h),
          CustomText(text: 'Note',fontsize: 16,fontWeight: FontWeight.w600,),
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
                    setState(() {
                      if (_activeStepIndex > 0) {
                        _activeStepIndex--;
                      }
                    });
                  },
                  text: "Back",
                  color: AppColors.fillColor,
                  textColor: Colors.black,
                ),
              ),
              SizedBox(
                width: 166.w,
                child: CustomButton(
                  onTap: () {
                    setState(() {
                      if (_activeStepIndex < 1) {
                        _activeStepIndex++;
                      }
                    });
                  },
                  text: "Next",
                  textColor: Colors.white,
                  color: AppColors.buttonColor,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  // Add Image Button
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
