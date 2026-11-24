import 'package:event_sharing/helpers/app_feedback.dart';
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

/// One entry in the "Criteria" dropdown: a criteria type plus, for banded
/// criteria, the preset label that goes with it.
class _CriteriaOption {
  /// API `GroupCriteria` value: Default | Age | UTR | Level | Class.
  final String criteria;

  /// Preset band label, e.g. "6-12", "1.0-4.0", "Class A". Null for Default.
  final String? label;

  /// Numeric bounds, set for Age bands so age filtering keeps working.
  final int? min;
  final int? max;

  const _CriteriaOption(this.criteria, this.label, {this.min, this.max});

  /// Stable id used as the DropdownMenuItem value.
  String get id => label == null ? criteria : '$criteria|$label';

  String get display => label == null ? criteria : '$criteria  $label';

  bool get isLabelBased =>
      criteria == 'UTR' || criteria == 'Level' || criteria == 'Class';

  bool get isAge => criteria == 'Age';

  bool get isDefault => criteria == 'Default';
}

class _StepThreeFormState extends State<StepThreeForm> {
  /// Criteria presets, exactly as specified by the client.
  static const List<_CriteriaOption> _criteriaOptions = [
    _CriteriaOption('Default', null),

    _CriteriaOption('Age', '6-12', min: 6, max: 12),
    _CriteriaOption('Age', '13-19', min: 13, max: 19),
    _CriteriaOption('Age', '20+', min: 20, max: 120),

    _CriteriaOption('UTR', '1.0-4.0'),
    _CriteriaOption('UTR', '4.1-8.0'),
    _CriteriaOption('UTR', '8.1-12'),
    _CriteriaOption('UTR', '12.1-16'),

    _CriteriaOption('Level', 'Begineer'),
    _CriteriaOption('Level', 'Intermediate'),
    _CriteriaOption('Level', 'Advanced I'),
    _CriteriaOption('Level', 'Advanced II'),

    _CriteriaOption('Class', 'Senior master'),
    _CriteriaOption('Class', 'National master'),
    _CriteriaOption('Class', 'Expert'),
    _CriteriaOption('Class', 'Class A'),
    _CriteriaOption('Class', 'Class B'),
    _CriteriaOption('Class', 'Class C'),
    _CriteriaOption('Class', 'Class D'),
    _CriteriaOption('Class', 'Class E'),
    _CriteriaOption('Class', 'Class F'),
    _CriteriaOption('Class', 'Class G'),
    _CriteriaOption('Class', 'Class H'),
    _CriteriaOption('Class', 'Class I'),
    _CriteriaOption('Class', 'Class J'),
  ];

  /// Condition dropdown, in the order the client listed them.
  static const List<MapEntry<String, String>> _conditionOptions = [
    MapEntry('Default', 'Default'),
    MapEntry('Equal', 'Equal'),
    MapEntry('UpTo', 'Up to'),
    MapEntry('Greater', 'Greater than'),
    MapEntry('GreaterAndEqual', 'Greater and equal'),
    MapEntry('Lower', 'Less than'),
    MapEntry('LowerAndEqual', 'Less and equal'),
  ];

  final List<String> roundTypeList = ['Preliminary', 'SemiFinal', 'Final'];
  final List<String> yesNoList = ['Yes', 'No'];

  // Controllers for Round
  final TextEditingController groupValueController = TextEditingController();
  final TextEditingController roundDateController = TextEditingController();
  final TextEditingController roundTimeController = TextEditingController();
  final TextEditingController roundCostController = TextEditingController();
  final TextEditingController roundLateFeeController = TextEditingController();
  final TextEditingController roundDescriptionController = TextEditingController();
  final TextEditingController rFinalYearController = TextEditingController();
  final TextEditingController rFinalMonthController = TextEditingController();
  final TextEditingController rFinalDayController = TextEditingController();

  final Addeventcontroller addeventcontroller = Get.find<Addeventcontroller>();

  /// Selected criteria option id (see [_CriteriaOption.id]).
  String? _selectedCriteriaId;

  /// Selected condition — already an API `RoundCondition` value.
  String? _selectedCondition;
  String? _selectedRoundType;
  String? _selectedHasFinalDeadline;

  _CriteriaOption? get _selectedCriteriaOption {
    final id = _selectedCriteriaId;
    if (id == null) return null;
    for (final option in _criteriaOptions) {
      if (option.id == id) return option;
    }
    return null;
  }

  /// Legacy UI labels still map to the API enums so edit-prefill keeps working.
  String _mapConditionToApi(String condition) {
    switch (condition) {
      case 'Greater Than':
        return 'Greater';
      case 'Greater And Equal':
        return 'GreaterAndEqual';
      case 'Less Than':
        return 'Lower';
      case 'Less And Equal':
        return 'LowerAndEqual';
      default:
        return condition;
    }
  }


  num? _parseGroupValue(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;
    return num.tryParse(trimmed);
  }

  @override
  void initState() {
    super.initState();
    // DO NOT clear tempRounds here — IndexedStack keeps this widget alive,
    // so initState is only called once when the screen first loads.
    // Clearing here would wipe rounds only on first load, not on re-entry.
  }

  @override
  void dispose() {
    groupValueController.dispose();
    roundDateController.dispose();
    roundTimeController.dispose();
    roundCostController.dispose();
    roundLateFeeController.dispose();
    roundDescriptionController.dispose();
    rFinalYearController.dispose();
    rFinalMonthController.dispose();
    rFinalDayController.dispose();
    super.dispose();
  }

  void _saveDataToController() {
    // If the user added rounds but never pressed "Add" on the group,
    // auto-save them into a group so data isn't lost on Next.
    if (addeventcontroller.tempRounds.isNotEmpty) {
      final option = _selectedCriteriaOption ??
          const _CriteriaOption('Age', '6-12', min: 6, max: 12);
      final condition = _mapConditionToApi(_selectedCondition ?? 'UpTo');
      final conditionLabel = _conditionLabel(condition);

      num? value;
      if (option.isAge) {
        value = _parseGroupValue(groupValueController.text) ?? option.min ?? 0;
      }

      final generatedName = option.isDefault
          ? 'Default'
          : (option.isAge
              ? '${option.criteria} $conditionLabel $value'
              : '${option.criteria} $conditionLabel ${option.label}');

      // Deep-copy before clearing
      final snapshotRounds = addeventcontroller.tempRounds
          .map((r) => Map<String, dynamic>.from(r))
          .toList();

      addeventcontroller.addGroup(
        generatedName,
        option.criteria,
        condition,
        value,
        snapshotRounds,
        valueLabel: option.label,
      );
      addeventcontroller.clearTempRounds();
      setState(() {
        _selectedCriteriaId = null;
        _selectedCondition = null;
        groupValueController.clear();
      });
    }
  }

  /// A number is only meaningful for Age groups. UTR / Level / Class carry a
  /// preset label, and Default carries neither.
  bool get _needsNumericValue => _selectedCriteriaOption?.isAge ?? false;

  Widget _buildCriteriaDropdown() {
    // Grouped by criteria type, with the type shown as a non-selectable header.
    final items = <DropdownMenuItem<String>>[];
    String? lastCriteria;

    for (final option in _criteriaOptions) {
      if (option.label != null && option.criteria != lastCriteria) {
        lastCriteria = option.criteria;
      }
      items.add(
        DropdownMenuItem<String>(
          value: option.id,
          child: Row(
            children: [
              if (option.label != null)
                Container(
                  margin: EdgeInsets.only(right: 6.w),
                  padding:
                      EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppColors.colorEDF2F4,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    option.criteria,
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              Flexible(
                child: Text(
                  option.label ?? option.criteria,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.sp),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 48.5.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.colorEDF2F4,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.borderColor, width: 1.w),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _selectedCriteriaId,
          hint: Text('Criteria',
              style: TextStyle(
                  fontSize: 13.sp, color: AppColors.color414141)),
          icon: Icon(Icons.keyboard_arrow_down,
              size: 20.sp, color: AppColors.primaryColor),
          menuMaxHeight: 320.h,
          items: items,
          onChanged: (id) {
            setState(() {
              _selectedCriteriaId = id;
              final option = _selectedCriteriaOption;
              // Prefill the number from the Age band so the group is valid
              // straight away; the user can still change it.
              if (option != null && option.isAge && option.min != null) {
                groupValueController.text = option.min.toString();
              } else {
                groupValueController.clear();
              }
            });
          },
        ),
      ),
    );
  }

  Widget _buildConditionDropdown() {
    return Container(
      height: 48.5.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.colorEDF2F4,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.borderColor, width: 1.w),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _selectedCondition,
          hint: Text('Condition',
              style: TextStyle(
                  fontSize: 13.sp, color: AppColors.color414141)),
          icon: Icon(Icons.keyboard_arrow_down,
              size: 20.sp, color: AppColors.primaryColor),
          menuMaxHeight: 320.h,
          items: _conditionOptions
              .map((entry) => DropdownMenuItem<String>(
                    value: entry.key,
                    child: Text(entry.value,
                        style: TextStyle(fontSize: 12.sp)),
                  ))
              .toList(),
          onChanged: (v) => setState(() => _selectedCondition = v),
        ),
      ),
    );
  }

  /// "Age  Up to  15" / "Class  Equal  Class A" / "Default"
  String _groupSummary(Map<String, dynamic> group) {
    final criteria = group['criteria']?.toString() ?? '';
    if (criteria == 'Default') return 'Default';

    final condition = _conditionLabel(group['condition']?.toString() ?? '');
    final label = group['valueLabel']?.toString().trim();
    final value = (label != null && label.isNotEmpty)
        ? label
        : (group['value']?.toString() ?? '');

    return [criteria, condition, value]
        .where((part) => part.trim().isNotEmpty)
        .join('  ');
  }

  String _conditionLabel(String apiValue) {
    for (final entry in _conditionOptions) {
      if (entry.key == apiValue) return entry.value;
    }
    return apiValue;
  }

  void _addGroup() {
    final option = _selectedCriteriaOption;
    if (option == null || _selectedCondition == null) {
      AppFeedback.validation('Choose a criteria and a condition.');
      return;
    }

    num? parsedValue;
    if (option.isAge) {
      parsedValue = _parseGroupValue(groupValueController.text);
      if (parsedValue == null) {
        AppFeedback.validation('Enter an age value for this group.');
        return;
      }
    }

    // Rounds are optional: a group can be saved on its own and rounds added
    // to it later.
    final apiCondition = _mapConditionToApi(_selectedCondition!);
    final conditionLabel = _conditionLabel(apiCondition);
    final generatedName = option.isDefault
        ? 'Default'
        : (option.isAge
            ? '${option.criteria} $conditionLabel $parsedValue'
            : '${option.criteria} $conditionLabel ${option.label}');

    // Snapshot the rounds NOW (deep copy) before anything is cleared.
    final snapshotRounds = addeventcontroller.tempRounds
        .map((r) => Map<String, dynamic>.from(r))
        .toList();

    addeventcontroller.addGroup(
      generatedName,
      option.criteria,
      apiCondition,
      parsedValue,
      snapshotRounds,
      valueLabel: option.label,
    );

    addeventcontroller.clearTempRounds();
    setState(() {
      _selectedCriteriaId = null;
      _selectedCondition = null;
      groupValueController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 4.h, 24.w, 12.h),
      child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Text('Step 3: Group',
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600)),
              ),
              Text('Define Group',
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              SizedBox(height: 6.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildCriteriaDropdown(),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: _buildConditionDropdown(),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _needsNumericValue
                        ? CustomTextField(
                            height: 48.5,
                            controller: groupValueController,
                            hintText: 'Age value (e.g. 15)',
                            keyboardType: TextInputType.number,
                          )
                        : Container(
                            height: 48.5.h,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            decoration: BoxDecoration(
                              color: AppColors.colorEDF2F4,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                  color: AppColors.borderColor, width: 1.w),
                            ),
                            child: Text(
                              _selectedCriteriaOption?.label ??
                                  'No value needed',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: AppColors.color414141,
                              ),
                            ),
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
                      onTap: _addGroup,
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
                              subtitle: Text(_groupSummary(group)),
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
                            AppFeedback.validation(
                              'Select a round type and deadline date.',
                            );
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
              SizedBox(height: 12.h),
            ],
      ),
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
    required void Function(String?)? onChanged,
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
