import 'package:easy_stepper/easy_stepper.dart';
import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/models/event_model.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/views/screen/AddEvent/controller/addEventController.dart';
import 'package:event_sharing/views/screen/AddEvent/stepFiveForm.dart';
import 'package:event_sharing/views/screen/AddEvent/stepOneForm.dart';
import 'package:event_sharing/views/screen/AddEvent/stepThreeForm.dart';
import 'package:event_sharing/views/screen/AddEvent/stepTwoForm.dart';
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
  var parameter = Get.parameters;

  // Force a fresh controller every time this screen opens so stale state
  // from a previous create/edit session is never carried over.
  late final Addeventcontroller addEventController;
  late final ScrollController _scrollController;
  Worker? _stepScrollWorker;

  @override
  void initState() {
    super.initState();
    // Delete any existing instance before putting a new one so we always
    // start clean regardless of how many times the screen is pushed.
    Get.delete<Addeventcontroller>(force: true);
    addEventController = Get.put(Addeventcontroller());
    _scrollController = ScrollController();

    // When user taps Next/Back or the stepper, jump back to the top so the
    // AppBar + step header are visible on every step.
    _stepScrollWorker = ever(addEventController.activeStepIndex, (_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_scrollController.hasClients) return;
        _scrollController.jumpTo(0);
      });
    });

    final dynamic args = Get.arguments;
    if (args is EventModel) {
      addEventController.loadFromEvent(args);
    } else {
      addEventController.resetForm();
    }
  }

  @override
  void dispose() {
    _stepScrollWorker?.dispose();
    _scrollController.dispose();
    // Clean up so the next open always gets a fresh instance.
    Get.delete<Addeventcontroller>(force: true);
    super.dispose();
  }

  /// Back: previous step, or leave the form if already on step 1.
  void _onBackPressed() {
    if (addEventController.activeStepIndex.value > 0) {
      addEventController.activeStepIndex.value--;
    } else {
      Get.back();
    }
  }

  /// Close: discard the create/edit form and return to navbar Home.
  void _onClosePressed() {
    Get.offAndToNamed(AppRoutes.homeScreen);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _onBackPressed();
      },
      child: Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 18.w),
          onPressed: _onBackPressed,
        ),
        title: Obx(() => CustomText(
          text: addEventController.isEditMode.value
              ? 'Update Event'
              : AppStrings.createNewEvent,
          fontsize: 18.sp,
          fontWeight: FontWeight.w500,
        )),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.black, size: 22.w),
            onPressed: _onClosePressed,
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
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
            // Use IndexedStack so all step widgets stay alive — their State
            // (text controllers, dropdown values, tempRounds, etc.) is never
            // destroyed when the user navigates between steps.
            Obx(() => IndexedStack(
              index: addEventController.activeStepIndex.value.clamp(0, 3),
              children: const [
                Steponeform(),
                StepTwoForm(),
                StepThreeForm(),
                StepFiveForm(),
              ],
            )),
          ],
        ),
      ),
      ),
    );
  }
}