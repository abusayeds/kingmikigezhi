import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_text_field.dart';
import 'package:event_sharing/views/screen/AddEvent/controller/addEventController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

class StepTwoForm extends StatefulWidget {
  const StepTwoForm({Key? key}) : super(key: key);

  @override
  State<StepTwoForm> createState() => _StepTwoFormState();
}

class _StepTwoFormState extends State<StepTwoForm> {
  int _activeStepIndex = 1;

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
  final Addeventcontroller addeventcontroller = Get.find<Addeventcontroller>();
  final TextEditingController _typeCTRL = TextEditingController();
  final TextEditingController _startsDateCTRL = TextEditingController();
  final TextEditingController _startsTimeCTRL = TextEditingController();
  final TextEditingController _endsDateCTRL = TextEditingController();
  final TextEditingController _endsTimeCTRL = TextEditingController();


  String? _selectedCompetitionLevel;
  String? _selectedType;
  String? _selectedCost;
  final List<String> competitionLevel = ['One', 'Two', 'Three', 'Four', 'Five'];
  final List<String> type = ['Onsite', 'Online', 'Hybrid'];
  final List<String> cost = ['Has Final Deadline', 'Has Late Fee'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Text('Step 2: Details',
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600)),
          ),
          //organization Name
          Text('Competition Level',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 12.h),
          Container(
            height: AppStyles.standardHeight,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: AppColors.fillColor,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.primaryColor, width: 1.w),
            ),
            child: Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCompetitionLevel,
                dropdownColor: AppColors.fillColor,
                menuWidth: 240.w,
                borderRadius: BorderRadius.circular(8.r),
                hint: Text("Select Competition Level",
                    style: AppStyles.fontSize14(color: AppColors.color414141)),
                icon: SvgPicture.asset(
                  AppIcons.downArrowIcon,
                  width: 16.w,
                  color: AppColors.primaryColor,
                ),
                isExpanded: true,
                items: competitionLevel.map((String value) {
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
          ),
          //type
          //organization Name
          SizedBox(height: 16.h),
          Text('Type', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 12.h),
          Container(
            height: AppStyles.standardHeight,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: AppColors.fillColor,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.primaryColor, width: 1),
            ),
            child: Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedType,
                dropdownColor: AppColors.fillColor,
                menuWidth: 240.w,
                borderRadius: BorderRadius.circular(8.r),
                hint: Text("Select Type",
                    style: AppStyles.fontSize14(color: AppColors.color414141)),
                icon: SvgPicture.asset(
                  AppIcons.downArrowIcon,
                  width: 16.w,
                  color: AppColors.primaryColor,
                ),
                isExpanded: true,
                items: type.map((String value) {
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
          ),
          SizedBox(height: 12.h),
          //registration date
          Text('Registration Open',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomTextField(
                  prifixicon: Container(
                    width: 48.w,
                    height: AppStyles.standardHeight,
                    alignment: Alignment.center,
                    child: IconButton(
                      onPressed: () => _selectDate(context, _startsDateCTRL),
                      icon: Icon(
                        Icons.calendar_today_rounded,
                        color: AppColors.primaryColor,
                        size: 20.w,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(
                        minWidth: 24.w,
                        minHeight: 24.h,
                      ),
                    ),
                  ),
                  controller: _startsDateCTRL,
                  hintText: 'Date',
                  readOnly: true,
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: CustomTextField(
                  prifixicon: Container(
                    width: 48.w,
                    height: AppStyles.standardHeight,
                    alignment: Alignment.center,
                    child: IconButton(
                      onPressed: () => _selectTime(context, _startsTimeCTRL),
                      icon: Icon(
                        Icons.watch_later_rounded,
                        color: AppColors.primaryColor,
                        size: 20.w,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(
                        minWidth: 24.w,
                        minHeight: 24.h,
                      ),
                    ),
                  ),
                  controller: _startsTimeCTRL,
                  hintText: 'Time',
                  readOnly: true,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),
          //============================>> Deadline Date
          Text('Deadline',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),

          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomTextField(
                  prifixicon: Container(
                    width: 48.w,
                    height: AppStyles.standardHeight,
                    alignment: Alignment.center,
                    child: IconButton(
                      onPressed: () => _selectDate(context, _endsDateCTRL),
                      icon: Icon(
                        Icons.calendar_today_rounded,
                        color: AppColors.primaryColor,
                        size: 20.w,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(
                        minWidth: 24.w,
                        minHeight: 24.h,
                      ),
                    ),
                  ),
                  controller: _endsDateCTRL,
                  hintText: 'Date',
                  readOnly: true,
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: CustomTextField(
                  prifixicon: Container(
                    width: 48.w,
                    height: AppStyles.standardHeight,
                    alignment: Alignment.center,
                    child: IconButton(
                      onPressed: () => _selectTime(context, _endsTimeCTRL),
                      icon: Icon(
                        Icons.watch_later_rounded,
                        color: AppColors.primaryColor,
                        size: 20.w,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(
                        minWidth: 24.w,
                        minHeight: 24.h,
                      ),
                    ),
                  ),
                  controller: _endsTimeCTRL,
                  hintText: 'Time',
                  readOnly: true,
                ),
              ),
            ],
          ),
          //=============================Cost
          SizedBox(height: 12.h),
          Text('Cost', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 12.h),
          CustomTextField(
            prifixicon: Container(
              width: 12.w,
              height: AppStyles.standardHeight,
              alignment: Alignment.center,
              child: SizedBox.shrink()
            ),
            controller: costCRTL,
            hintText: '\$',
              height: AppStyles.standardHeight,
              hintTextStyle: AppStyles.fontSize14(color: AppColors.color414141),

          ),

          SizedBox(height: 12.h),
          Container(
            height: AppStyles.standardHeight,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: AppColors.fillColor,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.primaryColor, width: 1),
            ),
            child: Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCost,
                dropdownColor: AppColors.fillColor,
                menuWidth: 240.w,
                borderRadius: BorderRadius.circular(8.r),
                hint: Text("Select Cost",
                    style: AppStyles.fontSize14(color: AppColors.color414141)),
                icon: SvgPicture.asset(
                  AppIcons.downArrowIcon,
                  width: 16.w,
                  color: AppColors.primaryColor,
                ),
                isExpanded: true,
                items: cost.map((String value) {
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
          ),

          //final date
          SizedBox(height: 12.h),
          Text('Final Deadline',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 108.w,
                child: CustomTextField(
                  controller: monthCRTL,
                  hintText: 'Year',
                  hintTextStyle:
                      AppStyles.fontSize14(color: AppColors.color414141),
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
                  hintTextStyle:
                      AppStyles.fontSize14(color: AppColors.color414141),
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
                  hintTextStyle:
                      AppStyles.fontSize14(color: AppColors.color414141),
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
          Text('Late fee',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 12.h),


          CustomTextField(
            prifixicon: Container(
                width: 12.w,
                height: AppStyles.standardHeight,
                alignment: Alignment.center,
                child: SizedBox.shrink()
            ),
            controller: lateFeeCRTL,
            hintText: '\$',
            height: AppStyles.standardHeight,
            hintTextStyle: AppStyles.fontSize14(color: AppColors.color414141),

          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 164.w,
                child: CustomButton(
                  onTap: () {
                    setState(() {
                      // if (_activeStepIndex == 1)
                      //const StepThreeForm();
                      setState(() {
                        if (addeventcontroller.activeStepIndex.value == 1) {
                          addeventcontroller.activeStepIndex.value--;
                          //StepThreeForm();

                        } // In create_event_one.dart, modify the step widgets to pass the activeStepIndex and update function:
                      });
                    });
                  },
                  text: "Back",
                  color: AppColors.colorEDF2F4,
                  textColor: Colors.black,
                  borderColor: AppColors.buttonColor,
                ),
              ),
              Spacer(),
              SizedBox(
                width: 164.w,
                child: CustomButton(
                  onTap: () {
                    setState(() {
                      if (addeventcontroller.activeStepIndex.value == 1) {
                        addeventcontroller.activeStepIndex.value++;
                        //StepThreeForm();

                      } // In create_event_one.dart, modify the step widgets to pass the activeStepIndex and update function:
                    });
                  },
                  text: "Next",
                  borderColor: AppColors.buttonColor,
                  textColor: Colors.white,
                  color: AppColors.buttonColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 25.h),

          // if (_activeStepIndex == 2) const StepThreeForm()
        ],
      ),
    );
  }

}
Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2023),
    lastDate: DateTime(2101),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.buttonColor, // header & OK/Cancel button color
            onPrimary: Colors.white, // text color on header
            onSurface: Colors.black, // body text color
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.buttonColor, // button text color
            ),
          ),
        ),
        child: child!,
      );
    },
  );
  if (picked != null) {
    controller.text = DateFormat('yyyy-MM-dd').format(picked);
  }
}


Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.buttonColor,
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.buttonColor,
            ),
          ),
        ),
        child: child!,
      );
    },
  );
  if (picked != null) {
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
    controller.text = DateFormat('hh:mm a').format(dateTime);
  }
}

