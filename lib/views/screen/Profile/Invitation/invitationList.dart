import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/screen/Profile/Invitation/invitationListController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/app_images.dart';
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

  final List<Map<String, dynamic>> invitations = [
    {
      "name": "Alax Tom",
      "accountID": 2010,
      "contribution": 100,
    },
    {
      "name": "Mahafujer",
      "accountID": 2011,
      "contribution": 150,
    },
    {
      "name": "Rahman MunnA",
      "accountID": 2012,
      "contribution": 200,
    },
  ];

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
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:   EdgeInsets.symmetric(horizontal: 24.w),
                // child: Text(
                //   'All the people who has invited you!',
                //   style: GoogleFonts.poppins(
                //       fontSize: 14.sp,
                //       fontWeight: FontWeight.w400,
                //       color: AppColors.blackColor),
                // ),

                child: const Text('All the people who has invited you!'),
              ),
              SizedBox(height: 8.h,),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(12.r),
                  itemCount: invitations.length,
                  itemBuilder: (context, index) {
              final invitation = invitations[index];
              return Container(
                padding: EdgeInsets.symmetric(vertical: 4.h,horizontal: 8.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [
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
                                return Image.asset(
                                  AppImages.logo,
                                  fit: BoxFit.cover,
                                  width: 90.r,
                                  height: 90.r,
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Alax Tom', style: AppStyles.fontSize16(fontWeight: FontWeight.w600,color: AppColors.color414141),),
                            SizedBox(height: 8.h,),
                            Row(
                              children: [
                                SvgPicture.asset(AppIcons.dotIconForFamily),
                                const SizedBox(width: 4),
                                Text("Account ID: ${invitation['accountID']}",
                                  style: AppStyles.fontSize10(color: AppColors.color414141),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h,),
                            Row(
                              children: [
                                SvgPicture.asset(AppIcons.dotIconForFamily),
                                const SizedBox(width: 4),
                                Text("Contribution: ${invitation['contribution']}",
                                  style: AppStyles.fontSize10(color: AppColors.color414141),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Expanded(
                            child:CustomButton(
                              onTap: (){},
                              text: 'Ignore',textStyle: const TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
                              color: AppColors.fillColor,
                              borderColor: AppColors.buttonA47059,
                              textColor: AppColors.blackColor,
                            )
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                            child:CustomButton(
                              onTap: (){},
                              text: 'Accept',textStyle: const TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
                              color: AppColors.buttonA47059,
                              borderColor: AppColors.buttonA47059,
                              textColor: AppColors.textColor,
                            )
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child:  Divider(thickness: .5,color: AppColors.greyColor,),
                    )


                  ],

                ),


              );
            },
                ),
              ),
            ],
          ),
          if (invitations.isNotEmpty)
            Positioned(
              bottom: 15,
              left: 0,
              right: 0,

              child: Padding(
                padding: EdgeInsets.all(12.r),
                child: Row(
                  children: [
                    Expanded(
                        child:CustomButton(
                          onTap: (){},
                          text: 'Ignore All',textStyle: const TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
                          color: AppColors.fillColor,
                          borderColor: AppColors.buttonColor,
                          textColor: AppColors.blackColor,
                        )
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                        child:CustomButton(
                          onTap: (){},
                          text: 'Accept All',textStyle: const TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
                          color: AppColors.buttonColor,
                          borderColor: AppColors.buttonA47059,
                          textColor: AppColors.textColor,
                        )
                    ),
                  ],
                ),
              ),
            ),
        ],
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
              color: const Color(0xFF28AC4B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: const Color(0xFF28AC4B)),
            ),
            child: Center(
              child: Text(
                'Invitation request accepted',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                  color: const Color(0xFF28AC4B),
                ),
              ),
            ),
          );

        case InvitationStatus.rejected:
          return Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: const Color(0xFFD54444).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: const Color(0xFFD54444)),
            ),
            child: Center(
              child: Text(
                'Invitation request rejected',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                  color: const Color(0xFFD54444),
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