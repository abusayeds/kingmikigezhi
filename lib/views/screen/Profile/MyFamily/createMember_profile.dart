import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:event_sharing/controllers/family_controller.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/base/skillItem.dart';
import 'package:event_sharing/views/screen/AddEvent/InnerWidget/dotted_border_container.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/app_strings.dart';
import '../../../base/custom_button.dart';
import '../../../base/custom_text.dart';
import '../../../base/custom_text_field.dart';

class CreateMemberProfileScreen extends StatefulWidget {
  const CreateMemberProfileScreen({super.key});

  @override
  State<CreateMemberProfileScreen> createState() =>
      _CreateMemberProfileScreenState();
}

class _CreateMemberProfileScreenState extends State<CreateMemberProfileScreen> {
  var parameter = Get.parameters;
  Uint8List? _image;
  File? selectedImage;
  String? _selectedRelationship;
  final List<String> relationshipList = ['Brother', 'Father', 'Mother'];

  late FamilyController _familyController;
  String? familyId;

  @override
  void initState() {
    super.initState();
    _familyController = Get.find<FamilyController>();
    familyId = Get.arguments?['familyId'];
  }

  final TextEditingController birthDayYearController = TextEditingController();
  final TextEditingController birthDayMonthController = TextEditingController();
  final TextEditingController birthDayDayController = TextEditingController();

  final TextEditingController locationCountryController =
      TextEditingController();
  final TextEditingController locationStateController = TextEditingController();
  final TextEditingController locationCityController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confrimPasswordController =
      TextEditingController();

  final TextEditingController accountIdController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  final TextEditingController relationShipController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String selectedCountryCodes = '+880';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: CustomText(
          text: AppStrings.createProfile.tr,
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
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Text('Relationship',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    decoration: BoxDecoration(
                      color: AppColors.fillColor,
                      borderRadius: BorderRadius.circular(8.r),
                      border:
                          Border.all(color: AppColors.primaryColor, width: 1),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedRelationship,
                        dropdownColor: AppColors.fillColor,
                        menuWidth: 240.w,
                        borderRadius: BorderRadius.circular(8.r),
                        hint: Text("Select RelationShip",
                            style: AppStyles.fontSize14(
                                color: AppColors.color414141)),
                        icon: SvgPicture.asset(
                          AppIcons.downArrowIcon,
                          width: 16.w,
                          color: AppColors.primaryColor,
                        ),
                        isExpanded: true,
                        items: relationshipList.map((String value) {
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
                            _selectedRelationship = newValue;
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Text('Account Id',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  CustomTextField(
                    controller: accountIdController,
                    hintText: '20103200',
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Text('Full Name',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  CustomTextField(
                    controller: fullNameController,
                    hintText: 'Mahafujer',
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Text('Last Name',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  CustomTextField(
                    controller: lastNameController,
                    hintText: 'Rahman',
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Text('Public Display name',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  CustomTextField(
                    controller: addressController,
                    hintText: 'Public',
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Text('Gender',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  CustomTextField(
                    controller: addressController,
                    hintText: 'Male',
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Text('Birthday',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 108.w,
                        child: CustomTextField(
                          controller: birthDayDayController,
                          hintText: 'Day',
                          sufixicons: Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: SvgPicture.asset(
                              AppIcons.downArrowIcon,
                              width: 16.w,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 108.w,
                        child: CustomTextField(
                          controller: birthDayMonthController,
                          hintText: 'Month',
                          sufixicons: Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: SvgPicture.asset(
                              AppIcons.downArrowIcon,
                              width: 16.w,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 108.w,
                        child: CustomTextField(
                          controller: birthDayYearController,
                          hintText: 'Year',
                          sufixicons: Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: SvgPicture.asset(
                              AppIcons.downArrowIcon,
                              width: 16.w,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Text('Email',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  CustomTextField(
                    keyboardType: TextInputType.text,
                    controller: emailController,
                    hintText: 'Rahman@gmail.com',
                    prifixicon: _prefixIcon(AppIcons.mailIcon),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Text('Phone Number',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: AppColors.fillColor,
                            border: Border.all(
                                width: 1.w, color: AppColors.primaryColor),
                            borderRadius: BorderRadius.circular(8.r)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CountryCodePicker(
                              showFlag: false,
                              showFlagDialog: true,
                              onChanged: (countryCode) {
                                setState(() {
                                  selectedCountryCodes = countryCode.dialCode!;
                                });
                              },
                              initialSelection: 'BD',
                              favorite: ['+880', 'BD'],
                              showCountryOnly: false,
                              showOnlyCountryWhenClosed: false,
                              alignLeft: false,
                            ),
                            Padding(
                                padding: EdgeInsets.only(right: 5.w),
                                child: Icon(Icons.arrow_drop_down_sharp))
                          ],
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: CustomTextField(
                          controller: phoneNumberController,
                          keyboardType: TextInputType.phone,
                          hintText: AppStrings.phoneNumberHintText,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Text('Location',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 108.w,
                        child: CustomTextField(
                          controller: locationCountryController,
                          hintText: 'Country',
                          sufixicons: Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: SvgPicture.asset(
                              AppIcons.downArrowIcon,
                              width: 16.w,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 108.w,
                        child: CustomTextField(
                          controller: locationStateController,
                          hintText: 'State',
                          sufixicons: Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: SvgPicture.asset(
                              AppIcons.downArrowIcon,
                              width: 16.w,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 108.w,
                        child: CustomTextField(
                          controller: locationCityController,
                          hintText: 'City',
                          sufixicons: Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: SvgPicture.asset(
                              AppIcons.downArrowIcon,
                              width: 16.w,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  DottedBorderContainer(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Skill',
                              style: AppStyles.fontSize18(
                                  fontWeight: FontWeight.w500)),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Start Year',
                                        style: AppStyles.fontSize16(
                                            fontWeight: FontWeight.w500)),
                                    SizedBox(height: 8.h),
                                    Container(
                                      height: 52.h,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.borderColor),
                                        borderRadius: BorderRadius.circular(8),
                                        color: AppColors.fillColor,
                                      ),
                                      child: DropdownButton<String>(
                                        icon: SvgPicture.asset(
                                          AppIcons.downArrowIcon,
                                          color: AppColors.primaryColor,
                                        ),
                                        isExpanded: true,
                                        underline: SizedBox(),
                                        hint: Text('Select Year',
                                            style: AppStyles.fontSize14(
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.color414141)),
                                        items: <String>[
                                          'Option 1',
                                          'Option 2',
                                          'Option 3'
                                        ].map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {},
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Program',
                                        style: AppStyles.fontSize16(
                                            fontWeight: FontWeight.w500)),
                                    SizedBox(height: 8.h),
                                    Container(
                                      height: 52.h,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.borderColor),
                                        borderRadius: BorderRadius.circular(8),
                                        color: AppColors.fillColor,
                                      ),
                                      child: DropdownButton<String>(
                                        icon: SvgPicture.asset(
                                          AppIcons.downArrowIcon,
                                          color: AppColors.primaryColor,
                                        ),
                                        isExpanded: true,
                                        underline: SizedBox(),
                                        hint: Text('Select Program',
                                            style: AppStyles.fontSize14(
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.color414141)),
                                        items: <String>[
                                          'Option 1',
                                          'Option 2',
                                          'Option 3'
                                        ].map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {},
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          CustomButton(
                            color: AppColors.buttonA47059,
                            borderColor: AppColors.buttonA47059,
                            onTap: () {},
                            text: "Add",
                            textColor: Colors.white,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Added Skill',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.colorEDF2F4,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.r)),
                              border: Border.all(
                                  color: AppColors.primaryColor, width: 1.w),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8.r),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SkillRowWidget(
                                      leadingText: 'Chess since 2020',
                                      editIconPath: '${AppIcons.editIcon}',
                                      deleteIconPath: '${AppIcons.trashIcon}',
                                      onEditTap: () {},
                                      onDeleteTap: () {}),
                                  SkillRowWidget(
                                      leadingText: 'Math since 2021',
                                      editIconPath: '${AppIcons.editIcon}',
                                      deleteIconPath: '${AppIcons.trashIcon}',
                                      onEditTap: () {},
                                      onDeleteTap: () {}),
                                  SkillRowWidget(
                                      leadingText: 'Piano since 2023',
                                      editIconPath: '${AppIcons.editIcon}',
                                      deleteIconPath: '${AppIcons.trashIcon}',
                                      onEditTap: () {},
                                      onDeleteTap: () {}),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 8.h)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  //======================>>User Name / Password Section
                  DottedBorderContainer(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomButton(
                            color: AppColors.borderColor,
                            borderColor: AppColors.borderColor,
                            onTap: () {},
                            text: "Active a separate family account",
                            textColor: AppColors.white,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            child: Text('User Name',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                          ),
                          CustomTextField(
                            keyboardType: TextInputType.text,
                            controller: emailController,
                            hintText: 'Type User Name',
                            prifixicon: _prefixIcon(AppIcons.mailIcon),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            child: Text('Password',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                          ),
                          CustomTextField(
                            controller: passwordController,
                            hintText: AppStrings.setNewPassword,
                            isPassword: true,
                            prifixicon: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: SvgPicture.asset(
                                AppIcons.lockIcon,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please re-enter your password";
                              }
                              return null;
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            child: Text('Confirm Password',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                          ),
                          CustomTextField(
                            controller: confrimPasswordController,
                            hintText: AppStrings.confirmpasswords,
                            isPassword: true,
                            prifixicon: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: SvgPicture.asset(
                                AppIcons.lockIcon,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please re-enter your password";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Obx(() => CustomButton(
                        color: AppColors.buttonA47059,
                        borderColor: AppColors.buttonA47059,
                        onTap: _familyController.isCreating.value
                            ? () {}
                            : () => _addFamilyMember(),
                        text: _familyController.isCreating.value
                            ? "Creating..."
                            : "Update Profile",
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
      selectedImage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });
    Get.back();
  }

//==================================>> Camera <<===============================
  Future _pickImageFromCamera() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage == null) return;
    setState(() {
      selectedImage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });
    Get.back();
  }

  Future<void> _addFamilyMember() async {
    if (familyId == null) {
      Get.snackbar('Error', 'Family ID not found');
      return;
    }

    final firstName = fullNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final username = accountIdController.text.trim();
    final relationShip = _selectedRelationship;

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        username.isEmpty ||
        relationShip == null) {
      Get.snackbar('Error', 'Please fill all required fields');
      return;
    }

    final birthDay =
        '${birthDayYearController.text}-${birthDayMonthController.text.padLeft(2, '0')}-${birthDayDayController.text.padLeft(2, '0')}';
    final location =
        '${locationCityController.text}, ${locationStateController.text}, ${locationCountryController.text}';

    final success = await _familyController.addFamilyMember(
      familyId: familyId!,
      firstName: firstName,
      lastName: lastName,
      gender: 'MALE',
      birthDate: birthDay,
      location: location,
      country: locationCountryController.text,
      state: locationStateController.text,
      city: locationCityController.text,
      email: email,
      password: password,
      username: username,
      relationShip: relationShip,
    );

    if (success) {
      Get.back();
    }
  }
}
