import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
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
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  var parameter = Get.parameters;
  Uint8List? _image;
  File? selectedIMage;

  final TextEditingController birthDayYearController = TextEditingController();
  final TextEditingController birthDayMonthController = TextEditingController();
  final TextEditingController birthDayDayController = TextEditingController();

  final TextEditingController locationCountryController = TextEditingController();
  final TextEditingController locationStateController = TextEditingController();
  final TextEditingController locationCityController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  String selectedCountryCodes = '+880';
  final List<Map<String, String>> skills = [
    {'name': 'Chess since 2020'},
    {'name': 'Math  since 2021',},
    {'name': 'Piano since 2022',},
  ];


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
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Text('Account ID', style:  AppStyles.fontSize16(fontWeight: FontWeight.w600)),
                  ),
                  CustomTextField(
                    controller: _nameController,
                    hintText: '20103200',
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Text('Full Name', style: AppStyles.fontSize16(fontWeight: FontWeight.w600 )),
                  ),
                  CustomTextField(
                    controller: _nameController,
                    hintText: 'Mahafujer',
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Text('Last Name', style:  AppStyles.fontSize16(fontWeight: FontWeight.w600 )),
                  ),
                  CustomTextField(
                    controller: _emailController,
                    hintText: 'Rahman',
                  ),
                  //=======================>>> Public display name <<====================

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Text('Public display name', style: AppStyles.fontSize16(fontWeight: FontWeight.w600 )),
                  ),
                  CustomTextField(
                    controller: _addressController,
                    hintText: 'Public',
                  ),
                  //=======================>>> Gender <<====================
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Text('Gender', style:  AppStyles.fontSize16(fontWeight: FontWeight.w600 )),
                  ),
                  CustomTextField(
                    controller: _addressController,
                    hintText: 'Male',
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Text('Birthday',style:  AppStyles.fontSize16(fontWeight: FontWeight.w600 )),
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
                  //====================>>  Email <<===================================
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: Text('Email', style:  AppStyles.fontSize16(fontWeight: FontWeight.w600 ))),
                  CustomTextField(
                    keyboardType: TextInputType.text,
                    controller: _emailController,
                    hintText: 'Rahman@gmail.com',
                    prifixicon: _prefixIcon(AppIcons.mailIcon),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Text('Phone Number', style:  AppStyles.fontSize16(fontWeight: FontWeight.w600)),
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
                                    selectedCountryCodes = countryCode.dialCode!;
                                  });
                                },
                                initialSelection: 'BD',
                                favorite: ['+880', 'BD'],
                                showCountryOnly: false,
                                showOnlyCountryWhenClosed: false,
                                alignLeft: false,
                              ),
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
                  Text('Location', style: AppStyles.fontSize16(fontWeight: FontWeight.w600)),
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
                            padding:  EdgeInsets.only(bottom: 8.h),
                            child: Text(
                              'Skill', style: AppStyles.fontSize16(fontWeight: FontWeight.w600 )),
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
                                      style:  AppStyles.fontSize16(fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(height: 8.h),
                                    Container(
                                      height: 52.h,
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        border: Border.all(color:AppColors.borderColor),
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
                                        hint: Text('', style: TextStyle(color: AppColors.color414141, fontSize: 14.sp),),
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
                                      style:  AppStyles.fontSize16(fontWeight: FontWeight.w600 ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Container(
                                      height: 52.h,
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: AppColors.borderColor),
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
                                        hint: Text('', style: TextStyle(color: AppColors.color414141, fontSize: 14.sp),),
                                        items: <String>['Option 1', 'Option 2', 'Option 3']
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
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            child: CustomButton(
                                color: AppColors.buttonA47059,
                                borderColor: Colors.white,
                                onTap: (){},
                                text: "Add",
                              textColor:Colors.white,
                            ),
                          ),
                          SizedBox(height: 8.h),

                          Text('Added Skill', style: AppStyles.fontSize16(fontWeight: FontWeight.w600)),
                          SizedBox(height: 8.h),
                          Container(
                            decoration: BoxDecoration(
                              color:AppColors.colorEDF2F4,
                              borderRadius: BorderRadius.all(Radius.circular(8.r)),
                              border: Border.all(color: AppColors.primaryColor, width: 1.w),
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
                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 10),
                  CustomButton(
                    color: AppColors.buttonA47059,
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
