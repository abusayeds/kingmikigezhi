import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../helpers/route.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/app_strings.dart';
import '../../../base/custom_button.dart';
import '../../../base/custom_text.dart';
import '../../../base/custom_text_field.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final TextEditingController birthDayYearController = TextEditingController();
  final TextEditingController birthDayMonthController = TextEditingController();
  final TextEditingController birthDayDayController = TextEditingController();

  final TextEditingController locationCountryController = TextEditingController();
  final TextEditingController locationStateController = TextEditingController();
  final TextEditingController locationCityController = TextEditingController();



  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool isChecked = false;
  String? selectedGender;
  List<String> genderList = ['Male', 'Female'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 20.sp,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //==========================> Sign Up Text Section <=======================
                _signUpTextSection(),
                SizedBox(height: 51.h),
                //==========================> User Name Text Field <=======================
                _textFieldSection(AppStrings.userName, userNameController,
                    AppIcons.singlePerson, 'Enter your user name'),
                //==========================> First Name Text Field <=======================
                _textFieldSection(AppStrings.firstName, firstNameController,
                    AppIcons.singlePerson, 'Enter your first name'),
                //==========================> Last Name Text Field <=======================
                _textFieldSection(AppStrings.lastName, lastNameController,
                    AppIcons.singlePerson, 'Enter your last name'),
                //==========================> Gender DropdownButton <=======================
                CustomText(
                  text: 'Gender',
                  fontWeight: FontWeight.w500,
                  fontsize: 16.sp,
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
                      menuWidth: 240.w,
                      borderRadius: BorderRadius.circular(8.r),
                      hint: Row(
                        children: [
                          SvgPicture.asset(AppIcons.singlePerson,color: AppColors.primaryColor),
                          SizedBox(width: 8.w),
                          Text("Select your Gender", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),),
                        ],
                      ),
                      icon: SvgPicture.asset(AppIcons.downArrowIcon, width: 16.w, color: AppColors.primaryColor,
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
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                //==========================> Birth Date Text Field Row <=======================
                CustomText(
                  text: 'Birthday',
                  fontWeight: FontWeight.w500,
                  fontsize: 16.sp,
                  bottom: 8.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                  ],
                ),
                SizedBox(height: 16.h),
                //==========================> Location Text Field Row <=======================
                CustomText(
                  text: 'Location',
                  fontWeight: FontWeight.w500,
                  fontsize: 16.sp,
                  bottom: 8.h,
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
                           color: AppColors.primaryColor,
                         ),
                       ),

                     ),
                   ),
                   SizedBox(
                     width: 108.w,
                     child: CustomTextField(
                       controller: locationStateController,
                       hintText: 'State',
                     ),
                   ),
                   SizedBox(
                     width: 108.w,
                     child: CustomTextField(
                       controller: locationCityController,
                       hintText: 'City',
                     ),
                   ),
                 ],
               ),
               SizedBox(height: 16.h),

               /* _textFieldSection(AppStrings.location, locationController, null,
                    'Type your address', false),*/
                //==========================> Password Text Field <=======================
                _textFieldSection(AppStrings.password, passwordController,
                    AppIcons.lockIcon, AppStrings.password, true),
                //==========================> Confirm Password Text Field <=======================
                _textFieldSection(
                    AppStrings.confirmPassword,
                    confirmPasswordController,
                    AppIcons.lockIcon,
                    AppStrings.confirmpasswords,
                    true),
                //==========================> Check Box Section <=======================
                _checkboxSection(),
                SizedBox(height: 24.h),
                //==========================> Sign Up Button <=======================
                _signUpButton(),
                SizedBox(height: 24.h),
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
            bottom: 8.h,
          ),
          CustomText(
            text: AppStrings.chooseYourDream,
            bottom: 8.h,
            maxline: 3,
          ),
        ],
      ),
    );
  }

  //==========================> Text Field Widget <=======================
  _textFieldSection(String label, TextEditingController controller,
      String? icon, String hintText,
      [bool isPassword = false]) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: label,
            fontWeight: FontWeight.w500,
            fontsize: 16.sp,
            bottom: 8.h,
          ),
          CustomTextField(
            controller: controller,
            hintText: hintText,
            isPassword: isPassword,
            prifixicon: icon != null
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: SvgPicture.asset(icon, color: AppColors.primaryColor,),
                  )
                : null,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your $label";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  //==========================> Birth Date Text Field <=======================
  _birthDateField() {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: AppStrings.birthday,
            fontWeight: FontWeight.w500,
            fontsize: 16.sp,
            bottom: 8.h,
          ),
          CustomTextField(
            onTab: () {
              _pickBirthDate(context);
            },
            readOnly: true,
            controller: birthDayYearController,
            hintText: 'Month-Day-year',
            sufixicons: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SvgPicture.asset(
                AppIcons.downArrowIcon,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //==========================> Checkbox Section Widget <=======================
  _checkboxSection() {
    return Row(
      children: [
        Checkbox(
          checkColor: Colors.white,
          activeColor: AppColors.primaryColor,
          focusColor: AppColors.greyColor,
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              isChecked = value ?? false;
            });
          },
          side: BorderSide(
            color: isChecked ? AppColors.primaryColor : AppColors.primaryColor,
            width: 1.w,
          ),
        ),
        Text.rich(
          maxLines: 2,
          TextSpan(
            text: 'By creating an account, I accept \nthe ',
            style: TextStyle(fontSize: 14.w, fontWeight: FontWeight.w500),
            children: [
              TextSpan(
                text: 'Terms & Conditions',
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
      ],
    );
  }

  //==========================> Sign Up Button <=======================
  _signUpButton() {
    return CustomButton(
      onTap: () {
        if (_formKey.currentState!.validate()) {
          // Perform sign up action
          Get.toNamed(AppRoutes.homeScreen);
        }
      },
      color: AppColors.buttonColor,
      text: AppStrings.signUp,
      textColor: Colors.white,
    );
  }

  //==========================> Already Have Account Text <=======================
  _alreadyHaveAccountText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          text: AppStrings.alreadyHaveAccount,
          fontWeight: FontWeight.w700,
        ),
        TextButton(
          onPressed: () {
            Get.toNamed(AppRoutes.signInScreen);
          },
          child: CustomText(
            text: AppStrings.logIn,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }

  //==========================> Show Calender Function <=======================
  Future<void> _pickBirthDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(3050),
    );
    if (pickedDate != null) {
      setState(() {
        birthDayYearController.text =
            "${pickedDate.month}-${pickedDate.day}-${pickedDate.year}";
      });
    }
  }
}
