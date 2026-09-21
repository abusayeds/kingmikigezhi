import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:event_sharing/controllers/auth_controller.dart';
import 'package:event_sharing/utils/phone_utils.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/base/skillItem.dart';
import 'package:event_sharing/views/geo/widgets/country_state_city_picker.dart';
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

  String? selectedDay;
  String? selectedMonth;
  String? selectedYear;

  final List<String> _days =
      List.generate(31, (i) => (i + 1).toString().padLeft(2, '0'));
  final List<String> _months =
      List.generate(12, (i) => (i + 1).toString().padLeft(2, '0'));
  final List<String> _years =
      List.generate(100, (i) => (DateTime.now().year - i).toString());

  String locationCountry = '';
  String locationState = '';
  String locationCity = '';

  final TextEditingController phoneNumberController = TextEditingController();

  // Key forces CountryCodePicker to rebuild when ISO changes via detection.
  Key _countryPickerKey = const ValueKey('BD');
  String selectedCountryCodes = '+880';
  String selectedCountryIso = 'BD';
  String selectedGender = '';
  List<String> skills = [];

  String? _selectedStartYear;
  String? _selectedProgramId;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    if (_authController.editOptionPrograms.isEmpty ||
        _authController.editOptionYears.isEmpty) {
      _authController.fetchEditOptions();
    }
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
          selectedDay = date.day.toString().padLeft(2, '0');
          selectedMonth = date.month.toString().padLeft(2, '0');
          selectedYear = date.year.toString();
        } catch (_) {}
      }

      locationCountry = profile['country']?.toString() ?? '';
      locationState = profile['state']?.toString() ?? '';
      locationCity = profile['city']?.toString() ?? '';

      final phoneNumber = (profile['phoneNumber'] ?? '').toString();
      if (phoneNumber.isNotEmpty) {
        final detected = PhoneUtils.detectCountry(phoneNumber);
        if (detected != null) {
          selectedCountryIso = detected.iso;
          selectedCountryCodes = detected.dialCode;
          _countryPickerKey = ValueKey(detected.iso);
          phoneNumberController.text =
              PhoneUtils.stripDialCode(phoneNumber, detected.dialCode);
        } else {
          phoneNumberController.text = phoneNumber;
        }
      }

      final skillsList = profile['skillLabels'] as List?;
      if (skillsList != null) {
        skills = skillsList.map((e) => e.toString()).toList();
      }
    }
  }

  void _onPhoneNumberChanged(String value) {
    final detected = PhoneUtils.detectCountry(value);
    if (detected != null && detected.iso != selectedCountryIso) {
      setState(() {
        selectedCountryIso = detected.iso;
        selectedCountryCodes = detected.dialCode;
        _countryPickerKey = ValueKey(detected.iso);
        phoneNumberController.text =
            PhoneUtils.stripDialCode(value, detected.dialCode);
      });
    }
  }

  @override
  void dispose() {
    _accountIdController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    phoneNumberController.dispose();
    super.dispose();
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
                                          width: 120.w,
                                          height: 120.h,
                                          errorBuilder: (context, error, stackTrace) =>
                                              Image.asset(
                                            AppImages.logo,
                                            fit: BoxFit.cover,
                                            width: 120.w,
                                            height: 120.h,
                                          ),
                                        )
                                      : Image.asset(
                                          AppImages.logo,
                                          fit: BoxFit.cover,
                                          width: 120.w,
                                          height: 120.h,
                                        ),
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
                    isEditable: true,
                    onTap: () {},
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
                    isEditable: true,
                    onTap: () {},
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
                    isEditable: true,
                    onTap: () {},
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
                    isEditable: true,
                    onTap: () {},
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
                    children: [
                      Expanded(
                        child: _buildBirthdayDropdown(
                          hint: 'Day',
                          value: selectedDay,
                          items: _days,
                          onChanged: (v) => setState(() => selectedDay = v),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: _buildBirthdayDropdown(
                          hint: 'Month',
                          value: selectedMonth,
                          items: _months,
                          onChanged: (v) => setState(() => selectedMonth = v),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: _buildBirthdayDropdown(
                          hint: 'Year',
                          value: selectedYear,
                          items: _years,
                          onChanged: (v) => setState(() => selectedYear = v),
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
                                key: _countryPickerKey,
                                showFlag: true,
                                hideMainText: true,
                                showFlagDialog: true,
                                onChanged: (countryCode) {
                                  setState(() {
                                    selectedCountryCodes =
                                        countryCode.dialCode ??
                                            selectedCountryCodes;
                                    selectedCountryIso =
                                        countryCode.code ?? selectedCountryIso;
                                    _countryPickerKey =
                                        ValueKey(selectedCountryIso);
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
                          onChanged: _onPhoneNumberChanged,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text('Location',
                      style: AppStyles.fontSize16(fontWeight: FontWeight.w600)),
                  SizedBox(height: 8.h),
                  CountryStateCityPicker(
                    initialCountry: locationCountry,
                    initialState: locationState,
                    initialCity: locationCity,
                    onChanged: (country, state, city) {
                      setState(() {
                        locationCountry = country?.name ?? '';
                        locationState = state?.name ?? '';
                        locationCity = city?.name ?? '';
                      });
                    },
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
                                    Obx(() {
                                      final years = _authController
                                          .editOptionYears;
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
                                                  BlendMode.srcIn),
                                            ),
                                            isExpanded: true,
                                            value: _selectedStartYear,
                                            hint: Text(
                                              'Year',
                                              style: TextStyle(
                                                  color:
                                                      AppColors.color414141,
                                                  fontSize: 14.sp),
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
                                                ? (v) => setState(
                                                    () => _selectedStartYear =
                                                        v)
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Program',
                                      style: AppStyles.fontSize16(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(height: 8.h),
                                    Obx(() {
                                      final programs = _authController
                                          .editOptionPrograms;
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
                                                  BlendMode.srcIn),
                                            ),
                                            isExpanded: true,
                                            value: _selectedProgramId,
                                            hint: Text(
                                              'Program',
                                              style: TextStyle(
                                                  color:
                                                      AppColors.color414141,
                                                  fontSize: 14.sp),
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
                                                ? (v) => setState(
                                                    () => _selectedProgramId =
                                                        v)
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
                                }
                              },
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

  Widget _buildBirthdayDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    final safeValue = (value != null && items.contains(value)) ? value : null;
    return Container(
      height: 52.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: AppColors.fillColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.primaryColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: safeValue,
          hint: Text(hint, style: TextStyle(fontSize: 13.sp)),
          items: items
              .map((e) => DropdownMenuItem<String>(
                    value: e,
                    child: Text(e, style: TextStyle(fontSize: 13.sp)),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
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

  Future<void> _updateProfile() async {
    String genderApi = '';
    if (selectedGender == 'Male') {
      genderApi = 'MALE';
    } else if (selectedGender == 'Female') {
      genderApi = 'FEMALE';
    }

    String? birthDate;
    if (selectedDay != null &&
        selectedMonth != null &&
        selectedYear != null) {
      birthDate =
          '$selectedYear-$selectedMonth-${selectedDay}T00:00:00.000Z';
    }

    final fullPhone = PhoneUtils.formatWithDialCode(
      selectedCountryCodes,
      phoneNumberController.text,
    );

    final success = await _authController.updateProfile(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      gender: genderApi,
      birthDate: birthDate,
      phoneNumber: fullPhone.isNotEmpty ? fullPhone : null,
      country: locationCountry,
      state: locationState,
      city: locationCity,
      username: _usernameController.text.trim(),
      accountId: _accountIdController.text.trim(),
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
