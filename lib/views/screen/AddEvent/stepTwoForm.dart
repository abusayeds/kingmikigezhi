import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/utils/style.dart';
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
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child:
          Text('Step 2: Details',style: AppStyles.fontSize20(fontWeight: FontWeight.bold)),
        ),
        //organization Name
        Text('Competition Level',style: AppStyles.fontSize16(fontWeight: FontWeight.bold)),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            color: AppColors.fillColor,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.primaryColor, width: 1.w),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCompetitionLevel,
              dropdownColor: AppColors.fillColor,
              menuWidth: 240.w,
              borderRadius: BorderRadius.circular(8.r),
              hint: Text("Select Competition Level", style: AppStyles.fontSize14(color: AppColors.color414141)),
              icon: SvgPicture.asset(AppIcons.downArrowIcon, width: 16.w, color: AppColors.primaryColor,
              ),
              isExpanded: true,
              items:competitionLevel.map((String value) {
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
                  _selectedCompetitionLevel = newValue;
                });
              },
            ),
          ),
        ),
        //type
        //organization Name
        SizedBox(height: 16.h),
        Text('Type',style: AppStyles.fontSize16(fontWeight: FontWeight.bold)),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            color: AppColors.fillColor,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.primaryColor, width: 1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedType,
              dropdownColor: AppColors.fillColor,
              menuWidth: 240.w,
              borderRadius: BorderRadius.circular(8.r),
              hint: Text("Select Type",  style: AppStyles.fontSize14(color: AppColors.color414141)),
              icon: SvgPicture.asset(AppIcons.downArrowIcon, width: 16.w, color: AppColors.primaryColor,
              ),
              isExpanded: true,
              items:type.map((String value) {
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
                  _selectedType = newValue;
                });
              },
            ),
          ),
        ),
        SizedBox(height: 12.h),
        //registration date
        Text('Registration Open',style: AppStyles.fontSize16(fontWeight: FontWeight.bold)),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomTextField(
                prifixicon: IconButton(onPressed: (){}, icon: Icon(Icons.calendar_today_rounded)),
                controller: resgitationOpenDateCRTL,
                hintText: 'Date',
                hintTextStyle: AppStyles.fontSize14(color: AppColors.color414141),
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
                hintTextStyle: AppStyles.fontSize14(color: AppColors.color414141),
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
        //============================>> Deadline Date
        Text('Deadline',style: AppStyles.fontSize16(fontWeight: FontWeight.bold)),

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
        //=============================Cost
        SizedBox(height: 12.h),
        Text('Cost',style: AppStyles.fontSize16(fontWeight: FontWeight.bold)),
        SizedBox(height: 12.h),
        CustomTextField(
          controller: costCRTL,
          hintText: '\$',
          hintTextStyle: AppStyles.fontSize14(color: AppColors.color414141),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            color: AppColors.fillColor,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.primaryColor, width: 1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCost,
              dropdownColor: AppColors.fillColor,
              menuWidth: 240.w,
              borderRadius: BorderRadius.circular(8.r),
              hint: Text("Select Cost", style: AppStyles.fontSize14(color: AppColors.color414141)),
              icon: SvgPicture.asset(AppIcons.downArrowIcon, width: 16.w, color: AppColors.primaryColor,
              ),
              isExpanded: true,
              items:cost.map((String value) {
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
                  _selectedCost = newValue;
                });
              },
            ),
          ),
        ),

        //final date
        SizedBox(height: 12.h),
        Text('Final Deadline',style: AppStyles.fontSize16(fontWeight: FontWeight.bold)),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 108.w,
              child: CustomTextField(
                controller: monthCRTL,
                hintText: 'Year',
                hintTextStyle: AppStyles.fontSize14(color: AppColors.color414141),
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
                hintTextStyle: AppStyles.fontSize14(color: AppColors.color414141),
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
                hintTextStyle: AppStyles.fontSize14(color: AppColors.color414141),
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
        Text('Late fee',style: AppStyles.fontSize16(fontWeight: FontWeight.bold)),
        SizedBox(height: 12.h),
        CustomTextField(
          controller: lateFeeCRTL,
          hintText: '\$',
          hintTextStyle: AppStyles.fontSize14(color: AppColors.color414141),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomButton(
                onTap: () {
                  setState(() {
                    if (_activeStepIndex > 0) {
                      _activeStepIndex--;
                    }
                  });
                },
                text: "Back",
                color: AppColors.colorEDF2F4,
                textColor: Colors.black,
                borderColor: AppColors.buttonColor,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: CustomButton(
                onTap: () {
                  setState(() {
                    _activeStepIndex++;
                  });
                },
                text: "Next",
                textColor: Colors.white,
                color: AppColors.buttonColor,
                borderColor: AppColors.buttonColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
      ],
    );
  }
}
