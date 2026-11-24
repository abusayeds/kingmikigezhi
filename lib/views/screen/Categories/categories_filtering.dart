import 'package:event_sharing/models/event_model.dart';
import 'package:event_sharing/services/api_service.dart';
import 'package:event_sharing/utils/api_constants.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/utils/app_strings.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:event_sharing/views/base/custom_text_field.dart';
import 'package:event_sharing/views/base/dropdown_field_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoriesFilterScreen extends StatefulWidget {
  const CategoriesFilterScreen({super.key});

  @override
  State<CategoriesFilterScreen> createState() => _CategoriesFilterScreenState();
}

class _CategoriesFilterScreenState extends State<CategoriesFilterScreen> {
  final TextEditingController _locationCTRL = TextEditingController();
  final List<String> _type = ['Onsite', 'Online', 'Hybrid'];
  final List<String> _category = ['6 Year - 10 Year', '11 Year - 16 Year', '17 Year+'];
  List<Program> _apiPrograms = [];
  bool _isLoadingPrograms = true;

  RangeValues _currentRangeValues = const RangeValues(50, 4000);
  Program? _selectedProgram;
  String? _selectedType;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _fetchPrograms();
  }

  Future<void> _fetchPrograms() async {
    try {
      final apiService = Get.find<ApiService>();
      final List<Program> allPrograms = [];
      int page = 1;
      bool hasNext = true;

      while (hasNext) {
        final response =
            await apiService.get("${ApiConstants.programs}?page=$page&limit=50");
        if (response['success'] == true) {
          final List<dynamic> data = response['data'] ?? [];
          allPrograms.addAll(data.map((json) => Program.fromJson(json)));
          hasNext = response['meta']?['hasNext'] == true;
          page++;
        } else {
          hasNext = false;
        }
      }

      if (!mounted) return;
      setState(() {
        _apiPrograms = allPrograms;
        _isLoadingPrograms = false;
      });
    } catch (e) {
      debugPrint("Error fetching programs: $e");
      if (!mounted) return;
      setState(() => _isLoadingPrograms = false);
    }
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      //=======================> App Bar Section <============================
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        elevation: 0,
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
            Expanded(
              child: Align(
                alignment: Alignment.center, // Center the text
                child: CustomText(
                  text: AppStrings.filter,
                  fontsize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
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
                child: Row(
                  children: [
                    if (_isLoadingPrograms) ...[
                      const DropdownFieldLoader(),
                      SizedBox(width: 8.w),
                    ],
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Program>(
                          padding: EdgeInsets.symmetric(vertical: 5.w),
                          iconDisabledColor: AppColors.primaryColor,
                          icon: SvgPicture.asset(
                            AppIcons.down_ArrowIcon,
                            color: AppColors.primaryColor,
                            height: 8.h,
                          ),
                          iconEnabledColor: AppColors.primaryColor,
                          isExpanded: true,
                          value: _selectedProgram,
                          hint: CustomText(
                            text: _isLoadingPrograms
                                ? 'Loading programs...'
                                : 'Select Program',
                            fontsize: 14.sp,
                          ),
                          items: _apiPrograms.map((Program value) {
                            return DropdownMenuItem<Program>(
                              value: value,
                              child: Text(value.name ?? 'Unknown'),
                            );
                          }).toList(),
                          onChanged:
                              _isLoadingPrograms && _apiPrograms.isEmpty
                                  ? null
                                  : (Program? newValue) {
                                      setState(() {
                                        _selectedProgram = newValue;
                                      });
                                    },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              //==============================> Type Section <=======================
              CustomText(
                text: 'Type',
                fontWeight: FontWeight.w500,
                fontsize: 13.sp,
                bottom: 8.h,
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
                    padding: EdgeInsets.symmetric(vertical: 5.w),

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
                keyboardType: TextInputType.text,
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
              //==============================> Category/Group Section <=======================
              CustomText(
                text: 'Category/Group',
                fontWeight: FontWeight.w500,
                fontsize: 13.sp,
                bottom: 8.h,
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
                    padding: EdgeInsets.symmetric(vertical: 5.w),

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
              //===========================> Button Section <===============================
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
    final result = <String, dynamic>{
      'program': _selectedProgram?.id,
      'type': _selectedType,
      'category': _mapCategoryGroup(_selectedCategory),
      'location': location,
      'priceRange': _currentRangeValues,
      if (location.isNotEmpty) 'searchTerm': location,
    };

    final hasAny = (_selectedProgram?.id?.toString().isNotEmpty ?? false) ||
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

    Get.back(result: result);
  }

  @override
  void dispose() {
    _locationCTRL.dispose();
    super.dispose();
  }
}
