import 'package:event_sharing/utils/app_images.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/screen/Profile/Invitation/invitationListController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../base/custom_button.dart';
import '../../../base/custom_text.dart';

class Invitationlist extends StatefulWidget {
  const Invitationlist({super.key});

  @override
  State<Invitationlist> createState() => _InvitationlistState();
}

class _InvitationlistState extends State<Invitationlist> {
  final InvitationListController invitationListController =
  Get.find<InvitationListController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 24.w),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 18.w),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        title: CustomText(
          text: 'Invitation',
          fontWeight: FontWeight.w500,
          fontsize: 18.sp,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 18.h),

            // Header section with global action buttons
            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    'All the people who\nhas invited you!',
                    style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primaryColor),
                  ),
                ),
                SizedBox(width: 12.w),

                // Show global status or buttons
                if (invitationListController.allRejected.value)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Color(0xFFD54444).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(100.r),
                      border: Border.all(color: Color(0xFFD54444)),
                    ),
                    child: Text(
                      'All Ignored',
                      style: GoogleFonts.poppins(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFD54444),
                      ),
                    ),
                  )
                else if (invitationListController.allAccepted.value)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Color(0xFF28AC4B).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(100.r),
                      border: Border.all(color: Color(0xFF28AC4B)),
                    ),
                    child: Text(
                      'All Accepted',
                      style: GoogleFonts.poppins(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF28AC4B),
                      ),
                    ),
                  )
                else
                  Row(
                    children: [
                      _AllButton(
                        text: 'Ignore All',
                        onTap: () {
                          invitationListController.rejectAllInvitations();
                        },
                        borderColor: Color(0xFFD54444),
                        textColor: Color(0xFFD54444),
                        backgroundColor: Colors.transparent,
                      ),
                      SizedBox(width: 8.w),
                      _AllButton(
                        text: 'Accept All',
                        onTap: () {
                          invitationListController.acceptAllInvitations();
                        },
                        borderColor: Color(0xFF28AC4B),
                        textColor: Color(0xFF28AC4B),
                        backgroundColor: Colors.transparent,
                      ),
                    ],
                  ),
              ],
            )),

            SizedBox(height: 24.h),

            // Invitation list
            Expanded(
              child: Obx(() => ListView.builder(
                itemCount: invitationListController.invitationStatuses.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Profile Avatar
                            CircleAvatar(
                              radius: 45.r,
                              backgroundColor: Colors.grey.shade300,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(45.r),
                                child: Image.network(
                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFYqoKTu_o3Zns2yExbst2Co84Gpc2Q1RJbA&s',
                                  fit: BoxFit.cover,
                                  width: 90.r,
                                  height: 90.r,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.person,
                                      size: 45.r,
                                      color: Colors.grey.shade600,
                                    );
                                  },
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),

                            // User Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Alax Tom ${index + 1}', // Adding index for variety
                                    style: AppStyles.fontSize16(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.color414141),
                                  ),
                                  SizedBox(height: 8.h),
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        AppIcons.dotIconForFamily,
                                        width: 12.w,
                                        height: 12.w,
                                      ),
                                      SizedBox(width: 4.w),
                                      Flexible(
                                        child: Text(
                                          "Account ID: ${2000 + index}",
                                          style: AppStyles.fontSize10(
                                              color: AppColors.color414141),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h),
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        AppIcons.dotIconForFamily,
                                        width: 12.w,
                                        height: 12.w,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        "Contribution: ${300 + (index * 50)}",
                                        style: AppStyles.fontSize10(
                                            color: AppColors.color414141),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        // Action buttons or status text
                        _buildInvitationActions(index),
                      ],
                    ),
                  );
                },
              )),
            ),
          ],
        ),
      ),
    );
  }

  // Build invitation actions based on status
  Widget _buildInvitationActions(int index) {
    return Obx(() {
      final status = invitationListController.invitationStatuses[index];

      switch (status) {
        case InvitationStatus.accepted:
          return Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: Color(0xFF28AC4B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: Color(0xFF28AC4B)),
            ),
            child: Center(
              child: Text(
                'Invitation request accepted',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                  color: Color(0xFF28AC4B),
                ),
              ),
            ),
          );

        case InvitationStatus.rejected:
          return Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: Color(0xFFD54444).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: Color(0xFFD54444)),
            ),
            child: Center(
              child: Text(
                'Invitation request rejected',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                  color: Color(0xFFD54444),
                ),
              ),
            ),
          );

        case InvitationStatus.pending:
        default:
          return Row(
            children: [
              Expanded(
                child: CustomButton(
                  onTap: () {
                    invitationListController.rejectInvitation(index);
                  },
                  text: 'Ignore',
                  textStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  color: AppColors.fillColor,
                  borderColor: AppColors.buttonA47059,
                  textColor: AppColors.blackColor,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CustomButton(
                  onTap: () {
                    invitationListController.acceptInvitation(index);
                  },
                  text: 'Accept',
                  textStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  color: AppColors.buttonA47059,
                  borderColor: AppColors.buttonA47059,
                  textColor: AppColors.textColor,
                ),
              ),
            ],
          );
      }
    });
  }

  // Helper widget for global action buttons
  Widget _AllButton({
    required String text,
    required VoidCallback onTap,
    required Color borderColor,
    required Color textColor,
    required Color backgroundColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(width: 1.w, color: borderColor),
          color: backgroundColor,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 10.sp,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}