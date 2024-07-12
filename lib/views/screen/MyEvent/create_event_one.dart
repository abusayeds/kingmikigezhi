/*
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
  Uint8List? _image1;
  Uint8List? _image2;
  Uint8List? _image3;
  Uint8List? _image4;
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
                  child: _image1 != null
                      ? Image.memory(
                    _image1!,
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
                            _pickImageFromGalleryOne();
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
                  child: _image2!= null
                      ? Image.memory(
                    _image2!,
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
                            _pickImageFromGalleryTwo();
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
                  child: _image3 != null
                      ? Image.memory(
                    _image3!,
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
                            _pickImageFromGalleryThree();
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
                  child: _image4 != null
                      ? Image.memory(
                    _image4!,
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
                            _pickImageFromGalleryFour();
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

  //==================================> Gallery <===============================
  Future _pickImageFromGallery() async {
    final returnImage =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    setState(() {
      selectedIMage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });
  }
  //==================================> Gallery <===============================
  Future _pickImageFromGalleryOne() async {
    final returnImage =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    setState(() {
      selectedIMage = File(returnImage.path);
      _image1 = File(returnImage.path).readAsBytesSync();
    });
  }
  //==================================> Gallery <===============================
  Future _pickImageFromGalleryTwo() async {
    final returnImage =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    setState(() {
      selectedIMage = File(returnImage.path);
      _image2 = File(returnImage.path).readAsBytesSync();
    });
  }
  //==================================> Gallery <===============================
  Future _pickImageFromGalleryThree() async {
    final returnImage =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    setState(() {
      selectedIMage = File(returnImage.path);
      _image3 = File(returnImage.path).readAsBytesSync();
    });
  }
  //==================================> Gallery <===============================
  Future _pickImageFromGalleryFour() async {
    final returnImage =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    setState(() {
      selectedIMage = File(returnImage.path);
      _image4 = File(returnImage.path).readAsBytesSync();
    });
  }
}*/

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
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController venueNameController = TextEditingController();
  final TextEditingController venueAddressController = TextEditingController();
  var parameter = Get.parameters;
  Uint8List? coverImage;
  List<Uint8List?> eventImages = [null, null, null, null];
  File? selectedImage;
  final List<String> categories = ['Concert', 'Sports', 'Show', 'Olympic game'];
  String? selectedCategory;

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
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DottedBorderContainer(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: coverImage != null
                      ? Image.memory(coverImage!, fit: BoxFit.cover)
                      : _addImageButton(() => _pickImage((image) => setState(() => coverImage = image))),
                ),
              ),
              SizedBox(height: 23.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (index) => _imageContainer(index)),
              ),
              SizedBox(height: 32.h),
              _sectionTitle(AppStrings.eventDetails),
              _sectionTitle(AppStrings.eventName),
              CustomTextField(
                controller: eventNameController,
                hintText: AppStrings.typeYourEventName,
              ),
              SizedBox(height: 16.h),
              _sectionTitle(AppStrings.eventType),
              _buildDropdown(),
              SizedBox(height: 16.h),
              _sectionTitle(AppStrings.venueName),
              CustomTextField(
                controller: venueNameController,
                hintText: AppStrings.typeYourVenueName,
              ),
              SizedBox(height: 16.h),
              _sectionTitle(AppStrings.venueAddress),
              CustomTextField(
                controller: venueAddressController,
                hintText: AppStrings.typeYourVenueAddress,
              ),
              SizedBox(height: 32.h),
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

 _sectionTitle(String text) {
    return CustomText(
      text: text,
      fontWeight: FontWeight.bold,
      fontsize: 18.sp,
      bottom: 16.h,
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

  Widget _imageContainer(int index) {
    return DottedBorderContainer(
      child: eventImages[index] != null
          ? Image.memory(
        eventImages[index]!,
        fit: BoxFit.cover,
        width: 75.w,
        height: 77.h,
      )
          : SizedBox(
        width: 75.w,
        height: 77.h,
        child: Center(
          child: IconButton(
            onPressed: () => _pickImage((image) => setState(() => eventImages[index] = image)),
            icon: Icon(
              Icons.add_circle_outlined,
              color: AppColors.primaryColor,
              size: 16.w,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return InputDecorator(
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
          value: selectedCategory,
          hint: CustomText(
            text: AppStrings.typeYourEventType,
            fontsize: 14.sp,
            color: AppColors.greyColor,
          ),
          items: categories.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedCategory = newValue;
            });
          },
        ),
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
