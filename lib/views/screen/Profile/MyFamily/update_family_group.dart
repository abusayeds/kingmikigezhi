import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:event_sharing/controllers/family_controller.dart';
import 'package:event_sharing/helpers/route_args.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/utils/app_images.dart';
import 'package:event_sharing/utils/app_strings.dart';
import 'package:event_sharing/utils/media_url_utils.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_network_image.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:event_sharing/views/base/custom_text_field.dart';

class UpdateFamilyGroup extends StatefulWidget {
  const UpdateFamilyGroup({super.key});

  @override
  State<UpdateFamilyGroup> createState() => _UpdateFamilyGroupState();
}

class _UpdateFamilyGroupState extends State<UpdateFamilyGroup> {
  var parameter = Get.parameters;
  Uint8List? _image;
  File? selectedImage;

  final TextEditingController familyNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  late FamilyController _familyController;
  String? familyId;
  String? currentImageUrl;

  @override
  void initState() {
    super.initState();
    _familyController = Get.find<FamilyController>();

    // First check route parameters, then arguments
    familyId = parameter['familyId'];
    if (familyId == null) {
      final argId = routeArgString('familyId');
      familyId = argId.isEmpty ? null : argId;
    }

    if (familyId != null) {
      _loadFamilyData();
    }
  }

  Future<void> _loadFamilyData() async {
    if (familyId == null) return;

    final family = await _familyController.getFamilyById(familyId!);
    if (family != null) {
      familyNameController.text = family.name;
      descriptionController.text = family.description ?? '';
      currentImageUrl = MediaUrlUtils.resolve(family.imageUrl);
      setState(() {});
    }
  }

  @override
  void dispose() {
    familyNameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _updateFamily() async {
    if (familyId == null) return;

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

    final success = await _familyController.updateFamily(
      familyId: familyId!,
      name: name,
      description: description.isNotEmpty ? description : null,
      imagePath: selectedImage?.path,
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
          text: AppStrings.updateFamily.tr,
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
                            : currentImageUrl != null &&
                                    currentImageUrl!.isNotEmpty
                                ? CustomNetworkImage(
                                    imageUrl: currentImageUrl!,
                                    height: 120.h,
                                    width: 120.w,
                                    border: Border.all(
                                        width: 2.w, color: AppColors.white),
                                  )
                                : Container(
                                    width: 120.w,
                                    height: 120.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      border: Border.all(
                                          width: 2.w, color: AppColors.white),
                                      image: DecorationImage(
                                        image: AssetImage(AppImages.logo),
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
                    child: const Text('Family Name',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  CustomTextField(
                    controller: familyNameController,
                    hintText: 'My Family',
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: const Text('Description',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  CustomTextField(
                    controller: descriptionController,
                    hintText: 'Enter description (optional)',
                  ),
                  const SizedBox(height: 10),
                  Obx(() => CustomButton(
                        color: AppColors.buttonA47059,
                        borderColor: AppColors.buttonA47059,
                        onTap: _familyController.isUpdating.value
                            ? () {}
                            : () => _updateFamily(),
                        text: _familyController.isUpdating.value
                            ? "Updating..."
                            : "Update Family",
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
                          const CustomText(text: 'Gallery'),
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
                          const CustomText(text: 'Camera'),
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
