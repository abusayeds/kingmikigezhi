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
import 'package:intl/intl.dart';

class StepTwoForm extends StatefulWidget {
  const StepTwoForm({super.key});

  @override
  State<StepTwoForm> createState() => _StepTwoFormState();
}

class _StepTwoFormState extends State<StepTwoForm> {
  final TextEditingController costCRTL = TextEditingController();
  final TextEditingController yearCRTL = TextEditingController();
  final TextEditingController monthCRTL = TextEditingController();
  final TextEditingController dayCRTL = TextEditingController();
  final TextEditingController lateFeeCRTL = TextEditingController();
  
  final Addeventcontroller addEventController = Get.find<Addeventcontroller>();
  
  final TextEditingController _startsDateCTRL = TextEditingController();
  final TextEditingController _startsTimeCTRL = TextEditingController();
  final TextEditingController _endsDateCTRL = TextEditingController();
  final TextEditingController _endsTimeCTRL = TextEditingController();

  String? _selectedCompetitionLevel;
  String? _selectedType;
  String? _selectedCostOption;
  final List<String> competitionLevel = ['Local-Easy', 'Local-Medium', 'Local-Difficult','Regional-Easy', 'Regional-Medium', 'Regional-Difficult','State-Easy', 'State-Medium', 'State-Difficult','National-Easy', 'National-Medium', 'National-Difficult','International-Easy', 'International-Medium', 'International-Difficult'];
  final List<String> type = ['Onsite', 'Online', 'Hybrid'];
  final List<String> costOptions = ['Has Final Deadline', 'No Final Deadline'];

  @override
  void initState() {
    super.initState();
    // Initialize with existing data if any
    _selectedCompetitionLevel = addEventController.competitionLevel;
    _selectedType = addEventController.eventType;
    _startsDateCTRL.text = addEventController.registrationDate ?? "";
    _startsTimeCTRL.text = addEventController.registrationTime ?? "";
    _endsDateCTRL.text = addEventController.deadlineDate ?? "";
    _endsTimeCTRL.text = addEventController.deadlineTime ?? "";
    costCRTL.text = addEventController.cost?.toString() ?? "";
    yearCRTL.text = addEventController.finalDeadlineYear ?? "";
    monthCRTL.text = addEventController.finalDeadlineMonth ?? "";
    dayCRTL.text = addEventController.finalDeadlineDay ?? "";
    lateFeeCRTL.text = addEventController.lateFee?.toString() ?? "";
    _selectedCostOption = addEventController.hasFinalDeadline ? 'Has Final Deadline' : 'No Final Deadline';
  }

  void _saveDataToController() {
    addEventController.competitionLevel = _selectedCompetitionLevel;
    addEventController.eventType = _selectedType;
    addEventController.registrationDate = _startsDateCTRL.text;
    addEventController.registrationTime = _startsTimeCTRL.text;
    addEventController.deadlineDate = _endsDateCTRL.text;
    addEventController.deadlineTime = _endsTimeCTRL.text;
    addEventController.cost = double.tryParse(costCRTL.text);
    addEventController.hasFinalDeadline = _selectedCostOption == 'Has Final Deadline';
    addEventController.finalDeadlineYear = yearCRTL.text;
    addEventController.finalDeadlineMonth = monthCRTL.text;
    addEventController.finalDeadlineDay = dayCRTL.text;
    addEventController.lateFee = double.tryParse(lateFeeCRTL.text);
  }

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
          Text('Competition Level',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 12.h),
          _buildDropdown(
            value: _selectedCompetitionLevel,
            hint: "Select Competition Level",
            items: competitionLevel,
            onChanged: (v) => setState(() => _selectedCompetitionLevel = v),
          ),
          SizedBox(height: 16.h),
          Text('Type', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 12.h),
          _buildDropdown(
            value: _selectedType,
            hint: "Select Type",
            items: type,
            onChanged: (v) => setState(() => _selectedType = v),
          ),
          SizedBox(height: 12.h),
          Text('Registration Open',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomTextField(
                  prifixicon: IconButton(
                    onPressed: () => _selectDate(context, _startsDateCTRL),
                    icon: Icon(Icons.calendar_today_rounded, color: AppColors.primaryColor, size: 20.w),
                  ),
                  controller: _startsDateCTRL,
                  hintText: 'Date',
                  readOnly: true,
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: CustomTextField(
                  prifixicon: IconButton(
                    onPressed: () => _selectTime(context, _startsTimeCTRL),
                    icon: Icon(Icons.watch_later_rounded, color: AppColors.primaryColor, size: 20.w),
                  ),
                  controller: _startsTimeCTRL,
                  hintText: 'Time',
                  readOnly: true,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),
          Text('Deadline',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),

          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomTextField(
                  prifixicon: IconButton(
                    onPressed: () => _selectDate(context, _endsDateCTRL),
                    icon: Icon(Icons.calendar_today_rounded, color: AppColors.primaryColor, size: 20.w),
                  ),
                  controller: _endsDateCTRL,
                  hintText: 'Date',
                  readOnly: true,
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: CustomTextField(
                  prifixicon: IconButton(
                    onPressed: () => _selectTime(context, _endsTimeCTRL),
                    icon: Icon(Icons.watch_later_rounded, color: AppColors.primaryColor, size: 20.w),
                  ),
                  controller: _endsTimeCTRL,
                  hintText: 'Time',
                  readOnly: true,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text('Cost', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 12.h),
          CustomTextField(
            controller: costCRTL,
            hintText: '\$',
            height: AppStyles.standardHeight,
            keyboardType: TextInputType.number,
            hintTextStyle: AppStyles.fontSize14(color: AppColors.color414141),
          ),

          SizedBox(height: 12.h),
          _buildDropdown(
            value: _selectedCostOption,
            hint: "Has Final Round?",
            items: costOptions,
            onChanged: (v) => setState(() => _selectedCostOption = v),
          ),

          if (_selectedCostOption == 'Yes') ...[
            SizedBox(height: 12.h),
            Text('Final Deadline',
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 108.w, child: CustomTextField(controller: yearCRTL, hintText: 'Year')),
                SizedBox(width: 108.w, child: CustomTextField(controller: monthCRTL, hintText: 'Month')),
                SizedBox(width: 108.w, child: CustomTextField(controller: dayCRTL, hintText: 'Day')),
              ],
            ),
            SizedBox(height: 16.h),
            Text('No',
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 12.h),
            CustomTextField(
              controller: lateFeeCRTL,
              hintText: '\$',
              height: AppStyles.standardHeight,
              keyboardType: TextInputType.number,
            ),
          ],
          
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 164.w,
                child: CustomButton(
                  onTap: () {
                    if (addEventController.activeStepIndex.value > 0) {
                      addEventController.activeStepIndex.value--;
                    }
                  },
                  text: "Back",
                  color: AppColors.colorEDF2F4,
                  textColor: Colors.black,
                  borderColor: AppColors.buttonColor,
                ),
              ),
              SizedBox(
                width: 164.w,
                child: CustomButton(
                  onTap: () {
                    _saveDataToController();
                    if (addEventController.activeStepIndex.value < 4) {
                      addEventController.activeStepIndex.value++;
                    }
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
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
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
            value: value,
            dropdownColor: AppColors.fillColor,
            borderRadius: BorderRadius.circular(8.r),
            hint: Text(hint, style: AppStyles.fontSize14(color: AppColors.color414141)),
            icon: SvgPicture.asset(AppIcons.downArrowIcon, width: 16.w, color: AppColors.primaryColor),
            isExpanded: true,
            items: items.map((String v) => DropdownMenuItem(value: v, child: Text(v, style: const TextStyle(color: Colors.black)))).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final now = DateTime.now();
      final dateTime = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      controller.text = DateFormat('hh:mm a').format(dateTime);
    }
  }
}
