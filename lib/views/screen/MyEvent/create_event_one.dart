import 'dart:io';

import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_text_field.dart';
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
  final TextEditingController eventNameCTRL = TextEditingController();
  final TextEditingController venueNameCTRL = TextEditingController();
  final TextEditingController venueAddressCTRL = TextEditingController();
  var parameter = Get.parameters;
  Uint8List? _image;
  File? selectedIMage;
  final List<String> _categories = [
    'Concert',
    'Sports',
    'Show',
    'Olympic game'
  ];
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //=======================> App Bar Section <============================
      appBar: AppBar(
          title: CustomText(
            text: AppStrings.createNewEvent,
            fontsize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
          centerTitle: true),
      //==========================> Body Section <============================
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //=======================> Cover Photo <===========================
              DottedBorderContainer(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: _image != null
                      ? Image.memory(
                          _image!,
                          fit: BoxFit.cover,
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    _pickImageFromGallery();
                                  },
                                  icon: Icon(
                                    Icons.add_circle_outlined,
                                    color: AppColors.primaryColor,
                                    size: 20.w,
                                  )),
                              CustomText(
                                text: AppStrings.addCoverPhoto,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              SizedBox(height: 23.h),
              //====================================> Image Row <==============================
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                DottedBorderContainer(
                  child: _image != null
                      ? Image.memory(
                          _image!,
                          fit: BoxFit.cover,
                          width: 75.w,
                          height: 77.h,
                        )
                      : SizedBox(
                          width: 75.w,
                          height: 77.h,
                          child: Center(
                            child: IconButton(
                                onPressed: () {
                                  _pickImageFromGallery();
                                },
                                icon: Icon(
                                  Icons.add_circle_outlined,
                                  color: AppColors.primaryColor,
                                  size: 16.w,
                                )),
                          ),
                        ),
                ),
                DottedBorderContainer(
                  child: _image != null
                      ? Image.memory(
                          _image!,
                          fit: BoxFit.cover,
                          width: 75.w,
                          height: 77.h,
                        )
                      : SizedBox(
                          width: 75.w,
                          height: 77.h,
                          child: Center(
                            child: IconButton(
                                onPressed: () {
                                  _pickImageFromGallery();
                                },
                                icon: Icon(
                                  Icons.add_circle_outlined,
                                  color: AppColors.primaryColor,
                                  size: 16.w,
                                )),
                          ),
                        ),
                ),
                DottedBorderContainer(
                  child: _image != null
                      ? Image.memory(
                          _image!,
                          fit: BoxFit.cover,
                          width: 75.w,
                          height: 77.h,
                        )
                      : SizedBox(
                          width: 75.w,
                          height: 77.h,
                          child: Center(
                            child: IconButton(
                                onPressed: () {
                                  _pickImageFromGallery();
                                },
                                icon: Icon(
                                  Icons.add_circle_outlined,
                                  color: AppColors.primaryColor,
                                  size: 16.w,
                                )),
                          ),
                        ),
                ),
                DottedBorderContainer(
                  child: _image != null
                      ? Image.memory(
                          _image!,
                          fit: BoxFit.cover,
                          width: 75.w,
                          height: 77.h,
                        )
                      : SizedBox(
                          width: 75.w,
                          height: 77.h,
                          child: Center(
                            child: IconButton(
                                onPressed: () {
                                  _pickImageFromGallery();
                                },
                                icon: Icon(
                                  Icons.add_circle_outlined,
                                  color: AppColors.primaryColor,
                                  size: 16.w,
                                )),
                          ),
                        ),
                ),
              ]),
              SizedBox(height: 32.h),
              //==============================> Event Details Text <=============================
              CustomText(
                text: AppStrings.eventDetails,
                fontWeight: FontWeight.bold,
                fontsize: 18.sp,
                bottom: 16.h,
              ),
              //==============================> Event Name Text Field <=============================
              CustomText(
                text: AppStrings.eventName,
                fontWeight: FontWeight.bold,
                fontsize: 16.sp,
                bottom: 8.h,
              ),
              CustomTextField(
                controller: eventNameCTRL,
                hintText: AppStrings.typeYourEventName,
              ),
              SizedBox(height: 16.h),
              //==============================> Event Type DropDown <=============================
              CustomText(
                text: AppStrings.eventType,
                fontWeight: FontWeight.bold,
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
                    iconDisabledColor: AppColors.primaryColor,
                    iconEnabledColor: AppColors.primaryColor,
                    isExpanded: true,
                    value: _selectedCategory,
                    hint: CustomText(
                      text: AppStrings.typeYourEventType,
                      fontsize: 14.sp,
                      color: AppColors.greyColor,
                    ),
                    items: _categories.map((String value) {
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
              //==============================> Venue Name Text Field <=============================
              CustomText(
                text: AppStrings.venueName,
                fontWeight: FontWeight.bold,
                fontsize: 16.sp,
                bottom: 8.h,
              ),
              CustomTextField(
                controller: venueNameCTRL,
                hintText: AppStrings.typeYourVenueName,
              ),
              SizedBox(height: 16.h),
              //==============================> Venue Address Text Field <=============================
              CustomText(
                text: AppStrings.venueAddress,
                fontWeight: FontWeight.bold,
                fontsize: 16.sp,
                bottom: 8.h,
              ),
              CustomTextField(
                controller: venueAddressCTRL,
                hintText: AppStrings.typeYourVenueAddress,
              ),
              SizedBox(height: 32.h),
              //==============================> Next Button <=============================
              CustomButton(
                onTap: () {
                  Get.toNamed(AppRoutes.createEventTwo);
                },
                text: AppStrings.next,
                textColor: Colors.white,
              ),
              SizedBox(height: 57.h),
            ],
          ),
        ),
      ),
    );
  }
  //==================================> ShowImagePickerOption Function <===============================

  void showImagePickerOption(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: AppColors.backgroundColor,
        context: context,
        builder: (builder) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4.2,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _pickImageFromGallery();
                      },
                      child: SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.image,
                              size: 50.w,
                              color: AppColors.primaryColor,
                            ),
                            CustomText(text: 'Gallery')
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _pickImageFromCamera();
                      },
                      child: SizedBox(
                        child: Column(
                          children: [
                            Icon(Icons.camera_alt,
                                size: 50.w, color: AppColors.primaryColor),
                            CustomText(text: 'Camera')
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  //==================================> Gallery <===============================
  Future _pickImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    setState(() {
      selectedIMage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });
    //Get.back();
  }

//==================================> Camera <===============================
  Future _pickImageFromCamera() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage == null) return;
    setState(() {
      selectedIMage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });
    Get.back();
  }
}
