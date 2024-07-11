import 'package:event_sharing/utils/app_strings.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icons.dart';
import '../../base/custom_text.dart';

class InviteEventScreen extends StatefulWidget {
  const InviteEventScreen({super.key});

  @override
  State<InviteEventScreen> createState() => _InviteEventScreenState();
}

class _InviteEventScreenState extends State<InviteEventScreen> {
  final TextEditingController fromNameCTRL = TextEditingController();
  final TextEditingController toNameCTRL = TextEditingController();
  final TextEditingController messageCTRL = TextEditingController();
  final TextEditingController dateCTRL = TextEditingController();
  final TextEditingController timeCTRL = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: AppStrings.inviteEvent,
          fontsize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          children: [
            //============================> From Name Text Field <===================
            CustomTextField(
              controller: fromNameCTRL,
              hintText: AppStrings.enterYourNameFROM,
            ),
            SizedBox(height: 16.h),
            //============================> To Name Text Field <===================
            CustomTextField(
              controller: toNameCTRL,
              hintText: AppStrings.enterReceiversName,
            ),
            //============================> Message Text Field <===================
            SizedBox(height: 16.h),
            CustomTextField(
              controller: messageCTRL,
              hintText: 'Message (60 words)',
              maxLines: 5,
            ),
            //============================> Date and Time Picker Row <===================
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //============================> Date Picker <===================
                SizedBox(
                  width: 165.w,
                  child: CustomTextField(
                    onTab: () {
                      selectDate(context);
                    },
                    readOnly: true,
                    controller: dateCTRL,
                    hintText: 'Date',
                    sufixicons: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: SvgPicture.asset(
                        AppIcons.calendarIcon,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
                //============================> Time Picker <===================
                SizedBox(
                  width: 165.w,
                  child: CustomTextField(
                    onTab: () {
                      selectTime(context);
                    },
                    readOnly: true,
                    controller: timeCTRL,
                    hintText: 'Time',
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
            const Spacer(),
            //===============================> Share Button <==================================
            CustomButton(
              onTap: () {},
              text: AppStrings.share,
              textColor: Colors.white,
            ),
            SizedBox(height: 87.h)
          ],
        ),
      ),
    );
  }
  //===============================> Show Calender Function <=======================

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(3050),
    );
    if (pickedDate != null) {
      setState(() {
        dateCTRL.text =
            "${pickedDate.month}-${pickedDate.day}-${pickedDate.year}";
      });
      print('Selected date: ${dateCTRL.text}');
    }
  }

  //===============================> Show Clock Function <=======================
  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        final hours = pickedTime.hour.toString().padLeft(2, '0');
        final minutes = pickedTime.minute.toString().padLeft(2, '0');
        timeCTRL.text = "$hours:$minutes";
      });
      print('Selected time: ${timeCTRL.text}');
    }
  }
}
