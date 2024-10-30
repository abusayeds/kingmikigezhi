import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_images.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:event_sharing/views/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ShareInvitationPage extends StatefulWidget {
  @override
  _ShareInvitationPageState createState() => _ShareInvitationPageState();
}

class _ShareInvitationPageState extends State<ShareInvitationPage> {
  final TextEditingController messageController = TextEditingController();

  final TextEditingController urlController = TextEditingController();

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
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            CustomTextField(
                controller: messageController,
              hintText: 'Message (60 words)',
              maxLines: 5,
            ),
            SizedBox(height: 24.h),
            // Row for the social media icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSocialMediaIcon( Image.asset(AppImages.massage, width: 60.w,height: 60.h), "iMessage",Colors.green),
                _buildSocialMediaIcon(Image.asset(AppImages.whatsapp, width: 60.w,height: 60.h), "WhatsApp",Colors.greenAccent),
                _buildSocialMediaIcon(Image.asset(AppImages.gmail, width: 60.w,height: 60.h), "Gmail",Colors.redAccent),
                _buildSocialMediaIcon(Image.asset(AppImages.insta, width: 60.w,height: 60.h), "Instagram",Colors.redAccent),
              ],
            ),
            SizedBox(height: 24.h),
            CustomTextField(
                controller: urlController,
              hintText: 'https://www.event.org',
            ),
            SizedBox(height: 16.h),

            // Copy CustomButton
            CustomButton(
              onTap: () {
              final url = urlController.text;
              Clipboard.setData(ClipboardData(text: url));
            },
              text:  'Copy',
              textColor: AppColors.white,
              borderColor: AppColors.buttonColor,
            )
          ],
        ),
      ),
    );
  }

  // Widget builder for social media icons
   _buildSocialMediaIcon(Widget image, String label, Color color) {
    return Column(
      children: [
       image,
        SizedBox(height: 8.h),
        CustomText(text: label, fontsize: 10.sp, fontWeight: FontWeight.bold),
      ],
    );
  }
}
