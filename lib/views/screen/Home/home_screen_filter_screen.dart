import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/style.dart';
import '../../base/custom_dropdown.dart';
import '../../base/custom_text.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final TextEditingController _categoriesCTRL = TextEditingController();
  final TextEditingController _locationCTRL = TextEditingController();
  final List<String> _program = ['Concert', 'Sports', 'Show', 'Olympic game'];
  final List<String> _type = ['Onsite', 'Online', 'Hybrid'];
  final List<String> _category = ['6 Year - 10 Year', '11 Year - 16 Year', '17 Year+'];

  RangeValues _currentRangeValues = RangeValues(50, 80);
  String? _selectedProgram;
  String? _selectedType;
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //=======================> App Bar Section <============================
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: CustomText(
          text: AppStrings.filter,
          fontsize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
        leading:  Padding(
          padding:  EdgeInsets.only(left:20.w),
          child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 20.sp,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
        ),
        centerTitle: true,
      ),
      //=======================> Body Section <============================
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //==============================> Program Section <=======================
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Text(
                  'Program',
                  style: AppStyles.fieldTitle(),
                ),
              ),
              InputDecorator(
                decoration: InputDecoration(
                  fillColor: AppColors.fillColor,
                  filled: true,

                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryColor, width: 1.w),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryColor, width: 1.w),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryColor, width: 1.w),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    padding: EdgeInsets.symmetric(vertical: 0.w,),                    //focusColor:  AppColors.primaryColor,
                    iconDisabledColor: AppColors.primaryColor,
                    icon: SvgPicture.asset(AppIcons.down_ArrowIcon,color: AppColors.primaryColor,height:8.h,),
                    iconEnabledColor: AppColors.primaryColor,
                    isExpanded: true,
                    value: _selectedProgram,
                    hint: CustomText(text: 'Select Program', fontsize: 14.sp),
                    items: _program.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedProgram = newValue;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              //==============================> Type Section <=======================
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Text(
                  'Type',
                  style: AppStyles.fieldTitle(),
                ),
              ),
              InputDecorator(
                decoration: InputDecoration(

                  fillColor: AppColors.fillColor, // Replace with your desired color
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryColor, width: 1.w),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryColor, width: 1.w),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryColor, width: 1.w),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                ),
                child: DropdownButtonHideUnderline(

                  child: DropdownButton<String>(
                    padding: EdgeInsets.symmetric(vertical: 0.w,),

                    //focusColor:  AppColors.primaryColor,
                    iconDisabledColor: AppColors.primaryColor,
                    iconEnabledColor: AppColors.primaryColor,
                    icon: SvgPicture.asset(AppIcons.down_ArrowIcon,color: AppColors.primaryColor,height:8.h,),
                    isExpanded: true,
                    value: _selectedType,
                    hint: CustomText(text: 'Select Type', fontsize: 14.sp),
                    items: _type.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedType = newValue;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              //==============================> Location Section <=======================
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Text(
                  AppStrings.location,
                  style: AppStyles.fieldTitle(),
                ),
              ),
              CustomTextField(
                controller: _locationCTRL,
                hintText: 'Type here',
                hintTextStyle: AppStyles.fieldContent(
                  color: AppColors.color414141,
                ),
                sufixicons: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: SvgPicture.asset(AppIcons.locationIcon,
                      color: AppColors.primaryColor),
                ),
              ),
              SizedBox(height: 16.h),
              //==============================> Category/Group Section <=======================
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Text(
                  'Category/Group',
                  style: AppStyles.fieldTitle(),
                ),
              ),
              InputDecorator(
                decoration: InputDecoration(
                  fillColor: AppColors.fillColor, // Replace with your desired color
                  filled: true,
                  // labelText: 'Select',
                  border: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: AppColors.primaryColor, width: 1.w),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: AppColors.primaryColor, width: 1.w),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: AppColors.primaryColor, width: 1.w),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    padding: EdgeInsets.symmetric(vertical: 0.w,),
                    //focusColor:  AppColors.primaryColor,
                    iconDisabledColor: AppColors.primaryColor,
                    iconEnabledColor: AppColors.primaryColor,
                    isExpanded: true,
                    value: _selectedCategory,
                    icon: SvgPicture.asset(AppIcons.down_ArrowIcon,color: AppColors.primaryColor,height:8.h,),
                    hint: CustomText(text: 'Select Category/Group', fontsize: 14.sp),
                    items: _category.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Price Range',
                    style: AppStyles.fieldTitle(),
                  ),
                  CustomText(
                    text: '\$20-\$4K',
                    fontWeight: FontWeight.w500,
                    fontsize: 8.sp,
                    bottom: 16.h,
                  ),
                ],
              ),
              //================================> Range Slider Section <================================
              RangeSlider(
                values: _currentRangeValues,
                min: 50,
                max: 4000,
                divisions: 80,
                labels: RangeLabels(
                  '\$${_currentRangeValues.start.round()}',
                  '\$${_currentRangeValues.end.round()}',
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    _currentRangeValues = values;
                  });
                },
                activeColor: AppColors.primaryColor,
                inactiveColor: Colors.blue.withOpacity(0.2),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$${_currentRangeValues.start.round()}',style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 8.sp,
                      color: Color(0xFF20353F)
                    ),),
                    //CustomText(text: '\$${_currentRangeValues.start.round()}'),
                    //CustomText(text: '\$${_currentRangeValues.end.round()}'),
                    Text('\$${_currentRangeValues.end.round()}',style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 8.sp,
                        color: Color(0xFF20353F)
                    ),),
                  ],
                ),
              ),
              SizedBox(height: 131.h),
              // const Spacer(),
              //===========================> Button Section <===============================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomButton(
                      onTap: () {},
                      borderColor: AppColors.buttonColor,
                      text: "Reset",
                      color: AppColors.colorEDF2F4,
                      textColor: Colors.black,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: CustomButton(
                      onTap: () {},
                      text: "Apply",
                      textColor: Colors.white,
                      color: AppColors.buttonColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 75.h),
            ],
          ),
        ),
      ),
    );
  }
}
