import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:event_sharing/controllers/auth_controller.dart';
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

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final AuthController _authController = Get.find<AuthController>();

  final _accountIdController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();

  Uint8List? _image;
  File? selectedIMage;
  String? existingProfilePicture;

  final TextEditingController birthDayYearController = TextEditingController();
  final TextEditingController birthDayMonthController = TextEditingController();
  final TextEditingController birthDayDayController = TextEditingController();

  final TextEditingController locationCountryController =
      TextEditingController();
  final TextEditingController locationStateController = TextEditingController();
  final TextEditingController locationCityController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  String selectedCountryCodes = '+880';
  String selectedGender = '';
  List<String> skills = [];

  bool isAccountIdEditable = false;
  bool isFirstNameEditable = false;
  bool isLastNameEditable = false;
  bool isUsernameEditable = false;
  bool isGenderEditable = false;
  bool isBirthdayEditable = false;
  bool isLocationEditable = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() {
    final profile = _authController.userProfile.value;
    if (profile != null) {
      _accountIdController.text = profile['accountId']?.toString() ?? '';
      _firstNameController.text = profile['firstName'] ?? '';
      _lastNameController.text = profile['lastName'] ?? '';
      _usernameController.text = profile['username'] ?? '';
      _emailController.text = profile['email'] ?? '';
      existingProfilePicture = profile['profilePicture'];

      final gender = profile['gender'] ?? '';
      selectedGender =
          gender == 'MALE' ? 'Male' : (gender == 'FEMALE' ? 'Female' : '');

      final birthDate = profile['birthDate'] ?? '';
      if (birthDate.isNotEmpty) {
        try {
          final date = DateTime.parse(birthDate);
          birthDayDayController.text = date.day.toString();
          birthDayMonthController.text = date.month.toString();
          birthDayYearController.text = date.year.toString();
        } catch (_) {}
      }

      locationCountryController.text = profile['country'] ?? '';
      locationStateController.text = profile['state'] ?? '';
      locationCityController.text = profile['city'] ?? '';

      final skillsList = profile['skills'] as List?;
      if (skillsList != null) {
        skills = skillsList.map((e) => e.toString()).toList();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 18.w),
          onPressed: () {
            Get.back();
          },
        ),
        title: CustomText(
          text: 'Edit account',
          fontWeight: FontWeight.bold,
          fontsize: 18.sp,
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
                        Obx(() {
                          final profile = _authController.userProfile.value;
                          final profilePicture = profile?['profilePicture'] ?? profile?['image'];
                          
                          return _image != null
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
                                      color: Colors.grey[200],
                                      border: Border.all(
                                          width: 2.w, color: AppColors.white)),
                                  child: profilePicture != null &&
                                          profilePicture.toString().isNotEmpty
                                      ? Image.network(
                                          profilePicture,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) =>
                                              Icon(Icons.person, size: 60.w, color: Colors.grey),
                                        )
                                      : Icon(Icons.person, size: 60.w, color: Colors.grey),
                                );
                        }),
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
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Text('Account ID',
                        style:
                            AppStyles.fontSize16(fontWeight: FontWeight.w600)),
                  ),
                  _buildEditableTextField(
                    controller: _accountIdController,
                    hintText: 'Account ID',
                    isEditable: isAccountIdEditable,
                    onTap: () => setState(() => isAccountIdEditable = true),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Text('First Name',
                        style:
                            AppStyles.fontSize16(fontWeight: FontWeight.w600)),
                  ),
                  _buildEditableTextField(
                    controller: _firstNameController,
                    hintText: 'First Name',
                    isEditable: isFirstNameEditable,
                    onTap: () => setState(() => isFirstNameEditable = true),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Text('Last Name',
                        style:
                            AppStyles.fontSize16(fontWeight: FontWeight.w600)),
                  ),
                  _buildEditableTextField(
                    controller: _lastNameController,
                    hintText: 'Last Name',
                    isEditable: isLastNameEditable,
                    onTap: () => setState(() => isLastNameEditable = true),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Text('Public display name',
                        style:
                            AppStyles.fontSize16(fontWeight: FontWeight.w600)),
                  ),
                  _buildEditableTextField(
                    controller: _usernameController,
                    hintText: 'Username',
                    isEditable: isUsernameEditable,
                    onTap: () => setState(() => isUsernameEditable = true),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Text('Gender',
                        style:
                            AppStyles.fontSize16(fontWeight: FontWeight.w600)),
                  ),
                  _buildGenderSelector(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Text('Birthday',
                        style:
                            AppStyles.fontSize16(fontWeight: FontWeight.w600)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 108.w,
                        child: CustomTextField(
                          controller: birthDayDayController,
                          hintText: 'Day',
                          readOnly: !isBirthdayEditable,
                          sufixicons: Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => isBirthdayEditable = true),
                              child: SvgPicture.asset(
                                AppIcons.downArrowIcon,
                                width: 16.w,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 108.w,
                        child: CustomTextField(
                          controller: birthDayMonthController,
                          hintText: 'Month',
                          readOnly: !isBirthdayEditable,
                          sufixicons: Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => isBirthdayEditable = true),
                              child: SvgPicture.asset(
                                AppIcons.downArrowIcon,
                                width: 16.w,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 108.w,
                        child: CustomTextField(
                          controller: birthDayYearController,
                          hintText: 'Year',
                          readOnly: !isBirthdayEditable,
                          sufixicons: Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => isBirthdayEditable = true),
                              child: SvgPicture.asset(
                                AppIcons.downArrowIcon,
                                width: 16.w,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: Text('Email',
                          style: AppStyles.fontSize16(
                              fontWeight: FontWeight.w600))),
                  CustomTextField(
                    keyboardType: TextInputType.text,
                    controller: _emailController,
                    hintText: 'email@example.com',
                    readOnly: true,
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
                            borderRadius: BorderRadius.circular(8.r)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: 55.h,
                              child: CountryCodePicker(
                                showFlag: false,
                                showFlagDialog: true,
                                onChanged: (countryCode) {
                                  setState(() {
                                    selectedCountryCodes =
                                        countryCode.dialCode!;
                                  });
                                },
                                initialSelection: 'BD',
                                favorite: const ['+880', 'BD'],
                                showCountryOnly: false,
                                showOnlyCountryWhenClosed: false,
                                alignLeft: false,
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(right: 5.w),
                                child: const Icon(Icons.arrow_drop_down_sharp))
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
                          readOnly: !isLocationEditable,
                          sufixicons: Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => isLocationEditable = true),
                              child: SvgPicture.asset(
                                AppIcons.downArrowIcon,
                                width: 16.w,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 108.w,
                        child: CustomTextField(
                          controller: locationStateController,
                          hintText: 'State',
                          readOnly: !isLocationEditable,
                          sufixicons: Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => isLocationEditable = true),
                              child: SvgPicture.asset(
                                AppIcons.downArrowIcon,
                                width: 16.w,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 108.w,
                        child: CustomTextField(
                          controller: locationCityController,
                          hintText: 'City',
                          readOnly: !isLocationEditable,
                          sufixicons: Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => isLocationEditable = true),
                              child: SvgPicture.asset(
                                AppIcons.downArrowIcon,
                                width: 16.w,
                              ),
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Start Year',
                                      style: AppStyles.fontSize16(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(height: 8.h),
                                    Container(
                                      height: 52.h,
                                      padding: const EdgeInsets.symmetric(
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
                                        underline: const SizedBox(),
                                        hint: Text(
                                          '',
                                          style: TextStyle(
                                              color: AppColors.color414141,
                                              fontSize: 14.sp),
                                        ),
                                        items: <String>['2020', '2021', '2023']
                                            .map((String value) {
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
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Program',
                                      style: AppStyles.fontSize16(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(height: 8.h),
                                    Container(
                                      height: 52.h,
                                      padding: const EdgeInsets.symmetric(
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
                                        underline: const SizedBox(),
                                        hint: Text(
                                          '',
                                          style: TextStyle(
                                              color: AppColors.color414141,
                                              fontSize: 14.sp),
                                        ),
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
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            child: CustomButton(
                              color: AppColors.buttonA47059,
                              borderColor: Colors.white,
                              onTap: () {},
                              text: "Add",
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
                                    child: Text('No skills added',
                                        style: AppStyles.fontSize14(
                                            color: AppColors.color414141)),
                                  )
                                : Padding(
                                    padding: EdgeInsets.all(8.r),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: skills.map((skill) {
                                        return SkillRowWidget(
                                            leadingText: skill,
                                            editIconPath:
                                                AppIcons.editIcon,
                                            deleteIconPath:
                                                AppIcons.trashIcon,
                                            onEditTap: () {},
                                            onDeleteTap: () {
                                              setState(() {
                                                skills.remove(skill);
                                              });
                                            });
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
                  Obx(() => CustomButton(
                        color: AppColors.buttonA47059,
                        borderColor: Colors.white,
                        loading: _authController.isLoading.value,
                        onTap: _updateProfile,
                        text: "Update Profile",
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

  Widget _buildEditableTextField({
    required TextEditingController controller,
    required String hintText,
    required bool isEditable,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        absorbing: !isEditable,
        child: CustomTextField(
          controller: controller,
          hintText: hintText,
          readOnly: !isEditable,
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return GestureDetector(
      onTap: () => setState(() => isGenderEditable = true),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isGenderEditable
              ? AppColors.backgroundColor
              : AppColors.colorEDF2F4,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color:
                isGenderEditable ? AppColors.primaryColor : Colors.transparent,
            width: 1.w,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Radio<String>(
                    value: 'Male',
                    groupValue: selectedGender,
                    onChanged: isGenderEditable
                        ? (value) {
                            setState(() {
                              selectedGender = value!;
                            });
                          }
                        : null,
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
                    onChanged: isGenderEditable
                        ? (value) {
                            setState(() {
                              selectedGender = value!;
                            });
                          }
                        : null,
                  ),
                  const Text('Female'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateProfile() async {
    String genderApi = '';
    if (selectedGender == 'Male') {
      genderApi = 'MALE';
    } else if (selectedGender == 'Female') {
      genderApi = 'FEMALE';
    }

    String birthDate = '';
    if (birthDayDayController.text.isNotEmpty &&
        birthDayMonthController.text.isNotEmpty &&
        birthDayYearController.text.isNotEmpty) {
      birthDate =
          '${birthDayYearController.text}-${birthDayMonthController.text.padLeft(2, '0')}-${birthDayDayController.text.padLeft(2, '0')}T00:00:00.000Z';
    }

    final success = await _authController.updateProfile(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      gender: genderApi,
      birthDate: birthDate.isNotEmpty ? birthDate : null,
      phoneNumber: phoneNumberController.text.isNotEmpty
          ? phoneNumberController.text
          : null,
      country: locationCountryController.text,
      state: locationStateController.text,
      city: locationCityController.text,
      username: _usernameController.text,
      imagePath: selectedIMage?.path,
      skills: skills,
    );

    if (success) {
      Get.back();
    }
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
                            const CustomText(text: 'Gallery')
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
                            const CustomText(text: 'Camera')
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
