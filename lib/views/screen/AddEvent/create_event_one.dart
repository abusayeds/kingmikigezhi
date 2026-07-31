import 'dart:io';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:event_sharing/models/event_model.dart';
import 'package:event_sharing/utils/app_colors.dart';

import 'package:event_sharing/views/screen/AddEvent/controller/addEventController.dart';
import 'package:event_sharing/views/screen/AddEvent/stepFiveForm.dart';
import 'package:event_sharing/views/screen/AddEvent/stepOneForm.dart';
import 'package:event_sharing/views/screen/AddEvent/stepThreeForm.dart';
import 'package:event_sharing/views/screen/AddEvent/stepTwoForm.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../utils/app_strings.dart';
import '../../base/custom_text.dart';


class CreateEventOne extends StatefulWidget {
  const CreateEventOne({super.key});

  @override
  State<CreateEventOne> createState() => _CreateEventOneState();
}

class _CreateEventOneState extends State<CreateEventOne> {
  final TextEditingController organizerController = TextEditingController();
  final TextEditingController eventName = TextEditingController();
  final TextEditingController eventPortal = TextEditingController();
  final TextEditingController registrationPortal = TextEditingController();
  final TextEditingController descriptionCRTL = TextEditingController();
  final TextEditingController noteCRTL = TextEditingController();

  var parameter = Get.parameters;
  Uint8List? coverImage;
  List<Uint8List?> eventImages = [null, null, null, null];
  File? selectedImage;

  // final List<String> numberList = ['Concert', 'Sports', 'Show', 'Olympic game'];
  // final List<String> programList = ['Program One', 'Program Two', 'Program Three'];
  //  final List<String> yearList = ['2020', '2021', '2024'];
  // final List<String> sessionList = ['One', 'Two', 'Three'];
  final Addeventcontroller addEventController = Get.put(Addeventcontroller());

  @override
  void initState() {
    super.initState();
    final dynamic args = Get.arguments;
    if (args is EventModel) {
      addEventController.loadFromEvent(args);
    } else {
      addEventController.resetForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Obx(() => CustomText(
          text: addEventController.isEditMode.value
              ? 'Update Event'
              : AppStrings.createNewEvent,
          fontsize: 18.sp,
          fontWeight: FontWeight.w500,
        )),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wrap the stepper in Obx to make it reactive
            Obx(() => SizedBox(
              height: 100.h,
              child: EasyStepper(
                activeStep: addEventController.activeStepIndex.value,
                stepShape: StepShape.rRectangle,
                stepBorderRadius: 20,
                borderThickness: 2,
                stepRadius: 20,
                finishedStepBorderColor: AppColors.primaryColor,
                finishedStepTextColor: AppColors.primaryColor,
                finishedStepBackgroundColor: AppColors.primaryColor,
                activeStepIconColor: AppColors.primaryColor,
                showLoadingAnimation: false,
                steps: [
                  EasyStep(
                    customStep: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Opacity(
                        opacity: addEventController.activeStepIndex.value >= 0 ? 1 : 0.3,
                        child: Container(
                          color: AppColors.primaryColor,
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          child: const Text(
                            '1',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    customTitle: Text(
                      'Basic', style: TextStyle(fontSize: 12.sp),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  EasyStep(
                    customStep: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Opacity(
                        opacity: addEventController.activeStepIndex.value >= 1 ? 1 : 0.3,
                        child: Container(
                          color: AppColors.primaryColor,
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          child: const Text(
                            '2',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    customTitle: Text(
                      'Details', style: TextStyle(fontSize: 12.sp),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  EasyStep(
                    customStep: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Opacity(
                        opacity: addEventController.activeStepIndex.value >= 2 ? 1 : 0.3,
                        child: Container(
                          color: AppColors.primaryColor,
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          child: const Text(
                            '3',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    customTitle: Text(
                      'Group', style: TextStyle(fontSize: 12.sp),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // EasyStep(
                  //   customStep: ClipRRect(
                  //     borderRadius: BorderRadius.circular(20),
                  //     child: Opacity(
                  //       opacity: addEventController.activeStepIndex.value >= 3 ? 1 : 0.3,
                  //       child: Container(
                  //         color: AppColors.primaryColor,
                  //         width: 50,
                  //         height: 50,
                  //         alignment: Alignment.center,
                  //         child: const Text(
                  //           '4',
                  //           style: TextStyle(
                  //             fontSize: 24,
                  //             color: Colors.white,
                  //             fontWeight: FontWeight.bold,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  //   customTitle: Text(
                  //     'Config', style: TextStyle(fontSize: 12.sp),
                  //     textAlign: TextAlign.center,
                  //   ),
                  // ),
                  EasyStep(
                    customStep: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Opacity(
                        opacity: addEventController.activeStepIndex.value >= 3 ? 1 : 0.3,
                        child: Container(
                          color: AppColors.primaryColor,
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          child: const Text(
                            '4',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    customTitle:  Text(
                      'History', style: TextStyle(fontSize: 12.sp),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                onStepReached: (index) => addEventController.activeStepIndex.value = index,
              ),
            )),
            // Wrap the step content in Obx to make it reactive
            Obx(() {
              if (addEventController.activeStepIndex.value == 0) {
                return const Steponeform();
              } else if (addEventController.activeStepIndex.value == 1)
                return const StepTwoForm();
              else if (addEventController.activeStepIndex.value == 2)
                return const StepThreeForm();
              else if (addEventController.activeStepIndex.value == 3)
                return const StepFiveForm();
              // else if (addEventController.activeStepIndex.value == 4)
              //   return const StepFiveForm();
              else
                return const Steponeform(); // Default fallback
            }),
          ],
        ),
      ),
    );
  }
}