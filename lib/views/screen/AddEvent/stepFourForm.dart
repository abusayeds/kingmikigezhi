import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:event_sharing/views/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../utils/app_colors.dart';

class StepFourForm extends StatefulWidget {
  const StepFourForm({Key? key}) : super(key: key);

  @override
  State<StepFourForm> createState() => _StepFourFormState();
}

class _StepFourFormState extends State<StepFourForm> {
  TextEditingController relationShipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CustomText(
                  text: "Step 4: Configuration",
                  fontsize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 22.h),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                  'Repeat Function',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                height: 60.h,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  color: AppColors.fillColor,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.primaryColor, width: 1),
                ),
                child: GestureDetector(
                  onTap: () {
                    showRepeatPopup(context);
                  },
                  child: InputDecorator(
                    decoration: InputDecoration.collapsed(hintText: null), // Hide underline and make it look like a button
                    child: Center( // Center the content
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: 'Function Type',
                            fontsize: 16.sp,
                          ),
                          SvgPicture.asset(AppIcons.downArrowIcon, width: 16.w, color: AppColors.primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 200.h),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onTap: () {},
                      text: "Back",
                      color: AppColors.fillColor,
                      textColor: Colors.black,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: CustomButton(
                      onTap: () {},
                      text: "Next",
                      textColor: Colors.white,
                      color: AppColors.buttonColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  ///popup
 showRepeatPopup(BuildContext context) async {
    TextEditingController dateController = TextEditingController();
    int selectedOption = 0;

    Future<void> _selectDate(BuildContext context) async {
      DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
      );
      if (selectedDate != null) {
        dateController.text = "${selectedDate.month}/${selectedDate.day}/${selectedDate.year}";
      }
    }

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              contentPadding: EdgeInsets.all(16.0),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Repeat",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Start Date Input
                  TextField(
                    controller: dateController,
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    decoration: InputDecoration(
                      labelText: "Start",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context),
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Repeat every year dropdown
                  Row(
                    children: [
                      Icon(Icons.repeat),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: DropdownButtonFormField(
                          value: 'Repeat every year',
                          items: [
                            DropdownMenuItem(
                              child: Text('Repeat every year'),
                              value: 'Repeat every year',
                            ),
                          ],
                          onChanged: (value) {},
                          decoration: InputDecoration(border: InputBorder.none),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  // Radio options
                  Column(
                    children: [
                      RadioListTile(
                        value: 0,
                        groupValue: selectedOption,
                        title: Text("On Jan 6"),
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value as int;
                          });
                        },
                      ),
                      RadioListTile(
                        value: 1,
                        groupValue: selectedOption,
                        title: Text("On the first Sunday of Jan"),
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value as int;
                          });
                        },
                      ),
                    ],
                  ),
                  // Additional text
                  Text(
                    "Every Jan 6. Choose an end date",
                    style: TextStyle(color: Colors.blue, fontSize: 14.sp),
                  ),
                  SizedBox(height: 20.h),
                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          onTap: () {
                            Get.back();
                          },
                          text: "Save",
                          color: AppColors.fillColor,
                          textColor: Colors.black,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: CustomButton(
                          onTap: () {},
                          text: "Discard",
                          textColor: Colors.white,
                          color: AppColors.buttonColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
