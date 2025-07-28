
import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MyInvitationPage extends StatefulWidget {
  @override
  _MyInvitationPageState createState() => _MyInvitationPageState();
}

class _MyInvitationPageState extends State<MyInvitationPage> {
  // List of invitees
  final List<Map<String, dynamic>> invitees = [
    {
      'name': 'Bashar Iskam',
      'location': 'Canada, Elm St',
      'avatarColor': AppColors.color67AB9F,
      'checked': false
    },
    {
      'name': 'Iskam',
      'location': 'Canada, Elm St',
      'avatarColor': AppColors.colorE5CCFF,
      'checked': false
    },
    {
      'name': 'Alax Tom',
      'location': 'Canada, Elm St',
      'avatarColor':AppColors.colorCCFFE6,
      'checked': false
    },
    {
      'name': 'Jihon',
      'location': 'Canada, Elm St',
      'avatarColor': AppColors.colorFFF2CC,
      'checked': false
    },
    {
      'name': 'Bashar Iskam',
      'location': 'Canada, Elm St',
      'avatarColor': Color(0xFFd9d9d9),
      'checked': false
    },
  ];

  void _toggleCheckbox(int index, bool? value) {
    setState(() {
      invitees[index]['checked'] = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:  Padding(
          padding:  EdgeInsets.only(left: 24.w),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: Colors.black, size: 18.w),
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
        padding:  EdgeInsets.symmetric(horizontal:24.w ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsetsGeometry.all(0),
                itemCount: invitees.length,
                itemBuilder: (context, index) {
                  final invitee = invitees[index];
                  return Container(
                    padding: EdgeInsets.symmetric( vertical: 8.h),
                    child: Row(
                      children: [
                        // Leading - CircleAvatar
                        // CircleAvatar(
                        //   radius: 64,
                        //   backgroundColor: invitee['avatarColor'],
                        // ),
                        Container(
                          height: 64.w,
                          width: 64.w,
                          decoration: BoxDecoration(
                            color: invitee['avatarColor'],
                            borderRadius: BorderRadius.circular(100.r),

                          ),
                        ),
                        SizedBox(width: 16.w), // Space between avatar and text

                        // Title and Subtitle - Expanded to take available space
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Title
                              Text(
                                invitee['name'],
                                style: AppStyles.fontSize14(
                                  color: AppColors.color414141,
                                  fontWeight: FontWeight.w500,
                                ).copyWith(fontSize: 15.sp),
                              ),
                              SizedBox(height: 4.h), // Small space between title and subtitle

                              // Subtitle
                              Text(
                                invitee['location'],
                                style: GoogleFonts.poppins(
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.color414141
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Trailing - Checkbox
                        Checkbox(
                          activeColor: AppColors.primaryColor,
                          side: BorderSide(
                            color: AppColors.primaryColor,
                            width: 1.w,
                          ),
                          value: invitee['checked'],
                          onChanged: (bool? value) {
                            _toggleCheckbox(index, value);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
         CustomButton(
           onTap: (){
             Get.toNamed(AppRoutes.shareInvitationPage);
           },
           text: 'Share',
           borderColor: AppColors.buttonA47059,
           color: AppColors.buttonA47059,
           textColor: AppColors.textColor,
         ),
            SizedBox(height: 41.h)
          ],
        ),
      ),
    );
  }
}
