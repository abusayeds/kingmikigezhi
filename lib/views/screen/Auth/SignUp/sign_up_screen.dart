import 'package:event_sharing/utils/style.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'dart:async';
import '../../../../controllers/auth_controller.dart';
import '../../../../helpers/route.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/app_strings.dart';
import '../../../../utils/app_constants.dart';
import '../../../base/custom_button.dart';
import '../../../base/custom_text.dart';
import '../../../base/custom_text_field.dart';
import '../../../geo/models/country.dart';
import '../../../geo/models/city_state.dart';
import '../../../geo/models/city.dart';
import '../../../geo/services/geo_data_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isChecked = false;
  String? selectedGender;
  String? selectedYear;
  String? selectedMonth;
  String? selectedDay;

  String? _termsError;
  String? _genderError;
  String? _birthdayError;
  String? _countryError;
  String? _passwordMatchError;

  // Auth controller instance
  final AuthController authController = Get.find<AuthController>();

  // Username validation
  String? _usernameError;
  bool _isCheckingUsername = false;
  Timer? _usernameDebounce;

  List<String> genderList = ['Male', 'Female'];

  // =========================> GeoNames data <=========================
  final GeoDataService _geoService = GeoDataService.instance;

  List<Country> _countries = [];
  List<CityState> _states = [];
  List<City> _cities = [];

  Country? _selectedCountry;
  CityState? _selectedState;
  City? _selectedCity;

  bool _isLoadingCountries = true;
  bool _isLoadingStates = false;
  bool _isLoadingCities = false;

  @override
  void initState() {
    super.initState();
    userNameController.addListener(_onUsernameChanged);
    _loadCountries();
  }

  @override
  void dispose() {
    userNameController.removeListener(_onUsernameChanged);
    userNameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    genderController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    _usernameDebounce?.cancel();
    super.dispose();
  }

  //==========================> Load countries from GeoDataService <=========================
  Future<void> _loadCountries() async {
    final countries = await _geoService.getCountries();
    if (!mounted) return;
    setState(() {
      _countries = countries;
      _isLoadingCountries = false;
    });
  }

  //==========================> On country changed <=========================
  Future<void> _onCountryChanged(Country? country) async {
    setState(() {
      _selectedCountry = country;
      _selectedState = null;
      _selectedCity = null;
      _states = [];
      _cities = [];
      _isLoadingStates = true;
      if (country != null) _countryError = null;
    });

    if (country == null) {
      setState(() => _isLoadingStates = false);
      return;
    }

    final states = await _geoService.getStatesByCountry(country.id);
    if (!mounted) return;
    setState(() {
      _states = states;
      _isLoadingStates = false;
    });
  }

  //==========================> On state changed <=========================
  Future<void> _onStateChanged(CityState? state) async {
    setState(() {
      _selectedState = state;
      _selectedCity = null;
      _cities = [];
      _isLoadingCities = true;
    });

    if (state == null) {
      setState(() => _isLoadingCities = false);
      return;
    }

    final cities = await _geoService.getCitiesByState(state.id);
    if (!mounted) return;
    setState(() {
      _cities = cities;
      _isLoadingCities = false;
    });
  }

  //==========================> On city changed <=========================
  void _onCityChanged(City? city) {
    setState(() => _selectedCity = city);
  }

  // Check username availability with debounce
  void _onUsernameChanged() {
    _usernameDebounce?.cancel();

    final username = userNameController.text.trim();

    setState(() {
      _usernameError = null;
      _isCheckingUsername = false;
    });

    if (username.isEmpty) return;

    if (username.length < 3) {
      setState(() {
        _usernameError = 'Username must be at least 3 characters';
      });
      return;
    }

    _usernameDebounce = Timer(const Duration(milliseconds: 800), () async {
      setState(() => _isCheckingUsername = true);

      final exists = await authController.checkUsername(username);

      if (mounted) {
        setState(() {
          _isCheckingUsername = false;
          _usernameError = exists ? 'This username is already taken' : null;
        });
      }
    });
  }

  // Birthday dropdown data
  List<String> yearList = List.generate(100, (index) => (2024 - index).toString());
  List<String> monthList = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  List<String> dayList = List.generate(31, (index) => (index + 1).toString().padLeft(2, '0'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 18.w,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //==========================> Sign Up Text Section <=======================
                _signUpTextSection(),
                SizedBox(height: 48.h),
                //==========================> User Name Text Field <=======================
                _userNameTextField(),
                //==========================> First Name Text Field <=======================
                _textFieldSection('First Name', firstNameController,
                    AppIcons.singlePerson, 'Enter your first name'),
                //==========================> Last Name Text Field <=======================
                _textFieldSection('Last Name', lastNameController,
                    AppIcons.singlePerson, 'Enter your last name'),
                //=================================> Email Text Field <=========================
                _textFieldSection('Email', emailController,
                    AppIcons.mailIcon, 'Enter your Email', false, true),
                SizedBox(height: 16.h),
                //==========================> Gender DropdownButton <=======================
                _genderDropdown(),
                SizedBox(height: 16.h),
                //==========================> Birth Date Dropdown Row <=======================
                _birthdayDropdownSection(),
                SizedBox(height: 16.h),
                //==========================> Location Dropdown Row <=======================
                _locationDropdownSection(),
                SizedBox(height: 16.h),
                //==========================> Password Text Field <=======================
                _textFieldSection(AppStrings.password, passwordController,
                    AppIcons.lockIcon, AppStrings.password, true),
                //==========================> Confirm Password Text Field <=======================
                _textFieldSection(
                    AppStrings.confirmPassword,
                    confirmPasswordController,
                    AppIcons.lockIcon,
                    AppStrings.confirmpasswords,
                    true, false, (value) {
                  setState(() {
                    _passwordMatchError = null;
                  });
                }),
                if (_passwordMatchError != null)
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.h, top: 4.h),
                    child: Text(
                      _passwordMatchError!,
                      style: TextStyle(color: Colors.red, fontSize: 12.sp),
                    ),
                  ),
                //==========================> Check Box Section <=======================
                _checkboxSection(),
                SizedBox(height: 24.h),
                //==========================> Sign Up Button <=======================
                _signUpButton(),
                SizedBox(height: 32.h),
                //==========================> Already Have Account Text <=======================
                _alreadyHaveAccountText(),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //==========================> Sign Up Text Widget <=======================
  _signUpTextSection() {
    return Center(
      child: Column(
        children: [
          CustomText(
            text: AppStrings.signUpAn,
            fontWeight: FontWeight.w600,
            fontsize: 22.sp,
          ),
        ],
      ),
    );
  }

  //==========================> Gender Dropdown Widget <=======================
  _genderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Gender',
          fontWeight: FontWeight.w500,
          fontsize: 14.sp,
          bottom: 8.h,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            color: AppColors.fillColor,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.primaryColor, width: 1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedGender,
              dropdownColor: AppColors.fillColor,
              padding: EdgeInsets.symmetric(vertical: 6.w),
              menuWidth: 240.w,
              borderRadius: BorderRadius.circular(8.r),
              hint: Row(
                children: [
                  Text("Select your Gender", style: AppStyles.fontSize16()),
                ],
              ),
              icon: SvgPicture.asset(
                AppIcons.downArrowIcon,
                width: 16.w,
                color: AppColors.primaryColor,
              ),
              isExpanded: true,
              items: genderList.map((String value) {
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
                  selectedGender = newValue;
                  if (newValue != null) _genderError = null;
                });
              },
            ),
          ),
        ),
        if (_genderError != null)
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Text(
              _genderError!,
              style: TextStyle(color: Colors.red, fontSize: 12.sp),
            ),
          ),
      ],
    );
  }

  //==========================> Birthday Dropdown Section <=======================
  _birthdayDropdownSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Birthday',
          fontWeight: FontWeight.w500,
          fontsize: 14.sp,
          bottom: 8.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStringDropdownField(
              value: selectedYear,
              items: yearList,
              hint: 'Year',
              width: 108.w,
              onChanged: (value) {
                setState(() {
                  selectedYear = value;
                  if (value != null) _birthdayError = null;
                });
              },
            ),
            _buildStringDropdownField(
              value: selectedMonth,
              items: monthList,
              hint: 'Month',
              width: 108.w,
              onChanged: (value) {
                setState(() {
                  selectedMonth = value;
                  if (value != null) _birthdayError = null;
                });
              },
            ),
            _buildStringDropdownField(
              value: selectedDay,
              items: dayList,
              hint: 'Day',
              width: 108.w,
              onChanged: (value) {
                setState(() {
                  selectedDay = value;
                  if (value != null) _birthdayError = null;
                });
              },
            ),
          ],
        ),
        if (_birthdayError != null)
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Text(
              _birthdayError!,
              style: TextStyle(color: Colors.red, fontSize: 12.sp),
            ),
          ),
      ],
    );
  }

  //==========================> Location Dropdown Section (GeoNames) <=======================
  _locationDropdownSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Location',
          fontWeight: FontWeight.w500,
          fontsize: 14.sp,
          bottom: 8.h,
        ),
        // -------- Country --------
        _buildGeoDropdownField<Country>(
          value: _selectedCountry,
          items: _countries,
          hint: _isLoadingCountries ? 'Loading countries...' : 'Country',
          isLoading: _isLoadingCountries,
          onChanged: _isLoadingCountries ? null : _onCountryChanged,
        ),
        SizedBox(height: 8.h),
        // -------- State --------
        _buildGeoDropdownField<CityState>(
          value: _selectedState,
          items: _states,
          hint: _isLoadingStates ? 'Loading states...' : 'State / Province',
          isLoading: _isLoadingStates,
          onChanged: (!_isLoadingStates && _states.isNotEmpty)
              ? _onStateChanged
              : null,
        ),
        SizedBox(height: 8.h),
        // -------- City --------
        _buildGeoDropdownField<City>(
          value: _selectedCity,
          items: _cities,
          hint: _isLoadingCities ? 'Loading cities...' : 'City',
          isLoading: _isLoadingCities,
          onChanged: (!_isLoadingCities && _cities.isNotEmpty)
              ? _onCityChanged
              : null,
        ),
        if (_countryError != null)
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Text(
              _countryError!,
              style: TextStyle(color: Colors.red, fontSize: 12.sp),
            ),
          ),
      ],
    );
  }

  //==========================> Generic Geo Dropdown Field Builder <=======================
  Widget _buildGeoDropdownField<T>({
    required T? value,
    required List<T> items,
    required String hint,
    required Function(T?)? onChanged,
    bool isLoading = false,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.fillColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.primaryColor, width: 1),
      ),
      child: Row(
        children: [
          if (isLoading) ...[
            SizedBox(
              width: 14.w,
              height: 14.w,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
              ),
            ),
            SizedBox(width: 8.w),
          ],
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                value: value,
                dropdownColor: AppColors.fillColor,
                padding: EdgeInsets.symmetric(vertical: 6.w),
                borderRadius: BorderRadius.circular(8.r),
                hint: Text(
                  hint,
                  style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                ),
                icon: SvgPicture.asset(
                  AppIcons.downArrowIcon,
                  width: 16.w,
                  color: AppColors.primaryColor,
                ),
                isExpanded: true,
                items: items.map((T item) {
                  return DropdownMenuItem<T>(
                    value: item,
                    child: Text(
                      item.toString(),
                      style: TextStyle(color: Colors.black, fontSize: 14.sp),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //==========================> Generic String Dropdown Field Builder (birthday) <=======================
  Widget _buildStringDropdownField({
    required String? value,
    required List<String> items,
    required String hint,
    required double width,
    required Function(String?) onChanged,
  }) {
    return SizedBox(
      width: width,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: AppColors.fillColor,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.primaryColor, width: 1),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            dropdownColor: AppColors.fillColor,
            padding: EdgeInsets.symmetric(vertical: 6.w),
            borderRadius: BorderRadius.circular(8.r),
            hint: Text(
              hint,
              style: TextStyle(color: Colors.grey, fontSize: 14.sp),
            ),
            icon: SvgPicture.asset(
              AppIcons.downArrowIcon,
              width: 16.w,
              color: AppColors.primaryColor,
            ),
            isExpanded: true,
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(color: Colors.black, fontSize: 14.sp),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: items.isNotEmpty ? onChanged : null,
          ),
        ),
      ),
    );
  }

  //==========================> Username Text Field Widget with Validation <=======================
  _userNameTextField() {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'User Name',
            fontWeight: FontWeight.w500,
            fontsize: 14.sp,
            bottom: 8.h,
          ),
          CustomTextField(
            controller: userNameController,
            hintText: 'Enter your user name',
            prifixicon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.h),
              child: SvgPicture.asset(
                AppIcons.singlePerson,
                color: AppColors.primaryColor,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your username";
              }
              if (_usernameError != null) {
                return _usernameError;
              }
              return null;
            },
          ),
          // Error message or loading indicator
          if (_usernameError != null || _isCheckingUsername)
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Row(
                children: [
                  if (_isCheckingUsername)
                    SizedBox(
                      width: 12.w,
                      height: 12.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                      ),
                    )
                  else if (_usernameError != null)
                    Icon(Icons.error_outline, size: 14.sp, color: Colors.red),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: CustomText(
                      text: _isCheckingUsername
                          ? 'Checking username...'
                          : (_usernameError ?? ''),
                      fontsize: 12.sp,
                      color: _isCheckingUsername ? AppColors.primaryColor : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  //==========================> Text Field Widget <=======================
  _textFieldSection(String label, TextEditingController controller,
      String? icon, String hintText,
      [bool isPassword = false, bool isEmail = false, ValueChanged<String>? onChanged]) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: label,
            fontWeight: FontWeight.w500,
            fontsize: 14.sp,
            bottom: 8.h,
          ),
          CustomTextField(
            controller: controller,
            hintText: hintText,
            isPassword: isPassword,
            isEmail: isEmail,
            prifixicon: icon != null
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.h),
                    child: SvgPicture.asset(icon, color: AppColors.primaryColor),
                  )
                : null,
            onChanged: onChanged,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your $label";
              }
              if (isEmail) {
                bool data = AppConstants.emailValidator.hasMatch(value);
                if (!data) return "Please check your email!";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  //==========================> Checkbox Section Widget <=======================
  _checkboxSection() {
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isChecked = !isChecked;
                  if (isChecked) _termsError = null;
                });
              },
              child: Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: isChecked ? AppColors.primaryColor : Colors.transparent,
                  border: Border.all(color: AppColors.primaryColor, width: 1.w),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: isChecked
                    ? Icon(Icons.check, color: Colors.white, size: 14.sp)
                    : null,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text.rich(
                maxLines: 2,
                TextSpan(
                  text: 'By creating an account, I accept the',
                  style: TextStyle(fontSize: 14.w, fontWeight: FontWeight.w500),
                  children: [
                    TextSpan(
                      text: 'Terms\n& Conditions',
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 14.w,
                          fontWeight: FontWeight.w500),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.toNamed(AppRoutes.termsConditionScreen);
                        },
                    ),
                    const TextSpan(text: ' & '),
                    TextSpan(
                      text: 'Privacy Policy.',
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 14.w,
                          fontWeight: FontWeight.w500),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.toNamed(AppRoutes.privacyPolicyScreen);
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (_termsError != null)
          Padding(
            padding: EdgeInsets.only(top: 4.h, left: 30.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _termsError!,
                style: TextStyle(color: Colors.red, fontSize: 12.sp),
              ),
            ),
          ),
      ],
    );
  }

  //==========================> Sign Up Button <=======================
  _signUpButton() {
    return Obx(() => CustomButton(
          onTap: () async {
            if (authController.isLoading.value) return;

            setState(() {
              _termsError = null;
              _genderError = null;
              _birthdayError = null;
              _countryError = null;
              _passwordMatchError = null;
            });

            if (!_formKey.currentState!.validate()) return;

            if (!isChecked) {
              setState(() {
                _termsError =
                    'Please accept the Terms & Conditions and Privacy Policy';
              });
              return;
            }

            if (selectedGender == null) {
              setState(() {
                _genderError = 'Please select your gender';
              });
              return;
            }

            if (selectedYear == null ||
                selectedMonth == null ||
                selectedDay == null) {
              setState(() {
                _birthdayError = 'Please select your complete birthday';
              });
              return;
            }

            if (_selectedCountry == null) {
              setState(() {
                _countryError = 'Please select your country';
              });
              return;
            }

            if (passwordController.text != confirmPasswordController.text) {
              setState(() {
                _passwordMatchError = 'Passwords do not match';
              });
              return;
            }

            if (_usernameError != null) return;
            if (_isCheckingUsername) return;

            int monthIndex = monthList.indexOf(selectedMonth!) + 1;
            String formattedBirthday =
                '$selectedYear-${monthIndex.toString().padLeft(2, '0')}-$selectedDay';

            bool success = await authController.registerUser(
              username: userNameController.text.trim(),
              email: emailController.text.trim(),
              firstName: firstNameController.text.trim(),
              lastName: lastNameController.text.trim(),
              gender: selectedGender!,
              birthday: formattedBirthday,
              country: _selectedCountry!.name,
              state: _selectedState?.name ?? '',
              city: _selectedCity?.name ?? '',
              password: passwordController.text,
              confirmPassword: confirmPasswordController.text,
              acceptTerms: isChecked,
            );

            if (success) {
              Get.toNamed(
                AppRoutes.signUpOtpVerificationScreen,
                arguments: {
                  'sessionId': authController.storedSessionId.value,
                  'email': emailController.text.trim(),
                },
              );
            }
          },
          color: AppColors.buttonColor,
          text: AppStrings.signUp,
          textColor: Colors.white,
          loading: authController.isLoading.value,
        ));
  }

  //==========================> Already Have Account Text <=======================
  _alreadyHaveAccountText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          fontsize: 12.sp,
          text: AppStrings.alreadyHaveAccount,
          fontWeight: FontWeight.w400,
        ),
        TextButton(
            onPressed: () {
              Get.toNamed(AppRoutes.signInScreen);
            },
            child: CustomText(
              fontsize: 12.sp,
              text: "Sign In",
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.underline,
              lineHeight: 1.5.h,
            ))
      ],
    );
  }
}
