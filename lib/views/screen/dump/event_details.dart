// import 'package:event_sharing/controllers/event_controller.dart';
// import 'package:event_sharing/helpers/route.dart';
// import 'package:event_sharing/utils/app_colors.dart';
// import 'package:event_sharing/utils/app_icons.dart';
// import 'package:event_sharing/utils/app_strings.dart';
// import 'package:event_sharing/utils/style.dart';
// import 'package:event_sharing/views/base/custom_button.dart';
// import 'package:event_sharing/views/base/custom_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import '../../../models/event_model.dart';
//
// class EventDetailsScreen extends StatefulWidget {
//   const EventDetailsScreen({super.key});
//
//   @override
//   State<EventDetailsScreen> createState() => _EventDetailsScreenState();
// }
//
// class _EventDetailsScreenState extends State<EventDetailsScreen> {
//   final EventController _eventController = Get.find<EventController>();
//   Group? _selectedGroup;
//
//   @override
//   void initState() {
//     super.initState();
//     final String? eventId = Get.arguments;
//     if (eventId != null) {
//       _eventController.fetchEventDetails(eventId);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         scrolledUnderElevation: 0,
//         leading: Padding(
//           padding: EdgeInsets.only(left: 8.w),
//           child: IconButton(
//             icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 18.w),
//             onPressed: () => Get.back(),
//           ),
//         ),
//         title: Text('Event Details',
//             style: GoogleFonts.poppins(
//                 fontSize: 18.sp,
//                 fontWeight: FontWeight.w500,
//                 color: AppColors.blackColor)),
//         centerTitle: true,
//       ),
//       body: Obx(() {
//         if (_eventController.isLoadingDetails.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         final event = _eventController.eventDetails.value;
//         if (event == null) {
//           return const Center(child: Text("Event details not found"));
//         }
//
//         // Initialize selected group if not set
//         if (_selectedGroup == null && (event.schedule?.groups?.isNotEmpty ?? false)) {
//           _selectedGroup = event.schedule!.groups![0];
//         }
//
//         return SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 16.w),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Stack(
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(16.r),
//                       child: event.coverImage != null
//                           ? Image.network(
//                               event.coverImage!,
//                               height: 180.h,
//                               width: 345.w,
//                               fit: BoxFit.cover,
//                               errorBuilder: (context, error, stackTrace) => Container(
//                                 height: 180.h, width: 345.w, color: Colors.grey, child: const Icon(Icons.image),
//                               ),
//                             )
//                           : Image.asset(
//                               'assets/images/concert.jpg',
//                               height: 180.h, width: 345.w, fit: BoxFit.cover,
//                             ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16.h),
//                 Text(event.eventName ?? 'N/A',
//                     style: AppStyles.headTitle().copyWith(
//                       fontSize: 15.sp,
//                       decoration: TextDecoration.underline,
//                       decorationColor: Colors.black,
//                       decorationThickness: 1.0,
//                     )),
//                 SizedBox(height: 16.h),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         _buildActionCircle(AppIcons.editIcon, () {}),
//                         SizedBox(width: 10.w),
//                         Container(
//                           width: 32.w, height: 32.w,
//                           decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.colorEDF2F4),
//                           child: Icon(Icons.done, color: AppColors.primaryColor, size: 20.sp),
//                         ),
//                       ],
//                     ),
//                     _buildActionCircle(AppIcons.share, () => Get.toNamed(AppRoutes.myInvitationPage)),
//                   ],
//                 ),
//                 SizedBox(height: 12.h),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildInfoRow('Program', event.program?.name ?? 'N/A'),
//                           SizedBox(height: 17.h),
//                           _buildInfoRow('Type', event.schedule?.eventType ?? 'N/A'),
//                           SizedBox(height: 17.h),
//                           _buildInfoRow('Location', event.location ?? 'N/A'),
//                           SizedBox(height: 18.h),
//                           _buildInfoRowWithDateTime(
//                             'Deadline',
//                             event.schedule?.deadline != null ? DateFormat('d-M-yyyy').format(event.schedule!.deadline!) : 'N/A',
//                             event.schedule?.deadline != null ? DateFormat('hh:mm a').format(event.schedule!.deadline!) : '',
//                           ),
//                           SizedBox(height: 18.h),
//                           _buildInfoRow('Final Deadline', event.schedule?.finalDeadline != null ? DateFormat('d-M-yyyy').format(event.schedule!.finalDeadline!) : 'N/A'),
//                         ],
//                       ),
//                     ),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildInfoRow('Competition Level', event.schedule?.competitionLevel ?? 'N/A'),
//                           SizedBox(height: 17.h),
//                           _buildInfoRowWithDateTime(
//                             'Registration Open',
//                             event.schedule?.registrationDate != null ? DateFormat('d-M-yyyy').format(event.schedule!.registrationDate!) : 'N/A',
//                             event.schedule?.registrationDate != null ? DateFormat('hh:mm a').format(event.schedule!.registrationDate!) : '',
//                           ),
//                           SizedBox(height: 17.h),
//                           _buildInfoRow('Repeat Function', event.repeatConfig?.frequency ?? 'Never'),
//                           SizedBox(height: 18.h),
//                           _buildInfoRowWithCheck('Cost', '\$${event.schedule?.cost ?? '0'}'),
//                           SizedBox(height: 18.h),
//                           _buildInfoRowWithCheck('Late Fee', '\$${event.schedule?.lateFee ?? '0'}'),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 SizedBox(height: 24.h),
//                 Text(AppStrings.description, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
//                 SizedBox(height: 8.h),
//                 Text(event.description ?? 'N/A', style: AppStyles.fieldContent(color: AppColors.color414141)),
//
//                 SizedBox(height: 16.h),
//                 Text(AppStrings.note, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
//                 SizedBox(height: 8.h),
//                 Text(event.note ?? 'N/A', style: AppStyles.fieldContent(color: AppColors.color414141)),
//
//                 if (event.schedule?.groups?.isNotEmpty ?? false) ...[
//                   SizedBox(height: 16.h),
//                   _buildGroupDropdown(event.schedule!.groups!),
//                   SizedBox(height: 16.h),
//                   if (_selectedGroup != null) ...[
//                     ..._selectedGroup!.rounds!.map((round) => _buildRoundSection(round)).toList(),
//                   ],
//                 ],
//
//                 const Divider(thickness: 1, color: Colors.grey),
//                 SizedBox(height: 16.h),
//                 Padding(
//                   padding: EdgeInsets.only(left: 7.w),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Preliminary', style: AppStyles.fontSize12(fontWeight: FontWeight.w600).copyWith(fontSize: 13.sp)),
//                       SizedBox(height: 8.h),
//                       const Text('N/A', style: TextStyle(color: AppColors.color414141)), // Static for now as results/history format not fully clear from JSON
//                       SizedBox(height: 16.h),
//                       const Divider(thickness: 1, color: Colors.grey),
//                       Align(
//                         alignment: Alignment.centerRight,
//                         child: Container(
//                           padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 8.w),
//                           decoration: BoxDecoration(color: AppColors.fillColor, borderRadius: BorderRadius.circular(4.r)),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Text('Estimation Total Cost: ${event.schedule?.estimatedCost?.totalEstimatedCost ?? '0'}',
//                                   style: AppStyles.fontSize14(color: AppColors.color414141, fontWeight: FontWeight.w500).copyWith(fontSize: 10.sp)),
//                               SizedBox(width: 8.w),
//                               SvgPicture.asset(AppIcons.editIcon, height: 12.w, width: 12.w),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 15.h),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               Text('Created By', style: GoogleFonts.poppins(fontSize: 12.sp, color: AppColors.color414141)),
//                               SizedBox(width: 8.w),
//                               CircleAvatar(
//                                 radius: 30.r,
//                                 backgroundImage: NetworkImage(event.creator?.profilePicture ?? 'https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg'),
//                               ),
//                             ],
//                           ),
//                           Text(
//                             'Created at\n${event.createdAt != null ? DateFormat('d-M-yyyy').format(event.createdAt!) : 'N/A'}',
//                             textAlign: TextAlign.right,
//                             style: GoogleFonts.poppins(fontSize: 12.sp, color: AppColors.color414141),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 15.h),
//                       Text('Has already contribute or verification by (${event.results?.length ?? 0}) Users', style: TextStyle(fontSize: 12.sp)),
//                       SizedBox(height: 10.h),
//                       Row(
//                         children: [
//                           CircleAvatar(radius: 25.r, backgroundImage: const NetworkImage('https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg')),
//                         ],
//                       ),
//                       SizedBox(height: 10.h),
//                       Text('Latest active N/A', style: TextStyle(fontSize: 13.sp, color: AppColors.color414141)),
//                       SizedBox(height: 20.h),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           SizedBox(width: 164.w, child: CustomButton(borderColor: AppColors.buttonColor, onTap: () {}, text: "Edit & Verify", color: AppColors.fillColor, textColor: Colors.black)),
//                           SizedBox(width: 164.w, child: CustomButton(onTap: () => Get.toNamed(AppRoutes.appliedSearchEventListScreen), text: "Apply", textColor: Colors.white, color: AppColors.buttonColor)),
//                         ],
//                       ),
//                       SizedBox(height: 20.h),
//                       CustomButton(color: AppColors.colorD9A951, borderColor: AppColors.colorD9A951, textColor: AppColors.white, onTap: () {}, text: 'Delete')
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }
//
//   Widget _buildActionCircle(String icon, VoidCallback onTap) {
//     return Container(
//       width: 32.w, height: 32.w,
//       decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.colorEDF2F4),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: InkWell(onTap: onTap, child: SvgPicture.asset(icon)),
//       ),
//     );
//   }
//
//   Widget _buildGroupDropdown(List<Group> groups) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12.w),
//       decoration: BoxDecoration(
//         color: AppColors.fillColor,
//         border: Border.all(color: AppColors.buttonColor, width: 1.w),
//         borderRadius: BorderRadius.circular(8.r),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<Group>(
//           isExpanded: true,
//           value: _selectedGroup,
//           hint: CustomText(text: 'Select Group', fontsize: 13.sp),
//           icon: SvgPicture.asset(AppIcons.downArrowIcon, width: 16.w, color: AppColors.blackColor),
//           items: groups.map((Group group) {
//             return DropdownMenuItem<Group>(
//               value: group,
//               child: Text("${group.name} (${group.criteria} ${group.condition} ${group.value})"),
//             );
//           }).toList(),
//           onChanged: (Group? newValue) {
//             setState(() {
//               _selectedGroup = newValue;
//             });
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildRoundSection(Round round) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             SvgPicture.asset(AppIcons.myEventIcon, color: AppColors.primaryColor),
//             SizedBox(width: 8.w),
//             Text(round.roundType ?? 'Round', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
//           ],
//         ),
//         SizedBox(height: 15.h),
//         Padding(
//           padding: EdgeInsets.only(left: 7.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       SvgPicture.asset(AppIcons.dotIconForFamily),
//                       SizedBox(width: 5.w),
//                       Text('Deadline: ', style: AppStyles.fontSize12(fontWeight: FontWeight.w600)),
//                       Text(round.deadline != null ? DateFormat('d-M-yyyy').format(round.deadline!) : 'N/A', style: AppStyles.fontSize12()),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       SvgPicture.asset(AppIcons.dotIconForFamily),
//                       SizedBox(width: 5),
//                       Text('Cost: ', style: AppStyles.fontSize12(fontWeight: FontWeight.w600)),
//                       Text('\$${round.cost ?? '0'}', style: AppStyles.fontSize12()),
//                       SizedBox(width: 10),
//                     ],
//                   ),
//                   if (round.hasFinalDeadline == true)
//                     Container(
//                       decoration: BoxDecoration(color: Colors.blueGrey, borderRadius: BorderRadius.circular(4)),
//                       padding: const EdgeInsets.all(4),
//                       child: const Icon(Icons.check, color: Colors.white, size: 10),
//                     ),
//                 ],
//               ),
//               SizedBox(height: 8.h),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: Row(
//                       children: [
//                         SvgPicture.asset(AppIcons.dotIconForFamily),
//                         SizedBox(width: 5),
//                         const Text('Description: ', style: TextStyle(fontWeight: FontWeight.w600)),
//                         Expanded(child: Text(round.description ?? 'N/A', style: AppStyles.fontSize12())),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         const Divider(thickness: 1, color: Colors.grey),
//         SizedBox(height: 16.h),
//       ],
//     );
//   }
//
//   Widget _buildInfoRow(String label, String value) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(padding: EdgeInsets.only(top: 4.h), child: SvgPicture.asset(AppIcons.dotIconForFamily, height: 12.h, width: 12.h)),
//         SizedBox(width: 5.w),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(label, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
//               SizedBox(height: 5.h),
//               Text(value, style: AppStyles.fieldContent(color: Colors.grey.shade600)),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildInfoRowWithDateTime(String label, String date, String time) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(padding: EdgeInsets.only(top: 4.h), child: SvgPicture.asset(AppIcons.dotIconForFamily, height: 12.h, width: 12.h)),
//         SizedBox(width: 5.w),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(label, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
//               SizedBox(height: 5.h),
//               Row(
//                 children: [
//                   Text(date, style: AppStyles.fieldContent(color: Colors.grey.shade600)),
//                   SizedBox(width: 5.w),
//                   Text(time, style: AppStyles.fieldContent(color: Colors.grey.shade600)),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildInfoRowWithCheck(String label, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(padding: EdgeInsets.only(top: 4.h), child: SvgPicture.asset(AppIcons.dotIconForFamily, height: 12.h, width: 12.h)),
//             SizedBox(width: 5.w),
//             Expanded(
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(label, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
//                   Container(
//                     decoration: BoxDecoration(color: Colors.blueGrey, borderRadius: BorderRadius.circular(4)),
//                     padding: const EdgeInsets.all(4),
//                     child: const Icon(Icons.check, color: Colors.white, size: 10),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 5.h),
//         Padding(padding: EdgeInsets.only(left: 17.w), child: Text(value, style: AppStyles.fieldContent(color: Colors.grey.shade600))),
//       ],
//     );
//   }
// }
