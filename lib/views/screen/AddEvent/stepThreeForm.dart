import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_text_field.dart';
import 'package:event_sharing/views/screen/AddEvent/InnerWidget/dotted_border_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import 'controller/addEventController.dart';

class StepThreeForm extends StatefulWidget {
  const StepThreeForm({super.key});

  @override
  State<StepThreeForm> createState() => _StepThreeFormState();
}

class _StepThreeFormState extends State<StepThreeForm> {
  // Enums for Backend
  final List<String> groupCriteriaList = ['Age', 'Score'];
  final List<String> conditionList = ['UpTo', 'DownTo', 'Greater', 'GreaterAndEqual', 'Lower', 'LowerAndEqual'];
  final List<String> roundTypeList = ['Preliminary', 'SemiFinal', 'Final'];
  final List<String> yesNoList = ['Yes', 'No'];

  // Controllers for Group
  final TextEditingController groupValueController = TextEditingController();

  // Controllers for Round
  final TextEditingController roundDateController = TextEditingController();
  final TextEditingController roundTimeController = TextEditingController();
  final TextEditingController roundCostController = TextEditingController();
  final TextEditingController roundLateFeeController = TextEditingController();
  final TextEditingController roundDescriptionController = TextEditingController();
  final TextEditingController rFinalYearController = TextEditingController();
  final TextEditingController rFinalMonthController = TextEditingController();
  final TextEditingController rFinalDayController = TextEditingController();

  final Addeventcontroller addeventcontroller = Get.find<Addeventcontroller>();

  String? _selectedCriteria;
  String? _selectedCondition;
  String? _selectedRoundType;
  String? _selectedHasFinalDeadline;

  @override
  void initState() {
    super.initState();
    // DO NOT clear tempRounds here — IndexedStack keeps this widget alive,
    // so initState is only called once when the screen first loads.
    // Clearing here would wipe rounds only on first load, not on re-entry.
  }

  void _saveDataToController() {
    // If the user added rounds but never pressed "Add" on the group,
    // auto-save them into a group so data isn't lost on Next.
    if (addeventcontroller.tempRounds.isNotEmpty) {
      final criteria = _selectedCriteria ?? 'Age';
      final condition = _selectedCondition ?? 'UpTo';
      final value = int.tryParse(groupValueController.text) ?? 100;
      String generatedName = "$criteria $condition $value";
      if (criteria == 'Age') {
        generatedName += " years old";
      }

      // Deep-copy before clearing
      final snapshotRounds = addeventcontroller.tempRounds
          .map((r) => Map<String, dynamic>.from(r))
          .toList();

      addeventcontroller.addGroup(
        generatedName,
        criteria,
        condition,
        value,
        snapshotRounds,
      );
      addeventcontroller.clearTempRounds();
      groupValueController.clear();
      setState(() {
        _selectedCriteria = null;
        _selectedCondition = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text('Step 3: Group',
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600)),
              ),
              SizedBox(height: 12.h),
              Text('Define Group',
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildDropdown(
                      value: _selectedCriteria,
                      hint: 'Criteria',
                      items: groupCriteriaList,
                      onChanged: (v) => setState(() => _selectedCriteria = v),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: _buildDropdown(
                      value: _selectedCondition,
                      hint: 'Condition',
                      items: conditionList,
                      onChanged: (v) => setState(() => _selectedCondition = v),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: groupValueController,
                      hintText: 'Value (e.g. 18)',
                      keyboardType: TextInputType.number,
                      hintTextStyle: AppStyles.fontSize14(color: AppColors.color414141),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  SizedBox(
                    width: 90.w,
                    child: CustomButton(
                      height: 48.5,
                      width: 90.w,
                      color: AppColors.buttonA47059,
                      borderColor: Colors.transparent,
                      onTap: () {
                        if (_selectedCriteria == null || _selectedCondition == null || groupValueController.text.isEmpty) {
                          Get.snackbar("Error", "Please fill all group details");
                          return;
                        }
                        if (addeventcontroller.tempRounds.isEmpty) {
                          Get.snackbar("Error", "Please add at least one round to the group");
                          return;
                        }

                        // Auto-generate name
                        String generatedName = "$_selectedCriteria $_selectedCondition ${groupValueController.text}";
                        if (_selectedCriteria == 'Age') {
                          generatedName += " years old";
                        }

                        // Snapshot the rounds NOW (deep copy) before anything is cleared
                        final snapshotRounds = addeventcontroller.tempRounds
                            .map((r) => Map<String, dynamic>.from(r))
                            .toList();

                        addeventcontroller.addGroup(
                          generatedName,
                          _selectedCriteria!,
                          _selectedCondition!,
                          int.parse(groupValueController.text),
                          snapshotRounds,
                        );

                        // Clear temp state AFTER group is safely stored
                        addeventcontroller.clearTempRounds();
                        groupValueController.clear();
                        setState(() {
                          _selectedCriteria = null;
                          _selectedCondition = null;
                        });
                      },
                      text: 'Add',
                      textColor: AppColors.textColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text('Added Groups',
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              SizedBox(height: 8.h),
              Obx(() => Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.colorEDF2F4,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: AppColors.primaryColor, width: 1),
                ),
                child: addeventcontroller.groups.isEmpty 
                  ? const Padding(padding: EdgeInsets.all(16), child: Text("No groups added yet"))
                  : Column(
                      children: addeventcontroller.groups.asMap().entries.map((entry) {
                        int idx = entry.key;
                        var group = entry.value;
                        var rounds = (group['rounds'] as List<dynamic>?) ?? [];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text("${group['name']}"),
                              subtitle: Text("${group['criteria']} ${group['condition']} ${group['value']}"),
                              trailing: IconButton(
                                icon: SvgPicture.asset(AppIcons.trashIcon),
                                onPressed: () => addeventcontroller.removeGroup(idx),
                              ),
                            ),
                            if (rounds.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 8.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: rounds.asMap().entries.map((roundEntry) {
                                    int roundIdx = roundEntry.key;
                                    var round = roundEntry.value;
                                    return Padding(
                                      padding: EdgeInsets.symmetric(vertical: 4.h),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "${round['roundType']} - ${_formatDeadline(round['deadline'])} - \$${round['cost'] ?? 0}",
                                              style: TextStyle(fontSize: 12.sp),
                                            ),
                                          ),
                                          IconButton(
                                            icon: SvgPicture.asset(AppIcons.trashIcon, width: 14.w),
                                            onPressed: () => addeventcontroller.removeRoundFromGroup(idx, roundIdx),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                          ],
                        );
                      }).toList(),
                    ),
              )),
              SizedBox(height: 10.h),

              // ── Define Round ──
              DottedBorderContainer(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Define Round for Group',
                          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                      SizedBox(height: 8.h),

                      _buildDropdown(
                        value: _selectedRoundType,
                        hint: 'Select Round Type',
                        items: roundTypeList,
                        onChanged: (v) => setState(() => _selectedRoundType = v),
                      ),
                      SizedBox(height: 12.h),

                      Text("Deadline",
                          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CustomTextField(
                              height: 44.h,
                              prifixicon: IconButton(
                                  onPressed: () => _selectDate(context, roundDateController),
                                  icon: Icon(Icons.calendar_today_rounded, size: 20.sp)),
                              controller: roundDateController,
                              hintText: 'Date',
                              readOnly: true,
                            ),
                          ),
                          SizedBox(width: 15.w),
                          Expanded(
                            child: CustomTextField(
                              height: 44.h,
                              prifixicon: IconButton(
                                  onPressed: () => _selectTime(context, roundTimeController),
                                  icon: const Icon(Icons.watch_later_rounded)),
                              controller: roundTimeController,
                              hintText: 'Time',
                              readOnly: true,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 12.h),
                      Text("Cost",
                          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                      SizedBox(height: 8.h),
                      CustomTextField(
                        controller: roundCostController,
                        hintText: '\$',
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 12.h),
                      _buildDropdown(
                        value: _selectedHasFinalDeadline,
                        hint: 'Has Final Round?',
                        items: yesNoList,
                        onChanged: (v) => setState(() => _selectedHasFinalDeadline = v),
                      ),

                      if (_selectedHasFinalDeadline == 'Yes') ...[
                        SizedBox(height: 12.h),
                        Text("Final Deadline",
                            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                        SizedBox(height: 8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 108.w, child: CustomTextField(height: 44.h, controller: rFinalYearController, hintText: 'Year')),
                            SizedBox(width: 108.w, child: CustomTextField(height: 44.h, controller: rFinalMonthController, hintText: 'Month')),
                            SizedBox(width: 108.w, child: CustomTextField(height: 44.h, controller: rFinalDayController, hintText: 'Day')),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Text("Late fee",
                            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                        SizedBox(height: 8.h),
                        CustomTextField(
                          controller: roundLateFeeController,
                          hintText: '\$',
                          keyboardType: TextInputType.number,
                        ),
                      ],

                      SizedBox(height: 12.h),
                      Text("Description",
                          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                      SizedBox(height: 8.h),
                      CustomTextField(
                        controller: roundDescriptionController,
                        hintText: 'Round Description...',
                      ),

                      SizedBox(height: 16.h),
                      CustomButton(
                        color: AppColors.buttonA47059,
                        borderColor: Colors.white,
                        onTap: () {
                          if (_selectedRoundType == null || roundDateController.text.isEmpty) {
                            Get.snackbar("Error", "Round type and deadline are required");
                            return;
                          }
                          addeventcontroller.addTempRound(
                            roundType: _selectedRoundType!,
                            date: roundDateController.text,
                            time: roundTimeController.text,
                            cost: double.tryParse(roundCostController.text) ?? 0,
                            hasFinalDeadline: _selectedHasFinalDeadline == 'Yes',
                            fYear: rFinalYearController.text,
                            fMonth: rFinalMonthController.text,
                            fDay: rFinalDayController.text,
                            lateFee: double.tryParse(roundLateFeeController.text) ?? 0,
                            description: roundDescriptionController.text,
                          );
                          // Reset round fields
                          roundDateController.clear();
                          roundTimeController.clear();
                          roundCostController.clear();
                          roundLateFeeController.clear();
                          roundDescriptionController.clear();
                          rFinalYearController.clear();
                          rFinalMonthController.clear();
                          rFinalDayController.clear();
                          setState(() {
                            _selectedRoundType = null;
                            _selectedHasFinalDeadline = null;
                          });
                        },
                        text: "Add Round to Group",
                        textColor: Colors.white,
                      ),
                      SizedBox(height: 10.h),
                      Text("Rounds added to current group:",
                          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                      SizedBox(height: 8.h),
                      Obx(() => Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: addeventcontroller.tempRounds.isEmpty 
                          ? const Text("No rounds added")
                          : Column(
                              children: addeventcontroller.tempRounds.map((r) => Text("• ${r['roundType']} - ${_formatDeadline(r['deadline'])}")).toList(),
                            ),
                      )),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onTap: () {
                        if (addeventcontroller.activeStepIndex.value > 0) {
                          addeventcontroller.activeStepIndex.value--;
                        }
                      },
                      text: "Back",
                      color: AppColors.fillColor,
                      textColor: Colors.black,
                      borderColor: AppColors.buttonColor,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: CustomButton(
                      onTap: () {
                        _saveDataToController();
                        if (addeventcontroller.activeStepIndex.value < 4) {
                          addeventcontroller.activeStepIndex.value++;
                        }
                      },
                      text: "Next",
                      textColor: Colors.white,
                      borderColor: AppColors.buttonColor,
                      color: AppColors.buttonColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25.h),
            ],
          ),
        )
      ]),
    );
  }

  // Show "2026-09-01T11:53" instead of "2026-09-01T11:53:00.000Z"
  String _formatDeadline(dynamic deadline) {
    final raw = deadline?.toString() ?? '';
    if (raw.isEmpty) return 'No deadline';
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return raw;
    return DateFormat("yyyy-MM-dd'T'HH:mm").format(parsed);
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: AppColors.fillColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.primaryColor, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: AppColors.fillColor,
          borderRadius: BorderRadius.circular(8.r),
          hint: Text(hint, style: AppStyles.fontSize14(color: AppColors.color414141)),
          icon: SvgPicture.asset(AppIcons.downArrowIcon, width: 16.w, color: AppColors.primaryColor),
          isExpanded: true,
          items: items
              .map((v) => DropdownMenuItem(value: v, child: Text(v, style: const TextStyle(color: Colors.black))))
              .toList(),
          onChanged: onChanged,
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
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
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
      setState(() {
        controller.text = DateFormat('hh:mm a').format(dateTime);
      });
    }
  }
}
