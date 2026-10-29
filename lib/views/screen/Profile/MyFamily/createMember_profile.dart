import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:event_sharing/controllers/auth_controller.dart';
import 'package:event_sharing/controllers/family_controller.dart';
import 'package:event_sharing/utils/phone_utils.dart';
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
import '../../../../utils/app_images.dart';
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
  Uint8List? _image;
  File? selectedImage;
  String? _selectedRelationship;

  // API relationShip values
  final List<String> relationshipList = [
    'Spous',
    'ChildStephanie',
    'ChildSophia',
    'Other',
  ];

  late FamilyController _familyController;
  late AuthController _authController;
  String? familyId;

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
  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  String selectedCountryCodes = '+880';
  String selectedCountryIso = 'BD';
  String selectedGender = '';
  List<String> skills = [];
  String? _selectedStartYear;
  String? _selectedProgramId;
  bool isIndependent = false;

  @override
  void initState() {
    super.initState();
    _familyController = Get.find<FamilyController>();
    _authController = Get.find<AuthController>();
    familyId = Get.arguments?['familyId'];

    if (_authController.editOptionPrograms.isEmpty ||
        _authController.editOptionYears.isEmpty) {
      _authController.fetchEditOptions();
    }
  }

  @override
  void dispose() {
    birthDayYearController.dispose();
    birthDayMonthController.dispose();
    birthDayDayController.dispose();
    locationCountryController.dispose();
    locationStateController.dispose();
    locationCityController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confrimPasswordController.dispose();
    accountIdController.dispose();
    fullNameController.dispose();
    lastNameController.dispose();
    displayNameController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  void _onPhoneNumberChanged(String value) {
    final detected = PhoneUtils.detectCountry(value);
    if (detected != null && detected.iso != selectedCountryIso) {
      setState(() {
        selectedCountryIso = detected.iso;
        selectedCountryCodes = detected.dialCode;
      });
    }
  }

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
          onPressed: () => Get.back(),
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
                            onTap: () => showImagePickerOption(context),
                            child: SvgPicture.asset(AppIcons.editFram),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: const Text('Relationship',
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
                        hint: Text('Select RelationShip',
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
                          setState(() => _selectedRelationship = newValue);
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: const Text('Account Id',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  CustomTextField(
                    controller: accountIdController,
                    hintText: '20103200',
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: const Text('Full Name',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  CustomTextField(
                    controller: fullNameController,
                    hintText: 'Mahafujer',
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: const Text('Last Name',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  CustomTextField(
                    controller: lastNameController,
                    hintText: 'Rahman',
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: const Text('Public Display name',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  CustomTextField(
                    controller: displayNameController,
                    hintText: 'Public',
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: const Text('Gender',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  _buildGenderSelector(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: const Text('Birthday',
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
                          keyboardType: TextInputType.number,
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
                          keyboardType: TextInputType.number,
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
                          keyboardType: TextInputType.number,
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
                    child: const Text('Email',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  CustomTextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    hintText: 'Rahman@gmail.com',
                    prifixicon: _prefixIcon(AppIcons.mailIcon),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Text('Phone Number',
                        style:
                            AppStyles.fontSize16(fontWeight: FontWeight.w600)),
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
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: 55.h,
                              child: CountryCodePicker(
                                showFlag: true,
                                hideMainText: true,
                                showFlagDialog: true,
                                onChanged: (countryCode) {
                                  setState(() {
                                    selectedCountryCodes =
                                        countryCode.dialCode!;
                                    selectedCountryIso = countryCode.code!;
                                  });
                                },
                                initialSelection: selectedCountryIso,
                                favorite: const ['+880', 'BD'],
                                showCountryOnly: false,
                                showOnlyCountryWhenClosed: false,
                                alignLeft: false,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 5.w),
                              child: const Icon(Icons.arrow_drop_down_sharp),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: CustomTextField(
                          controller: phoneNumberController,
                          keyboardType: TextInputType.phone,
                          hintText: AppStrings.phoneNumberHintText,
                          onChanged: _onPhoneNumberChanged,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text('Location',
                      style: AppStyles.fontSize16(fontWeight: FontWeight.w600)),
                  SizedBox(height: 8.h),
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
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: Text('Skill',
                                style: AppStyles.fontSize16(
                                    fontWeight: FontWeight.w600)),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Start Year',
                                        style: AppStyles.fontSize16(
                                            fontWeight: FontWeight.w600)),
                                    SizedBox(height: 8.h),
                                    Obx(() {
                                      final years =
                                          _authController.editOptionYears;
                                      return Container(
                                        height: 52.h,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.borderColor),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: AppColors.fillColor,
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            icon: SvgPicture.asset(
                                              AppIcons.downArrowIcon,
                                              colorFilter: ColorFilter.mode(
                                                AppColors.primaryColor,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                            isExpanded: true,
                                            value: _selectedStartYear,
                                            hint: Text(
                                              'Year',
                                              style: TextStyle(
                                                color: AppColors.color414141,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                            items: years
                                                .map((y) =>
                                                    DropdownMenuItem<String>(
                                                      value: y.toString(),
                                                      child:
                                                          Text(y.toString()),
                                                    ))
                                                .toList(),
                                            onChanged: years.isNotEmpty
                                                ? (v) => setState(() =>
                                                    _selectedStartYear = v)
                                                : null,
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Program',
                                        style: AppStyles.fontSize16(
                                            fontWeight: FontWeight.w600)),
                                    SizedBox(height: 8.h),
                                    Obx(() {
                                      final programs =
                                          _authController.editOptionPrograms;
                                      return Container(
                                        height: 52.h,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.borderColor),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: AppColors.fillColor,
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            icon: SvgPicture.asset(
                                              AppIcons.downArrowIcon,
                                              colorFilter: ColorFilter.mode(
                                                AppColors.primaryColor,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                            isExpanded: true,
                                            value: _selectedProgramId,
                                            hint: Text(
                                              'Program',
                                              style: TextStyle(
                                                color: AppColors.color414141,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                            items: programs
                                                .map((p) =>
                                                    DropdownMenuItem<String>(
                                                      value: p['id'],
                                                      child: Text(
                                                          p['name'] ?? ''),
                                                    ))
                                                .toList(),
                                            onChanged: programs.isNotEmpty
                                                ? (v) => setState(() =>
                                                    _selectedProgramId = v)
                                                : null,
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            child: CustomButton(
                              color: AppColors.buttonA47059,
                              borderColor: Colors.white,
                              onTap: () {
                                if (_selectedProgramId != null &&
                                    _selectedStartYear != null) {
                                  final programName = _authController
                                          .editOptionPrograms
                                          .firstWhere(
                                            (p) =>
                                                p['id'] == _selectedProgramId,
                                            orElse: () => {'name': ''},
                                          )['name'] ??
                                      '';
                                  final label =
                                      '$programName since $_selectedStartYear';
                                  if (!skills.contains(label)) {
                                    setState(() {
                                      skills.add(label);
                                      _selectedProgramId = null;
                                      _selectedStartYear = null;
                                    });
                                  }
                                } else {
                                  Get.snackbar(
                                    'Error',
                                    'Please select Start Year and Program',
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                }
                              },
                              text: 'Add',
                              textColor: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text('Added Skill',
                              style: AppStyles.fontSize16(
                                  fontWeight: FontWeight.w600)),
                          SizedBox(height: 8.h),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.colorEDF2F4,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.r)),
                              border: Border.all(
                                  color: AppColors.primaryColor, width: 1.w),
                            ),
                            child: skills.isEmpty
                                ? Padding(
                                    padding: EdgeInsets.all(16.h),
                                    child: Text(
                                      'No skills added',
                                      style: AppStyles.fontSize14(
                                          color: AppColors.color414141),
                                    ),
                                  )
                                : Padding(
                                    padding: EdgeInsets.all(8.r),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: skills.map((skill) {
                                        return SkillRowWidget(
                                          leadingText: skill,
                                          editIconPath: AppIcons.editIcon,
                                          deleteIconPath: AppIcons.trashIcon,
                                          onEditTap: () {},
                                          onDeleteTap: () {
                                            setState(
                                                () => skills.remove(skill));
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ),
                          ),
                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  DottedBorderContainer(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomButton(
                            color: isIndependent
                                ? AppColors.buttonA47059
                                : AppColors.borderColor,
                            borderColor: isIndependent
                                ? AppColors.buttonA47059
                                : AppColors.borderColor,
                            onTap: () {
                              setState(() => isIndependent = !isIndependent);
                            },
                            text: isIndependent
                                ? 'Separate family account active'
                                : 'Active a separate family account',
                            textColor: AppColors.white,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            child: const Text('User Name',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                          ),
                          CustomTextField(
                            keyboardType: TextInputType.text,
                            controller: usernameController,
                            hintText: 'Type User Name',
                            prifixicon: _prefixIcon(AppIcons.mailIcon),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            child: const Text('Password',
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
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            child: const Text('Confirm Password',
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
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(() => CustomButton(
                        color: AppColors.buttonA47059,
                        borderColor: AppColors.buttonA47059,
                        onTap: _familyController.isCreating.value
                            ? () {}
                            : () => _addFamilyMember(),
                        text: _familyController.isCreating.value
                            ? 'Creating...'
                            : 'Create Profile',
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

  Widget _buildGenderSelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.primaryColor, width: 1.w),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Radio<String>(
                  value: 'Male',
                  groupValue: selectedGender,
                  onChanged: (value) {
                    setState(() => selectedGender = value!);
                  },
                ),
                const Text('Male'),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Radio<String>(
                  value: 'Female',
                  groupValue: selectedGender,
                  onChanged: (value) {
                    setState(() => selectedGender = value!);
                  },
                ),
                const Text('Female'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _prefixIcon(String icon) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w, right: 16.w),
      child: SvgPicture.asset(
        icon,
        fit: BoxFit.contain,
        color: AppColors.primaryColor,
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
                    onTap: _pickImageFromGallery,
                    child: Column(
                      children: [
                        Icon(Icons.image,
                            size: 50.w, color: AppColors.primaryColor),
                        const CustomText(text: 'Gallery'),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: _pickImageFromCamera,
                    child: Column(
                      children: [
                        Icon(Icons.camera_alt,
                            size: 50.w, color: AppColors.primaryColor),
                        const CustomText(text: 'Camera'),
                      ],
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

  Future<void> _addFamilyMember() async {
    if (familyId == null || familyId!.isEmpty) {
      Get.snackbar('Error', 'Family ID not found',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final firstName = fullNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final email = emailController.text.trim();
    final username = usernameController.text.trim().isNotEmpty
        ? usernameController.text.trim()
        : accountIdController.text.trim();
    final relationShip = _selectedRelationship;
    final password = passwordController.text.trim();
    final confirmPassword = confrimPasswordController.text.trim();

    final day = birthDayDayController.text.trim();
    final month = birthDayMonthController.text.trim();
    final year = birthDayYearController.text.trim();

    final country = locationCountryController.text.trim();
    final state = locationStateController.text.trim();
    final city = locationCityController.text.trim();

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        username.isEmpty ||
        password.isEmpty ||
        relationShip == null ||
        selectedGender.isEmpty ||
        day.isEmpty ||
        month.isEmpty ||
        year.isEmpty ||
        country.isEmpty ||
        state.isEmpty ||
        city.isEmpty) {
      Get.snackbar('Error', 'Please fill all required fields',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar('Error', 'Passwords do not match',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    // API expects MALE / FEMALE
    final genderApi = selectedGender == 'Male' ? 'MALE' : 'FEMALE';

    // API expects YYYY-MM-DD
    final birthDate =
        '$year-${month.padLeft(2, '0')}-${day.padLeft(2, '0')}';

    final location = [city, state, country].join(', ');

    final success = await _familyController.addFamilyMember(
      familyId: familyId!,
      firstName: firstName,
      lastName: lastName,
      gender: genderApi,
      birthDate: birthDate,
      location: location,
      country: country,
      state: state,
      city: city,
      email: email,
      password: password,
      username: username,
      relationShip: relationShip,
      skills: skills,
      isIndependent: isIndependent,
      role: 'MEMBER',
    );

    if (success) {
      Get.back();
    }
  }
}
