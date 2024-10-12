import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_strings.dart';
import '../../base/custom_text.dart';
import '../../base/custom_text_field.dart';

class CreateEventTwo extends StatefulWidget {
  const CreateEventTwo({super.key});

  @override
  State<CreateEventTwo> createState() => _CreateEventTwoState();
}

class _CreateEventTwoState extends State<CreateEventTwo> {
  final TextEditingController eventStatusCTRL = TextEditingController();
  final TextEditingController eventCostCTRL = TextEditingController();
  final TextEditingController eventDescriptionCTRL = TextEditingController();
  final TextEditingController startDateCTRL = TextEditingController();
  final TextEditingController endDateCTRL = TextEditingController();
  final TextEditingController startTimeCTRL = TextEditingController();
  final TextEditingController endTimeCTRL = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //=======================> App Bar Section <============================
      appBar: AppBar(
          title: CustomText(
            text: AppStrings.createNewEvent,
            fontsize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
          centerTitle: true),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //==============================> Event Status Text Field <=============================
              _sectionTitle(AppStrings.eventStatus),
              CustomTextField(
                controller: eventStatusCTRL,
                hintText: AppStrings.typeYourEventStatus,
              ),
              SizedBox(height: 16.h),

              //==============================> Registration Cost Text Field <=============================
              _sectionTitle(AppStrings.registrationCost),
              CustomTextField(
                controller: eventCostCTRL,
                hintText: AppStrings.typeYourEventCost,
                keyboardType: TextInputType.number, // Ensure numeric input for cost
              ),
              SizedBox(height: 16.h),

              //==============================> Select Date Text <=============================
              _sectionTitle(AppStrings.selectDate),
              //==============================> Select Date Row Text Field <=============================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 165.w,
                    child: CustomTextField(
                      onTab: () {
                        selectDate(context, 'Start');
                      },
                      readOnly: true,
                      controller: startDateCTRL,
                      hintText: AppStrings.startDate,
                      sufixicons: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: SvgPicture.asset(
                          AppIcons.calendarIcon,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 165.w,
                    child: CustomTextField(
                      onTab: () {
                        selectDate(context, 'End');
                      },
                      readOnly: true,
                      controller: endDateCTRL,
                      hintText: AppStrings.endDate,
                      sufixicons: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: SvgPicture.asset(
                          AppIcons.calendarIcon,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              //==============================> Select Time Text <=============================
              _sectionTitle(AppStrings.selectTime),
              //==============================> Select Time Row Text Field <=============================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 165.w,
                    child: CustomTextField(
                      onTab: () {
                        selectTime(context, 'Start');
                      },
                      readOnly: true,
                      controller: startTimeCTRL,
                      hintText: AppStrings.startTime,
                      sufixicons: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: SvgPicture.asset(
                          AppIcons.timeIcon,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 165.w,
                    child: CustomTextField(
                      onTab: () {
                        selectTime(context, 'End');
                      },
                      readOnly: true,
                      controller: endTimeCTRL,
                      hintText: AppStrings.endTime,
                      sufixicons: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: SvgPicture.asset(
                          AppIcons.timeIcon,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              //==============================> Event Description Text Field <=============================
              _sectionTitle(AppStrings.eventDescription),
              CustomTextField(
                controller: eventDescriptionCTRL,
                hintText: AppStrings.typeYourEventDescription,
                maxLines: 5,
              ),
              SizedBox(height: 32.h),

              //==============================> Create Event Button <=============================
              CustomButton(
                onTap: () {
                  if (_validateInputs()) {
                    // Handle event creation or move to the next screen
                    print("Event created successfully!");
                  } else {
                    // Show error or feedback to the user
                    _showErrorDialog(context);
                  }
                },
                text: AppStrings.createEvent,
                textColor: Colors.white,
              ),
              SizedBox(height: 57.h),
            ],
          ),
        ),
      ),
    );
  }

  //==============================> Section Title Widget <=============================
  Widget _sectionTitle(String text) {
    return CustomText(
      text: text,
      fontWeight: FontWeight.bold,
      fontsize: 16.sp,
      bottom: 8.h,
      top: 13.h,
    );
  }

  //==============================> Show Calendar Function <=============================
  Future<void> selectDate(BuildContext context, String type) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(3050),
    );
    if (pickedDate != null) {
      setState(() {
        if (type == 'Start') {
          startDateCTRL.text = "${pickedDate.month}-${pickedDate.day}-${pickedDate.year}";
        } else if (type == 'End') {
          endDateCTRL.text = "${pickedDate.month}-${pickedDate.day}-${pickedDate.year}";
        }
      });
    }
  }

  //==============================> Show Clock Function <=============================
  Future<void> selectTime(BuildContext context, String type) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        final hours = pickedTime.hour.toString().padLeft(2, '0');
        final minutes = pickedTime.minute.toString().padLeft(2, '0');
        if (type == 'Start') {
          startTimeCTRL.text = "$hours:$minutes";
        } else if (type == 'End') {
          endTimeCTRL.text = "$hours:$minutes";
        }
      });
    }
  }

  //==============================> Input Validation <=============================
  bool _validateInputs() {
    if (eventStatusCTRL.text.isEmpty ||
        eventCostCTRL.text.isEmpty ||
        eventDescriptionCTRL.text.isEmpty ||
        startDateCTRL.text.isEmpty ||
        endDateCTRL.text.isEmpty ||
        startTimeCTRL.text.isEmpty ||
        endTimeCTRL.text.isEmpty) {
      return false; // Input validation fails
    }
    return true; // All inputs are valid
  }

  //==============================> Show Error Dialog <=============================
  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Input Error'),
          content: Text('Please fill in all the required fields.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
