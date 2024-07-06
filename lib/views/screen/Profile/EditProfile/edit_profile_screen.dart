import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/app_strings.dart';
import '../../../base/custom_button.dart';
import '../../../base/custom_text.dart';
import '../../../base/custom_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _addressController = TextEditingController();
  var parameter = Get.parameters;
  Uint8List? _image;
  File? selectedIMage;

  /*@override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _nameController.text =
      parameter['name']! == "null" ? "" : parameter['name']!;
      _emailController.text = parameter['email']!;
      _phoneNumberController.text =
      parameter['phone']! == 'null' ? "" : parameter['phone']!;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: AppStrings.updateProfile.tr,
          fontWeight: FontWeight.w500,
          fontsize: 18.sp,
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 750.h,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 22.h),
                    Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          _image != null
                              ? Container(
                                  width: 120.w,
                                  height: 120.h,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      border: Border.all(
                                          width: 2.w, color: AppColors.white),
                                      image: DecorationImage(
                                          image: MemoryImage(_image!),
                                          fit: BoxFit.cover)),
                                )
                              : Container(
                                  width: 120.w,
                                  height: 120.h,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      border: Border.all(
                                          width: 2.w, color: AppColors.white),
                                      image: const DecorationImage(
                                          image: NetworkImage(
                                              'https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg'),
                                          fit: BoxFit.cover)),
                                ),
                          Positioned(
                              bottom: -5.h,
                              right: -5.w,
                              child: GestureDetector(
                                  onTap: () {
                                    showImagePickerOption(context);
                                  },
                                  child: SvgPicture.asset(AppIcons.editFram)))
                        ],
                      ),
                    ),
                    //======================================> Text From Field Section <===============================================
                    SizedBox(height: 26.h),
                    CustomTextField(
                        controller: _nameController,
                        hintText: 'Enter your name',
                        prifixicon: _prefixIcon(AppIcons.singlePerson)),
                    SizedBox(height: 16.h),
                    //=================================> Email <=========================
                    CustomTextField(
                        controller: _emailController,
                        hintText: 'Enter your e-mail',
                        prifixicon: _prefixIcon(AppIcons.mailIcon)),
                    SizedBox(height: 16.h),

                    //=================================> Phone Number <=========================
                    CustomTextField(
                      keyboardType: TextInputType.number,
                      controller: _phoneNumberController,
                      hintText: '(000) 000-0000',
                      prifixicon: _prefixIcon(AppIcons.phoneIcon),
                    ),
                    SizedBox(height: 16.h),

                    //=================================> Address <=========================
                    CustomTextField(
                      keyboardType: TextInputType.text,
                      controller: _addressController,
                      hintText: 'Enter your address',
                      prifixicon: _prefixIcon(AppIcons.locationIcon),
                    ),
                    SizedBox(height: 16.h),

                    const Spacer(),

                    //===========================> Update profile button <===================
                    CustomButton(
                        text: AppStrings.updateProfile,
                        textColor: Colors.white,
                        onTap: () {
                          /*_profileController.editProfile(
                              _nameController.text,
                              _phoneNumberController.text,
                              selectedIMage,
                              _emailController.text);*/
                        }),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _prefixIcon(String icon) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w, right: 16.w),
      child: SvgPicture.asset(
        icon,
        fit: BoxFit.contain,
        color: AppColors.primaryColor,
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
    Get.back();
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
