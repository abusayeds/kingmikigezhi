// import 'package:event_sharing/utils/app_icons.dart';
// import 'package:event_sharing/utils/style.dart';
// import 'package:event_sharing/views/base/custom_button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
//
// import '../../../../utils/app_colors.dart';
// import 'controller/addEventController.dart';
//
// class StepFourForm extends StatefulWidget {
//   const StepFourForm({Key? key}) : super(key: key);
//
//   @override
//   State<StepFourForm> createState() => _StepFourFormState();
// }
//
// class _StepFourFormState extends State<StepFourForm> {
//   TextEditingController relationShipController = TextEditingController();
//   final Addeventcontroller addeventcontroller = Get.find<Addeventcontroller>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 24.w),
//       child: Column(
//         children: [
//           SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding:  EdgeInsets.symmetric(vertical: 8.h),
//                   child:Text("Step 4: Configuration", style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600)),
//                 ),
//                 SizedBox(height: 22.h),
//                 Padding(
//                   padding: EdgeInsets.all(4.r),
//                   child: Text("Repeat Function", style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
//                 ),
//                 Container(
//                   height: 53.h,
//                   padding: EdgeInsets.symmetric(horizontal: 20.w),
//                   decoration: BoxDecoration(
//                     color: AppColors.fillColor,
//                     borderRadius: BorderRadius.circular(8.r),
//                     border: Border.all(color: AppColors.primaryColor, width: 1),
//                   ),
//                   child: GestureDetector(
//                     onTap: () {
//                       showRepeatPopup(context);
//                     },
//                     child: InputDecorator(
//                       decoration: InputDecoration.collapsed(hintText: null),
//                       child: Center( // Center the content
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text('Function Type', style: AppStyles.fontSize16(color: AppColors.color414141)),
//                             SvgPicture.asset(AppIcons.downArrowIcon, width: 16.w, color: AppColors.primaryColor,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 350.h),
//                 Align(
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: CustomButton(
//                           onTap: () {
//                             setState(() {
//                               if (addeventcontroller.activeStepIndex.value == 3) {
//                                 addeventcontroller.activeStepIndex.value--;
//                                 //StepThreeForm();
//
//                               } // In create_event_one.dart, modify the step widgets to pass the activeStepIndex and update function:
//                             });
//                           },
//                           text: "Back",
//                           color: AppColors.fillColor,
//                           textColor: Colors.black,
//                           borderColor: AppColors.buttonColor,
//                         ),
//                       ),
//                       SizedBox(width: 10.w),
//                       Expanded(
//                         child: CustomButton(
//                           onTap: () {
//                             setState(() {
//                               if (addeventcontroller.activeStepIndex.value == 3) {
//                                 addeventcontroller.activeStepIndex.value++;
//                                 //StepThreeForm();
//
//                               } // In create_event_one.dart, modify the step widgets to pass the activeStepIndex and update function:
//                             });
//                           },
//                           text: "Next",
//                           textColor: Colors.white,
//                           color: AppColors.buttonColor,
//                           borderColor: AppColors.buttonColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   ///popup
//  showRepeatPopup(BuildContext context) async {
//     TextEditingController dateController = TextEditingController();
//     int selectedOption = 0;
//
//     Future<void> _selectDate(BuildContext context) async {
//       DateTime? selectedDate = await showDatePicker(
//         context: context,
//         initialDate: DateTime.now(),
//         firstDate: DateTime(2020),
//         lastDate: DateTime(2030),
//       );
//       if (selectedDate != null) {
//         dateController.text = "${selectedDate.month}/${selectedDate.day}/${selectedDate.year}";
//       }
//     }
//
//     return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//             return AlertDialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16.0),
//               ),
//               contentPadding: EdgeInsets.all(16.0),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Repeat",
//                     style: TextStyle(
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   SizedBox(height: 16.h),
//                   // Start Date Input
//                   TextField(
//                     controller: dateController,
//                     readOnly: true,
//                     onTap: () => _selectDate(context),
//                     decoration: InputDecoration(
//                       labelText: "Start",
//                       suffixIcon: IconButton(
//                         icon: Icon(Icons.calendar_today),
//                         onPressed: () => _selectDate(context),
//                       ),
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   SizedBox(height: 16.h),
//                   // Repeat every year dropdown
//                   Row(
//                     children: [
//                       Icon(Icons.repeat),
//                       SizedBox(width: 8.w),
//                       Expanded(
//                         child: DropdownButtonFormField(
//                           value: 'Repeat every year',
//                           items: [
//                             DropdownMenuItem(
//                               child: Text('Repeat every year'),
//                               value: 'Repeat every year',
//                             ),
//                           ],
//                           onChanged: (value) {},
//                           decoration: InputDecoration(border: InputBorder.none),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 16.h),
//                   // Radio options
//                   Column(
//                     children: [
//                       RadioListTile(
//                         value: 0,
//                         groupValue: selectedOption,
//                         title: Text("On Jan 6"),
//                         onChanged: (value) {
//                           setState(() {
//                             selectedOption = value as int;
//                           });
//                         },
//                       ),
//                       RadioListTile(
//                         value: 1,
//                         groupValue: selectedOption,
//                         title: Text("On the first Sunday of Jan"),
//                         onChanged: (value) {
//                           setState(() {
//                             selectedOption = value as int;
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                   // Additional text
//                   Row(
//                     children: [
//                       Text(
//                         "Every Jan 6 ",
//                         style: TextStyle(color: AppColors.blackColor, fontSize: 14.sp),
//                       ),
//                       Text(
//                         "Choose an end date",
//                         style: TextStyle(color: Colors.blue, fontSize: 14.sp),
//                         textAlign: TextAlign.justify,
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20.h),
//                   // Buttons
//                   Row(
//                     children: [
//                       Expanded(
//                         child: CustomButton(
//                           onTap: () {
//                             Get.back();
//                           },
//                           text: "Save",
//                           color: AppColors.buttonColor,
//                           borderColor: AppColors.buttonColor,
//                           textColor:AppColors.textColor,
//                         ),
//                       ),
//                       SizedBox(width: 10.w),
//                       Expanded(
//                         child: CustomButton(
//                           onTap: () {},
//                           text: "Discard",
//                           textColor: AppColors.blackColor,
//                           color: AppColors.fillColor,
//                           borderColor: AppColors.buttonColor,
//
//                         ),
//                       ),
//                     ],
//                   ),
//
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
