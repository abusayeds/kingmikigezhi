import 'dart:io';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_text_field.dart';
import 'package:event_sharing/views/screen/AddEvent/stepFiveForm.dart';
import 'package:event_sharing/views/screen/AddEvent/stepFourForm.dart';
import 'package:event_sharing/views/screen/AddEvent/stepThreeForm.dart';
import 'package:event_sharing/views/screen/AddEvent/stepTwoForm.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  final List<String> categories = ['Concert', 'Sports', 'Show', 'Olympic game'];
  String? selectedCategory;
  String? _selectedType;
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
        padding: EdgeInsets.symmetric(horizontal: 24.w,),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EasyStepper(
                activeStep: _activeStepIndex,
                stepShape: StepShape.rRectangle,
                stepBorderRadius: 15,
                borderThickness: 2,
                stepRadius: 28,
                finishedStepBorderColor: Colors.deepPurple,
                finishedStepTextColor: Colors.deepPurple,
                finishedStepBackgroundColor: Colors.brown,
                activeStepIconColor: Colors.deepOrange,
                showLoadingAnimation: false,
                steps: [
                  EasyStep(
                    customStep: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Opacity(
                        opacity: _activeStepIndex >= 0 ? 1 : 0.3,
                        child: Image.asset('assets/images/music.png'),
                      ),
                    ),
                    customTitle: const Text(
                      'Basic',style: TextStyle(fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  EasyStep(
                    customStep: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Opacity(
                        opacity: _activeStepIndex >= 1 ? 1 : 0.3,
                        child: Image.asset('assets/images/music.png'),
                      ),
                    ),
                    customTitle: const Text(
                      'Details',style: TextStyle(fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  EasyStep(
                    customStep: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Opacity(
                        opacity: _activeStepIndex >= 2 ? 1 : 0.3,
                        child: Image.asset('assets/images/music.png'),
                      ),
                    ),
                    customTitle: const Text(
                      'Group/Category',style: TextStyle(fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  EasyStep(
                    customStep: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Opacity(
                        opacity: _activeStepIndex >= 3 ? 1 : 0.3,
                        child: Image.asset('assets/images/music.png'),
                      ),
                    ),
                    customTitle: const Text(
                      'Configuration',style: TextStyle(fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  EasyStep(
                    customStep: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Opacity(
                        opacity: _activeStepIndex >= 4 ? 1 : 0.3,
                        child: Image.asset('assets/images/music.png'),
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
    return Column(
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
                CustomText(
                  text: 'Session Number',
                  fontWeight: FontWeight.w500,
                  fontsize: 16.sp,
                  bottom: 8.h,
                ),
                InputDecorator(
                  decoration: InputDecoration(
                    fillColor: AppColors.fillColor,
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
                      iconDisabledColor: AppColors.primaryColor,
                      iconEnabledColor: AppColors.primaryColor,
                      isExpanded: true,
                      value: _selectedType,
                      hint: CustomText(text: 'Select Type', fontsize: 14.sp),
                      items: categories.map((String value) {
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

                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        'Year',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(width: 120.w),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        'Session',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            labelText: 'Year',
                          ),
                          value: null,
                          items: ['2020', '2021', '2022', '2023']
                              .map((year) => DropdownMenuItem(
                            value: year,
                            child: Text(year),
                          ))
                              .toList(),
                          onChanged: (value) {
                            // Handle year selection
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 8), // Spacing between the dropdown fields
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 2),
                            labelText: 'Session',
                          ),
                          value: null,
                          items: ['Chess', 'Math', 'Piano']
                              .map((program) => DropdownMenuItem(
                            value: program,
                            child: Text(
                              program,
                              style: TextStyle(fontSize: 12),
                            ),
                          ))
                              .toList(),
                          onChanged: (value) {
                            // Handle program selection
                          },
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
        InputDecorator(
          decoration: InputDecoration(
            fillColor: AppColors.colorEDF2F4,
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
              iconDisabledColor: AppColors.primaryColor,
              iconEnabledColor: AppColors.primaryColor,
              isExpanded: true,
              value: _selectedType,
              hint: CustomText(text: 'Select Type', fontsize: 14.sp),
              items: categories.map((String value) {
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
        //organization Name
        SizedBox(height: 16.h),
        CustomText(text: 'Organizer',fontsize: 16,fontWeight: FontWeight.w600,),
        SizedBox(height: 12.h),
        CustomTextField(
          controller: organizerController,
          hintText: 'Type Organizer',
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
          sufixicons: Padding(
            padding: EdgeInsets.all(16.w),
          ),
        ),

        //description portal Name
        SizedBox(height: 16.h),
        CustomText(text: 'Description',fontsize: 16,fontWeight: FontWeight.w600,),
        SizedBox(height: 12.h),
        CustomTextField(
          controller: descriptionCRTL,
          hintText: 'Type your Description',
          sufixicons: Padding(
            padding: EdgeInsets.all(16.w),
          ),
        ),

        //note portal Name
        SizedBox(height: 16.h),
        CustomText(text: 'Description',fontsize: 16,fontWeight: FontWeight.w600,),
        SizedBox(height: 12.h),
        CustomTextField(
          controller: noteCRTL,
          hintText: 'Type your event note',
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
