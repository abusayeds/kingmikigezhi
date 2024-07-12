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
              //=================================> Cover Image Section <=======================
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
              //================================> Row Image Section <=========================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (index) => _imageContainer(index)),
              ),
              //=================================> Event Details Text <=======================
              SizedBox(height: 32.h),
              _sectionTitle(AppStrings.eventDetails),
              //======================================> Event Name <===========================
              _sectionTitle(AppStrings.eventName),
              CustomTextField(
                controller: eventNameController,
                hintText: AppStrings.typeYourEventName,
              ),
              //================================> Event Type Dropdown <=========================
              SizedBox(height: 16.h),
              _sectionTitle(AppStrings.eventType),
              _buildDropdown(),
              //======================================> Venue Name <============================
              SizedBox(height: 16.h),
              _sectionTitle(AppStrings.venueName),
              CustomTextField(
                controller: venueNameController,
                hintText: AppStrings.typeYourVenueName,
              ),
              //======================================> Venue Address <==========================
              SizedBox(height: 16.h),
              _sectionTitle(AppStrings.venueAddress),
              CustomTextField(
                controller: venueAddressController,
                hintText: AppStrings.typeYourVenueAddress,
              ),
              //======================================> Next Button <============================
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

//======================================> Title Text Widget <==============================
  _sectionTitle(String text) {
    return CustomText(
      text: text,
      fontWeight: FontWeight.bold,
      fontsize: 18.sp,
      bottom: 16.h,
    );
  }

//======================================> Image Add Icon <==============================
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

  //======================================> Row Image Container <==============================
  _imageContainer(int index) {
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
                  onPressed: () => _pickImage(
                      (image) => setState(() => eventImages[index] = image)),
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

//======================================> Event Type Dropdown <==============================
  _buildDropdown() {
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
//===============================> Pick Image From Gallery <============================
  Future _pickImage(Function(Uint8List) setImage) async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setImage(File(pickedImage.path).readAsBytesSync());
    }
  }
}
