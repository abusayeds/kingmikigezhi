import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/utils/app_strings.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:event_sharing/views/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MyEventFilterScreen extends StatefulWidget {
  const MyEventFilterScreen({super.key});

  @override
  State<MyEventFilterScreen> createState() => _MyEventFilterScreenState();
}

class _MyEventFilterScreenState extends State<MyEventFilterScreen> {
  final TextEditingController _locationCTRL = TextEditingController();
  final List<String> _program = [
    'Musical Instrument',
    'Keyboard',
    'Piano',
    'Chess',
    'Ballet'
  ];
  final List<String> _type = ['Onsite', 'Online', 'Hybrid'];
  final List<String> _category = [
    '6 Year - 10 Year',
    '11 Year - 16 Year',
    '17 Year+'
  ];
  RangeValues _currentRangeValues = const RangeValues(50, 4000);
  String? _selectedProgram;
  String? _selectedType;
  String? _selectedCategory;

  String _mapCategoryGroup(String? displayValue) {
    if (displayValue == null) return '';
    switch (displayValue) {
      case '6 Year - 10 Year':
        return '6year-10year';
      case '11 Year - 16 Year':
        return '11year-16year';
      case '17 Year+':
        return '17year+';
      default:
        return displayValue;
    }
  }

  @override
  void dispose() {
    _locationCTRL.dispose();
    super.dispose();
  }

  void _onReset() {
    FocusScope.of(context).unfocus();
    setState(() {
      _selectedProgram = null;
      _selectedType = null;
      _selectedCategory = null;
      _locationCTRL.clear();
      _currentRangeValues = const RangeValues(50, 4000);
    });
    Get.snackbar(
      'Filter',
      'Filters reset',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  void _onApply() {
    FocusScope.of(context).unfocus();
    final location = _locationCTRL.text.trim();
    final hasAny = (_selectedProgram?.isNotEmpty ?? false) ||
        (_selectedType?.isNotEmpty ?? false) ||
        (_selectedCategory?.isNotEmpty ?? false) ||
        location.isNotEmpty;

    if (!hasAny) {
      Get.snackbar(
        'Filter',
        'Select at least one filter or enter a location',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    final result = <String, dynamic>{
      'program': _selectedProgram,
      'type': _selectedType,
      'category': _mapCategoryGroup(_selectedCategory),
      'location': location,
      'priceRange': _currentRangeValues,
    };

    // Prefer location as searchTerm when present, else program name.
    if (location.isNotEmpty) {
      result['searchTerm'] = location;
    } else if ((_selectedProgram ?? '').isNotEmpty) {
      result['searchTerm'] = _selectedProgram;
    }

    Get.back(result: result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: AppStrings.filter,
          fontsize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Program',
                fontWeight: FontWeight.w500,
                fontsize: 13.sp,
                bottom: 8.h,
              ),
              InputDecorator(
                decoration: InputDecoration(
                  fillColor: AppColors.fillColor,
                  filled: true,
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
                    iconDisabledColor: AppColors.primaryColor,
                    iconEnabledColor: AppColors.primaryColor,
                    icon: SvgPicture.asset(
                      AppIcons.down_ArrowIcon,
                      color: AppColors.primaryColor,
                      height: 8.h,
                    ),
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
                      setState(() => _selectedProgram = newValue);
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              CustomText(
                text: 'Type',
                fontWeight: FontWeight.w500,
                fontsize: 13.sp,
                bottom: 8.h,
              ),
              InputDecorator(
                decoration: InputDecoration(
                  fillColor: AppColors.fillColor,
                  filled: true,
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
                    iconDisabledColor: AppColors.primaryColor,
                    iconEnabledColor: AppColors.primaryColor,
                    icon: SvgPicture.asset(
                      AppIcons.down_ArrowIcon,
                      color: AppColors.primaryColor,
                      height: 8.h,
                    ),
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
                      setState(() => _selectedType = newValue);
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              CustomText(
                text: AppStrings.location,
                fontWeight: FontWeight.w500,
                fontsize: 13.sp,
                bottom: 8.h,
              ),
              CustomTextField(
                controller: _locationCTRL,
                hintText: 'Type city or place',
                validator: (_) => null,
                onChanged: (_) => setState(() {}),
                sufixicons: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: SvgPicture.asset(
                    AppIcons.locationIcon,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              CustomText(
                text: 'Category/Group',
                fontWeight: FontWeight.w500,
                fontsize: 13.sp,
                bottom: 8.h,
              ),
              InputDecorator(
                decoration: InputDecoration(
                  fillColor: AppColors.fillColor,
                  filled: true,
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
                    iconDisabledColor: AppColors.primaryColor,
                    iconEnabledColor: AppColors.primaryColor,
                    icon: SvgPicture.asset(
                      AppIcons.down_ArrowIcon,
                      color: AppColors.primaryColor,
                      height: 8.h,
                    ),
                    isExpanded: true,
                    value: _selectedCategory,
                    hint: CustomText(
                        text: 'Select Category/Group', fontsize: 14.sp),
                    items: _category.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() => _selectedCategory = newValue);
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'Price Range',
                    fontWeight: FontWeight.w500,
                    fontsize: 13.sp,
                    bottom: 16.h,
                  ),
                  CustomText(
                    text:
                        '\$${_currentRangeValues.start.round()}-\$${_currentRangeValues.end.round()}',
                    fontWeight: FontWeight.w500,
                    fontsize: 16.sp,
                    bottom: 16.h,
                  ),
                ],
              ),
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
                  setState(() => _currentRangeValues = values);
                },
                activeColor: AppColors.primaryColor,
                inactiveColor: Colors.blue.withValues(alpha: 0.2),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${_currentRangeValues.start.round()}',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 8.sp,
                        color: const Color(0xFF20353F),
                      ),
                    ),
                    Text(
                      '\$${_currentRangeValues.end.round()}',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 8.sp,
                        color: const Color(0xFF20353F),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 48.h),
              SafeArea(
                top: false,
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        onTap: _onReset,
                        borderColor: AppColors.buttonColor,
                        text: "Reset",
                        color: AppColors.colorEDF2F4,
                        textColor: Colors.black,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: CustomButton(
                        onTap: _onApply,
                        text: "Apply",
                        textColor: Colors.white,
                        color: AppColors.buttonColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
