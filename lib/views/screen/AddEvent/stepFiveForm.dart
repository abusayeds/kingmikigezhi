import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
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
  final List<String> roundList = ['1st', '2nd','Silver','Gold'];

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
                child: Text("Step 4: Own History", style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600)),
              ),
              //registration date
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
                      onTap: (){},
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
              Container(
                decoration: BoxDecoration(
                  color: AppColors.colorEDF2F4,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: AppColors.primaryColor, width: 1.w),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(AppIcons.dotIconForFamily),
                                SizedBox(width: 4.w),
                                CustomText(
                                  text: '2021 - 1st place winner',
                                  color: AppColors.color414141,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                InkWell(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: SvgPicture.asset(AppIcons.editIcon)),
                                SizedBox(width: 4.w),
                                InkWell(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: SvgPicture.asset(AppIcons.trashIcon))
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(AppIcons.dotIconForFamily),
                                SizedBox(width: 4.w),
                                CustomText(
                                  text: '2022 - 1st place winner',
                                  color: AppColors.color414141,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                InkWell(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: SvgPicture.asset(AppIcons.editIcon)),
                                const SizedBox(width: 4),
                                InkWell(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: SvgPicture.asset(AppIcons.trashIcon))
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(AppIcons.dotIconForFamily),
                                SizedBox(width: 4.w),
                                CustomText(
                                  text: '2023 - 1st place winner',
                                  color: AppColors.color414141,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                InkWell(
                                    onTap: () {
                                      //  Get.back();
                                    },
                                    child: SvgPicture.asset(AppIcons.editIcon)),
                                const SizedBox(width: 4),
                                InkWell(
                                    onTap: () {
                                      //Get.back();
                                    },
                                    child: SvgPicture.asset(AppIcons.trashIcon))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
                        onTap: () => addEventController.isUserAgreementAccepted.value = !addEventController.isUserAgreementAccepted.value,
                        child: Container(
                          width: 24.w,
                          height: 24.h,
                          decoration: BoxDecoration(
                            color: addEventController.isUserAgreementAccepted.value ? Colors.blueGrey : Colors.transparent,
                            border: Border.all(color: Colors.blueGrey),
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
              SizedBox(height: 50.h),
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