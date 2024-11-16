
import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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
      'avatarColor': Colors.teal,
      'checked': false
    },
    {
      'name': 'Iskam',
      'location': 'Canada, Elm St',
      'avatarColor': Colors.purpleAccent,
      'checked': false
    },
    {
      'name': 'Alax Tom',
      'location': 'Canada, Elm St',
      'avatarColor': Colors.lightGreenAccent,
      'checked': false
    },
    {
      'name': 'Jihon',
      'location': 'Canada, Elm St',
      'avatarColor': Colors.amberAccent,
      'checked': false
    },
    {
      'name': 'Bashar Iskam',
      'location': 'Canada, Elm St',
      'avatarColor': Colors.grey,
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
        leading:  IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Colors.black, size: 18.w),
          onPressed: () {
            Get.back();
          },
        ),
        title: CustomText(
          text: 'Invitation',
          fontWeight: FontWeight.bold,
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
                itemCount: invitees.length,
                itemBuilder: (context, index) {
                  final invitee = invitees[index];
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: invitee['avatarColor'],
                    ),
                    title: Text(
                      invitee['name'],
                    style: AppStyles.fontSize16(color: AppColors.color414141,fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(invitee['location'],
                      style: AppStyles.fontSize14(color: AppColors.color414141),
                    ),
                    trailing: Checkbox(
                      activeColor: AppColors.primaryColor,
                      value: invitee['checked'],
                      onChanged: (bool? value) {
                        _toggleCheckbox(index, value);
                      },
                    ),
                  );
                },
              ),
            ),
         CustomButton(
           onTap: (){
             Get.toNamed(AppRoutes.shareInvitationPage);
           },
           text: 'Invitation',
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
