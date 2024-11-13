import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
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
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
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
  final TextEditingController birthDayYearController = TextEditingController();
  final TextEditingController birthDayMonthController = TextEditingController();
  final TextEditingController birthDayDayController = TextEditingController();

  final TextEditingController locationCountryController = TextEditingController();
  final TextEditingController locationStateController = TextEditingController();
  final TextEditingController locationCityController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  String selectedCountryCodes = '+880';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:  IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Colors.black, size: 18.w),
          onPressed: () {
            Get.back();
          },
        ),
        title: CustomText(
          text:'Edit account',
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
                  SizedBox(height: 12.h),
                  Text('Account ID',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  CustomTextField(
                    controller: _nameController,
                    hintText: '20103200',
                  ),
                  SizedBox(height: 8.h),
                  Text('Full Name',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  CustomTextField(
                    controller: _nameController,
                    hintText: 'Mahafujer',
                  ),
                  SizedBox(height: 8.h),
                  Text('Last Name',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  CustomTextField(
                    controller: _emailController,
                    hintText: 'Rahman',
                  ),
                  //=======================>>> Public display name <<====================
                  SizedBox(height: 8.h),
                  Text('Public display name',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  CustomTextField(
                    controller: _addressController,
                    hintText: 'Public',
                  ),
                  //=======================>>> Gender <<====================
                  SizedBox(height: 8.h),
                  Text('Gender',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  CustomTextField(
                    controller: _addressController,
                    hintText: 'Male',
                  ),
                  SizedBox(height: 8.h),
                  Text('Birthday',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
                  //====================>>  Email <<===================================
                  SizedBox(height: 8.h),
                  Text('Email',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  CustomTextField(
                    keyboardType: TextInputType.text,
                    controller: _emailController,
                    hintText: 'Rahman@gmail.com',
                    prifixicon: _prefixIcon(AppIcons.mailIcon),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text('Phone Number',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
                  //====================>>  Location <<===================================
                  SizedBox(height: 8.h),
                  Text('Location',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
                  SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/RectangleBorder.png'),
                          fit: BoxFit.contain,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            'Skill',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                'Start Year',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                          SizedBox(width: 80.w),
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                'Program',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CustomTextField(
                                controller: locationCountryController,
                                hintText: 'Select Year',
                                sufixicons: Padding(
                                  padding: EdgeInsets.only(right: 12.w),
                                  child: SvgPicture.asset(
                                    AppIcons.downArrowIcon,
                                    width: 16.w,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: CustomTextField(
                                controller: locationCityController,
                                hintText: 'Select Program',
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

                        SizedBox(height: 10),
                        CustomButton(
                            color: AppColors.buttonColor,
                            borderColor: Colors.white,
                            onTap: (){},
                            text: "Add",
                          textColor:Colors.white,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Added Skill',
                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          decoration: BoxDecoration(
                            color:AppColors.colorEDF2F4,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            border: Border.all(color: AppColors.primaryColor, width: 1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '\u2022 ',
                                              style: TextStyle(color: AppColors.primaryColor),
                                            ),
                                            TextSpan(
                                              text: 'Chess since 2020',
                                              style: TextStyle(color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                              onTap: (){
                                                Get.back();
                                              },
                                              child: SvgPicture.asset(AppIcons.editIcon)
                                          ),
                                          SizedBox(width: 4),
                                          InkWell(
                                              onTap: (){
                                                Get.back();
                                              },
                                              child: SvgPicture.asset(AppIcons.trashIcon)
                                          )
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '\u2022 ',
                                              style: TextStyle(color: AppColors.primaryColor),
                                            ),
                                            TextSpan(
                                              text: 'Math since 2021',
                                              style: TextStyle(color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                              onTap: (){
                                                Get.back();
                                              },
                                              child: SvgPicture.asset(AppIcons.editIcon)
                                          ),
                                          SizedBox(width: 4),
                                          InkWell(
                                              onTap: (){
                                                Get.back();
                                              },
                                              child: SvgPicture.asset(AppIcons.trashIcon)
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '\u2022 ',
                                              style: TextStyle(color: AppColors.primaryColor),
                                            ),
                                            TextSpan(
                                              text: 'Piano since 2023',
                                              style: TextStyle(color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                              onTap: (){
                                                Get.back();
                                              },
                                              child: SvgPicture.asset(AppIcons.editIcon)
                                          ),
                                          SizedBox(width: 4),
                                          InkWell(
                                              onTap: (){
                                                Get.back();
                                              },
                                              child: SvgPicture.asset(AppIcons.trashIcon)
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),

                  SizedBox(height: 10),
                  CustomButton(
                    color: AppColors.buttonColor,
                    borderColor: Colors.white,
                    onTap: (){},
                    text: "Update Profile",
                    textColor:Colors.white,
                  ),
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
