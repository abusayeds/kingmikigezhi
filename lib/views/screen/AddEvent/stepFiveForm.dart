import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import 'controller/addEventController.dart';

class StepFiveForm extends StatefulWidget {
  const StepFiveForm({super.key});

  @override
  State<StepFiveForm> createState() => _StepFiveFormState();
}

class _StepFiveFormState extends State<StepFiveForm> {
  final List<String> roundList = [
    '1 Prize',
    '2 Prize',
    '3 Prize',
    '4 Prize',
    '5 Prize',
    '6 Prize',
    'Grand Prize',
    'Honorable Mention',
    'Audience Awards',
    'Special Prize',
  ];

  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  final TextEditingController finalDatelineMonthController = TextEditingController();
  final TextEditingController finalDatelineDayController = TextEditingController();
  final TextEditingController finalDatelineYearController = TextEditingController();

  final Addeventcontroller addEventController = Get.find<Addeventcontroller>();

  String? _selectedHistoryEventId;
  String? _selectedRound;

  @override
  void initState() {
    super.initState();
    _selectedHistoryEventId = addEventController.selectedHistoryEventId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      addEventController.fetchHistoryEvents();
    });
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
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Text(
                  "Step 4: Own History (Optional)",
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                'You can skip this step and still create the event.',
                style: AppStyles.fontSize12(color: AppColors.hintColor),
              ),
              SizedBox(height: 12.h),
              Text('Session', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              SizedBox(height: 12.h),
              Obx(() {
                if (addEventController.isLoadingHistory.value) {
                  return SizedBox(
                    height: AppStyles.standardHeight,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }

                final events = addEventController.historyEvents;
                // Only valid entries, unique by id — dropdown shows eventName only
                final seenIds = <String>{};
                final validEvents = events.where((e) {
                  final id = e['id']?.toString() ?? '';
                  final name = e['eventName']?.toString() ?? '';
                  if (id.isEmpty || name.isEmpty) return false;
                  return seenIds.add(id);
                }).toList();

                final selectedId = _selectedHistoryEventId != null &&
                        validEvents.any((e) => e['id']?.toString() == _selectedHistoryEventId)
                    ? _selectedHistoryEventId
                    : null;

                return Container(
                  height: AppStyles.standardHeight,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: AppColors.fillColor,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.primaryColor, width: 1),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedId,
                      dropdownColor: AppColors.fillColor,
                      menuWidth: 240.w,
                      borderRadius: BorderRadius.circular(8.r),
                      hint: Text(
                        "Select History Event",
                        style: AppStyles.fontSize14(color: AppColors.color414141),
                      ),
                      icon: SvgPicture.asset(
                        AppIcons.downArrowIcon,
                        width: 16.w,
                        color: AppColors.primaryColor,
                      ),
                      isExpanded: true,
                      items: validEvents.map((event) {
                        final id = event['id'].toString();
                        final name = event['eventName'].toString();
                        return DropdownMenuItem<String>(
                          value: id,
                          child: Text(
                            name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedHistoryEventId = newValue;
                          addEventController.selectedHistoryEventId = newValue;
                        });
                      },
                    ),
                  ),
                );
              }),
              SizedBox(height: 8.h),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Text('Record', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      height: AppStyles.standardHeight,
                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                      decoration: BoxDecoration(
                        color: AppColors.fillColor,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: AppColors.primaryColor, width: 1),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedRound,
                          dropdownColor: AppColors.fillColor,
                          menuWidth: 240.w,
                          borderRadius: BorderRadius.circular(8.r),
                          hint: Text("Type Score",style: AppStyles.fontSize14(color: AppColors.color414141)),
                          icon: SvgPicture.asset(AppIcons.downArrowIcon, width: 16.w, color: AppColors.primaryColor,
                          ),
                          isExpanded: true,
                          items: roundList.map((String value) {
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
                              _selectedRound = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: CustomButton(
                      onTap: () {
                        if (_selectedHistoryEventId == null) {
                          Fluttertoast.showToast(msg: "Please select a history event");
                          return;
                        }
                        if (_selectedRound == null) {
                          Fluttertoast.showToast(msg: "Please select a record");
                          return;
                        }
                        final selectedEvent = addEventController.historyEvents.firstWhereOrNull(
                          (e) => e['id']?.toString() == _selectedHistoryEventId,
                        );
                        final eventName = selectedEvent?['eventName']?.toString() ?? '';
                        final year = selectedEvent?['eventYear']?.toString() ??
                            (selectedEvent?['createdAt'] != null
                                ? selectedEvent!['createdAt'].toString().split('-').first
                                : '');
                        addEventController.addOwnHistory(
                          eventId: _selectedHistoryEventId!,
                          eventName: eventName,
                          year: year,
                          placement: _selectedRound!,
                        );
                        setState(() {
                          _selectedRound = null;
                        });
                      },
                      text: 'Add',
                      textColor: AppColors.textColor,
                      borderColor: AppColors.buttonA47059,
                      color: AppColors.buttonA47059,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.all(4.r),
                child: Text('History', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              ),
              Obx(() => Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.colorEDF2F4,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: AppColors.primaryColor, width: 1.w),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: addEventController.ownHistories.isEmpty
                      ? Padding(
                          padding: EdgeInsets.all(8.r),
                          child: CustomText(
                            text: 'No history added — optional. Tap Add & Share to create without history.',
                            color: AppColors.color414141,
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(addEventController.ownHistories.length, (index) {
                            final history = addEventController.ownHistories[index];
                            final year = history['year']?.toString() ?? '';
                            final placement = history['placement']?.toString() ?? '';
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(AppIcons.dotIconForFamily),
                                        SizedBox(width: 4.w),
                                        Flexible(
                                          child: CustomText(
                                            text: year.isNotEmpty
                                                ? '$year - $placement place winner'
                                                : '$placement place winner',
                                            color: AppColors.color414141,
                                            maxline: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            // Edit: load back into dropdowns and remove from list
                                            setState(() {
                                              _selectedHistoryEventId = history['eventId']?.toString();
                                              addEventController.selectedHistoryEventId = _selectedHistoryEventId;
                                              _selectedRound = placement;
                                            });
                                            addEventController.removeOwnHistory(index);
                                          },
                                          child: SvgPicture.asset(AppIcons.editIcon)),
                                      SizedBox(width: 4.w),
                                      InkWell(
                                          onTap: () {
                                            addEventController.removeOwnHistory(index);
                                          },
                                          child: SvgPicture.asset(AppIcons.trashIcon))
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                ),
              )),
              SizedBox(height: 16.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => addEventController.isSharedToCommunity.value = !addEventController.isSharedToCommunity.value,
                        child: Container(
                          decoration: BoxDecoration(
                            color: addEventController.isSharedToCommunity.value ? Colors.blueGrey : Colors.transparent,
                            shape: BoxShape.rectangle,
                            border: Border.all(color: Colors.blueGrey),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            Icons.check,
                            color: addEventController.isSharedToCommunity.value ? Colors.white : Colors.transparent,
                            size: 16.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          'This is a shared community. All events are public',
                          style: AppStyles.fontSize12(color: AppColors.hintColor)
                        ),
                      ),
                    ],
                  )),
                  SizedBox(height: 16.h),
                  Obx(() => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          addEventController.isUserAgreementAccepted.value =
                              !addEventController.isUserAgreementAccepted.value;
                          if (addEventController.isUserAgreementAccepted.value) {
                            addEventController.showUserAgreementError.value = false;
                          }
                        },
                        child: Container(
                          width: 24.w,
                          height: 24.h,
                          decoration: BoxDecoration(
                            color: addEventController.isUserAgreementAccepted.value ? Colors.blueGrey : Colors.transparent,
                            border: Border.all(
                              color: addEventController.showUserAgreementError.value &&
                                      !addEventController.isUserAgreementAccepted.value
                                  ? Colors.red
                                  : Colors.blueGrey,
                            ),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: addEventController.isUserAgreementAccepted.value 
                            ? Icon(Icons.check, color: Colors.white, size: 16.sp)
                            : null,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'User agreement',
                          style: AppStyles.fontSize12(color: AppColors.hintColor)
                      ),
                    ],
                  )),
                ],
              ),
              SizedBox(height: 24.h),
              Obx(() {
                if (!addEventController.showUserAgreementError.value) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Text(
                    'Please accept the user agreement',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }),
              Obx(() => Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onTap: () {
                        if (addEventController.activeStepIndex.value > 0) {
                          addEventController.activeStepIndex.value--;
                        }
                      },
                      text: "Back",
                      borderColor: AppColors.buttonColor,
                      color: AppColors.fillColor,
                      textColor: Colors.black,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: addEventController.isLoading.value 
                      ? const Center(child: CircularProgressIndicator())
                      : CustomButton(
                          // Own history is optional — create/update works with an empty list.
                          onTap: addEventController.createEvent,
                          text: addEventController.isEditMode.value
                              ? "Update & Share"
                              : "Add & Share",
                          textColor: Colors.white,
                          borderColor: AppColors.buttonColor,
                          color: AppColors.buttonColor,
                        ),
                  ),
                ],
              )),
              SizedBox(height: 10.h),
            ],
          ),
        )
      ]),
    );
  }
}