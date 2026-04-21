import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:event_sharing/controllers/family_controller.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/utils/app_strings.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:event_sharing/views/base/custom_text_field.dart';

class CreateFamilyGroup extends StatefulWidget {
  const CreateFamilyGroup({super.key});

  @override
  State<CreateFamilyGroup> createState() => _CreateFamilyGroupState();
}

class _CreateFamilyGroupState extends State<CreateFamilyGroup> {
  var parameter = Get.parameters;
  Uint8List? _image;
  File? selectedImage;

  final TextEditingController familyNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  late FamilyController _familyController;

  @override
  void initState() {
    super.initState();
    _familyController = Get.find<FamilyController>();
  }

  @override
  void dispose() {
    familyNameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _createFamily() async {
    final name = familyNameController.text.trim();
    final description = descriptionController.text.trim();

    if (name.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a family name',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    String? imageBase64;
    if (selectedImage != null) {
      final bytes = selectedImage!.readAsBytesSync();
      imageBase64 = base64Encode(bytes);
    }

    final success = await _familyController.createFamily(
      name: name,
      description: description.isNotEmpty ? description : null,
      imageBase64: imageBase64,
    );

    if (success) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: CustomText(
          text: AppStrings.createFamily.tr,
          fontWeight: FontWeight.w500,
          fontsize: 18.sp,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 18.w),
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    fit: BoxFit.cover,
                                  ),
                                ),
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
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                        Positioned(
                          bottom: -5.h,
                          right: -5.w,
                          child: GestureDetector(
                            onTap: () {
                              showImagePickerOption(context);
                            },
                            child: SvgPicture.asset(AppIcons.editFram),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Text('Family Name',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  CustomTextField(
                    controller: familyNameController,
                    hintText: 'My Family',
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Text('Description',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  CustomTextField(
                    controller: descriptionController,
                    hintText: 'Enter description (optional)',
                  ),
                  SizedBox(height: 10),
                  Obx(() => CustomButton(
                        color: AppColors.buttonA47059,
                        borderColor: AppColors.buttonA47059,
                        onTap: _familyController.isCreating.value
                            ? () {}
                            : () => _createFamily(),
                        text: _familyController.isCreating.value
                            ? "Creating..."
                            : "Create Family",
                        textColor: Colors.white,
                      )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

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
                          CustomText(text: 'Gallery'),
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
                          CustomText(text: 'Camera'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    setState(() {
      selectedImage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });
    Get.back();
  }

  Future<void> _pickImageFromCamera() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage == null) return;
    setState(() {
      selectedImage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });
    Get.back();
  }
}
