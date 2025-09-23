import 'package:event_sharing/utils/app_images.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/screen/Profile/Invitation/invitationListController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors.dart';
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 18.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'All the people who\nhas invited you!',
                    style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primaryColor),
                  ),
                  Spacer(),
                  _AllButton(
                    text: 'Ignore All',
                    onTap: () {
                      invitationListController.rejectAllInvitations();
                    },
                    borderColor: Color(0xFFD54444),
                    textColor: Color(0xFFD54444),
                    backgroundColor: Colors.transparent,
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
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
              SizedBox(
                height: 24.h,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return Obx(() {
                      final status = invitationListController.invitationStatusMap[index] ?? InvitationStatus.pending;

                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Container(
                          height: 64.h,
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 64.w,
                                width: 64.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100.r),
                                  color: Colors.transparent,
                                  border: Border.all(
                                      width: 2.w, color: const Color(0xFF4C7E95)),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100.r),
                                  child: Image.network(
                                   'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFYqoKTu_o3Zns2yExbst2Co84Gpc2Q1RJbA&s',
                                    fit: BoxFit.cover,
                                    width: 64.w,
                                    height: 64.w,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 18.w,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Akash Roy",
                                      style: GoogleFonts.poppins(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF414141)),
                                    ),
                                    SizedBox(height: 8.h),
                                    _buildInvitationButtons(status, index),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    });
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInvitationButtons(InvitationStatus status, int index) {
    switch (status) {
      case InvitationStatus.accepted:
        return Container(
          padding: EdgeInsets.symmetric(   vertical: 6.h),

          child: Text(
            'Invitation request accepted',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              fontSize: 10.sp,
              color: Color(0xFF28AC4B),
            ),
          ),
        );
      case InvitationStatus.rejected:
        return Container(
          padding: EdgeInsets.symmetric(  vertical: 6.h),

          child: Text(
            'Invitation request rejected',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              fontSize: 10.sp,
              color: Color(0xFFD54444),
            ),
          ),
        );
      case InvitationStatus.pending:
      default:
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _AllButton(
              text: 'Ignore',
              onTap: () {
                invitationListController.rejectInvitation(index);
              },
              borderColor: Color(0xFFA47059),
              textColor: Colors.white,
              backgroundColor: Color(0xFFCF9B84),
            ),
            SizedBox(width: 12.w),
            _AllButton(
              text: 'Accept',
              onTap: () {
                invitationListController.acceptInvitation(index);
              },
              borderColor: Color(0xFF4C7E95),
              textColor: Colors.white,
              backgroundColor: Color(0xFF9EC4D5),
            ),
          ],
        );
    }
  }

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