import 'package:event_sharing/controllers/contribution_controller.dart';
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

class ContributionFilterScreen extends StatefulWidget {
  const ContributionFilterScreen({super.key});

  @override
  State<ContributionFilterScreen> createState() =>
      _ContributionFilterScreenState();
}

class _ContributionFilterScreenState extends State<ContributionFilterScreen> {
  final ContributionController _controller =
      Get.find<ContributionController>();

  final TextEditingController _locationCTRL = TextEditingController();

  // Selected values (value field from API)
  String? _selectedProgramId;
  String? _selectedType;
  String? _selectedCategory;
  String? _selectedTimeRange;

  @override
  void initState() {
    super.initState();
    // Restore previously selected values
    _selectedProgramId = _controller.selectedProgramId.value.isEmpty
        ? null
        : _controller.selectedProgramId.value;
    _selectedType = _controller.selectedType.value.isEmpty
        ? null
        : _controller.selectedType.value;
    _selectedCategory = _controller.selectedCategoryGroup.value.isEmpty
        ? null
        : _controller.selectedCategoryGroup.value;
    _selectedTimeRange = _controller.selectedTimeRange.value.isEmpty
        ? null
        : _controller.selectedTimeRange.value;
    _locationCTRL.text = _controller.selectedLocation.value;

    // Fetch filter options if not already loaded
    if (_controller.filterOptions.value == null) {
      _controller.fetchFilterOptions();
    }
  }

  @override
  void dispose() {
    _locationCTRL.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //=======================> App Bar Section <============================
      appBar: AppBar(
        title: CustomText(
          text: AppStrings.filter,
          fontsize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
        centerTitle: true,
      ),
      //=======================> Body Section <============================
      body: Obx(() {
        if (_controller.isLoadingFilters.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final options = _controller.filterOptions.value;

        final programs = options?.programs ?? [];
        final types = options?.types ?? [];
        final categories = options?.categoryGroups ?? [];
        final timeRanges = options?.timeRanges ?? [];

        return SingleChildScrollView(
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
                _buildDropdown(
                  hint: 'Select Program',
                  value: _selectedProgramId,
                  items: programs
                      .map((e) => DropdownMenuItem<String>(
                            value: e.value,
                            child: Text(e.label),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedProgramId = v),
                ),
                SizedBox(height: 16.h),

                //==============================> Type Section <=======================
                CustomText(
                  text: 'Type',
                  fontWeight: FontWeight.w500,
                  fontsize: 13.sp,
                  bottom: 8.h,
                ),
                _buildDropdown(
                  hint: 'Select Type',
                  value: _selectedType,
                  items: types
                      .map((e) => DropdownMenuItem<String>(
                            value: e.value,
                            child: Text(e.label),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedType = v),
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
                  hintText: 'Type here',
                  sufixicons: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: SvgPicture.asset(AppIcons.locationIcon,
                        color: AppColors.primaryColor),
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
                _buildDropdown(
                  hint: 'Select Category/Group',
                  value: _selectedCategory,
                  items: categories
                      .map((e) => DropdownMenuItem<String>(
                            value: e.value,
                            child: Text(e.label),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedCategory = v),
                ),
                SizedBox(height: 16.h),

                //==============================> Time Range Section <=======================
                CustomText(
                  text: 'Time Range',
                  fontWeight: FontWeight.w500,
                  fontsize: 13.sp,
                  bottom: 8.h,
                ),
                _buildDropdown(
                  hint: 'Select Time Range',
                  value: _selectedTimeRange,
                  items: timeRanges
                      .map((e) => DropdownMenuItem<String>(
                            value: e.value,
                            child: Text(e.label),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedTimeRange = v),
                ),
                SizedBox(height: 131.h),

                //===========================> Button Section <===============================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomButton(
                        onTap: () {
                          setState(() {
                            _selectedProgramId = null;
                            _selectedType = null;
                            _selectedCategory = null;
                            _selectedTimeRange = null;
                            _locationCTRL.clear();
                          });
                          // Return reset signal to contribution screen
                          Get.back(result: <String, dynamic>{});
                        },
                        text: "Reset",
                        color: AppColors.colorEDF2F4,
                        textColor: Colors.black,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: CustomButton(
                        onTap: () {
                          // Return filter values to contribution screen
                          Get.back(result: <String, dynamic>{
                            'programId': _selectedProgramId ?? '',
                            'type': _selectedType ?? '',
                            'location': _locationCTRL.text.trim(),
                            'categoryGroup': _selectedCategory ?? '',
                            'timeRange': _selectedTimeRange ?? '',
                          });
                        },
                        text: "Apply",
                        textColor: Colors.white,
                        color: AppColors.buttonColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        fillColor: AppColors.fillColor,
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
          iconDisabledColor: AppColors.primaryColor,
          iconEnabledColor: AppColors.primaryColor,
          isExpanded: true,
          value: value,
          hint: CustomText(text: hint, fontsize: 14.sp),
          items: items,
          onChanged: items.isNotEmpty ? onChanged : null,
        ),
      ),
    );
  }
}
