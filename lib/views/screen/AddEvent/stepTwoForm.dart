import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:event_sharing/views/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';


class StepTwoForm extends StatefulWidget {
  const StepTwoForm({Key? key}) : super(key: key);

  @override
  State<StepTwoForm> createState() => _StepTwoFormState();
}

class _StepTwoFormState extends State<StepTwoForm> {
  int _activeStepIndex = 0;

  final TextEditingController competitionLevelCRTL = TextEditingController();
  final TextEditingController typeCRTL = TextEditingController();
  final TextEditingController resgitationOpenDateCRTL = TextEditingController();
  final TextEditingController resgitationOpenTimeCRTL = TextEditingController();
  final TextEditingController deadlineDateCRTL = TextEditingController();
  final TextEditingController deadlineTimeCRTL = TextEditingController();

  final TextEditingController costCRTL = TextEditingController();
  final TextEditingController finalDeadLineCRTL = TextEditingController();
  final TextEditingController monthCRTL = TextEditingController();
  final TextEditingController dayCRTL = TextEditingController();
  final TextEditingController yearCRTL = TextEditingController();
  final TextEditingController lateFeeCRTL = TextEditingController();

  String? _selectedCompetitionLevel;
  String? _selectedType;
  String? _selectedCost;
  final List<String> competitionLevel = ['One', 'Two', 'Three', 'Four', 'Five'];
  final List<String> type = ['Onsite', 'Online', 'Hybrid'];
  final List<String> cost = ['Has Final Deadline', 'Has Late Fee'];


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: CustomText(text: "Step 2: Details",fontsize: 20,fontWeight: FontWeight.w600,),
        ),
        //organization Name
        CustomText(text: 'Competition Level',fontsize: 16,fontWeight: FontWeight.w600,),
        SizedBox(height: 12.h),
        InputDecorator(
          decoration: InputDecoration(
            fillColor: AppColors.colorEDF2F4,
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
              value: _selectedCompetitionLevel,
              hint: CustomText(text: 'Select Competition Level', fontsize: 14.sp),
              items: competitionLevel.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCompetitionLevel = newValue;
                });
              },
            ),
          ),
        ),

        //type
        //organization Name
        SizedBox(height: 16.h),
        CustomText(text: 'Type',fontsize: 16,fontWeight: FontWeight.w600,),
        SizedBox(height: 12.h),
        InputDecorator(
          decoration: InputDecoration(
            fillColor: AppColors.colorEDF2F4,
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
              value: _selectedType,
              hint: CustomText(text: 'Select Type', fontsize: 14.sp),
              items: type.map((String value) {
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
        SizedBox(height: 12.h),
        //registration date
        CustomText(text: 'Registration Open',fontsize: 16,fontWeight: FontWeight.w600,),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomTextField(
                prifixicon: IconButton(onPressed: (){}, icon: Icon(Icons.calendar_today_rounded)),
                controller: resgitationOpenDateCRTL,
                hintText: 'Date',
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
            SizedBox(width: 15.w),
            Expanded(
              child: CustomTextField(
                prifixicon: IconButton(onPressed: (){}, icon: Icon(Icons.watch_later_rounded)),
                controller: resgitationOpenTimeCRTL,
                hintText: 'Time',
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

        SizedBox(height: 12.h),
        //deadline date
        CustomText(text: 'Deadline ',fontsize: 16,fontWeight: FontWeight.w600,),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomTextField(
                prifixicon: IconButton(onPressed: (){}, icon: Icon(Icons.calendar_today_rounded)),
                controller: deadlineDateCRTL,
                hintText: 'Date',
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
            SizedBox(width: 15.w),
            Expanded(
              child: CustomTextField(
                prifixicon: IconButton(onPressed: (){}, icon: Icon(Icons.watch_later_rounded)),
                controller: deadlineTimeCRTL,
                hintText: 'Time',
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
        //cost
        SizedBox(height: 12.h),
        CustomText(text: 'Cost ',fontsize: 16,fontWeight: FontWeight.w600,),
        SizedBox(height: 12.h),
        CustomTextField(
          controller: costCRTL,
          hintText: '\$',
        ),
        SizedBox(height: 12.h),
        InputDecorator(
          decoration: InputDecoration(
            fillColor: AppColors.colorEDF2F4,
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
              value: _selectedCost,
              hint: CustomText(text: 'Select Cost', fontsize: 14.sp),
              items: cost.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCost = newValue;
                });
              },
            ),
          ),
        ),

        //final date
        SizedBox(height: 12.h),
        CustomText(text: 'Final Deadline',fontsize: 16,fontWeight: FontWeight.w600,),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 108.w,
              child: CustomTextField(
                controller: monthCRTL,
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
                controller: dayCRTL,
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
                controller: yearCRTL,
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
        CustomText(text: 'Late fee',fontsize: 16,fontWeight: FontWeight.w600,),
        SizedBox(height: 12.h),
        CustomTextField(
          controller: lateFeeCRTL,
          hintText: '\$',
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 166.w,
              child: CustomButton(
                onTap: () {
                  setState(() {
                    if (_activeStepIndex > 0) {
                      _activeStepIndex--;
                    }
                  });
                },
                text: "Back",
                color: AppColors.fillColor,
                textColor: Colors.black,
              ),
            ),
            SizedBox(
              width: 166.w,
              child: CustomButton(
                onTap: () {
                  setState(() {
                    _activeStepIndex++;
                  });
                },
                text: "Next",
                textColor: Colors.white,
                color: AppColors.buttonColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
      ],
    );
  }
}
