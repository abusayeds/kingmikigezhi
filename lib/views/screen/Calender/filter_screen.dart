import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_strings.dart';
import '../../base/custom_text.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final TextEditingController _categoriesCTRL = TextEditingController();
  final TextEditingController _locationCTRL = TextEditingController();
  final List<String> _categories = ['Concert', 'Sports', 'Show', 'Olympic game'];
  RangeValues _currentRangeValues = RangeValues(20, 80);
  String? _selectedCategory;

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
          centerTitle: true),
      //=======================> Body Section <============================
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //==============================> Categories Section <=======================
            CustomText(
              text: AppStrings.categories,
              fontWeight: FontWeight.w500,
              fontsize: 16.sp,
              bottom: 8.h,
            ),
            InputDecorator(
              decoration: InputDecoration(
                fillColor: AppColors.fillColor,
               // labelText: 'Select',
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
                  //focusColor:  AppColors.primaryColor,
                  iconDisabledColor: AppColors.primaryColor,
                  iconEnabledColor: AppColors.primaryColor,
                  isExpanded: true,
                  value: _selectedCategory,
                  hint: CustomText(text: 'Select',fontsize: 14.sp),
                  items: _categories.map((String value) {
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
            //==============================> Location Section <=======================
            CustomText(
              text: AppStrings.location,
              fontWeight: FontWeight.w500,
              fontsize: 16.sp,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'Price Range',
                  fontWeight: FontWeight.w500,
                  fontsize: 16.sp,
                  bottom: 16.h,
                ),
                CustomText(
                  text: '\$20-\$4K',
                  fontWeight: FontWeight.w500,
                  fontsize: 16.sp,
                  bottom: 16.h,
                ),
              ],
            ),
            //================================> Range Slider Section <================================
            RangeSlider(
              values: _currentRangeValues,
              min: 20,
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
                  CustomText(text: '\$${_currentRangeValues.start.round()}'),
                  CustomText(text: '\$${_currentRangeValues.end.round()}'),
                ],
              ),
            ),
            const Spacer(),
            //===========================> Button Section <===============================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    width: 166.w,
                    child: CustomButton(
                      onTap: () {},
                      text: "Reset",
                      color: Colors.white,
                      textColor: Colors.black,
                    )),
                SizedBox(
                    width: 166.w,
                    child: CustomButton(
                      onTap: () {},
                      text: "Apply Filters",
                      textColor: Colors.white,
                    )),
              ],
            ),
            SizedBox(height: 75.h),
          ],
        ),
      ),
    );
  }
}
