import 'package:event_sharing/controllers/invitation_controller.dart';
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
  const ShareInvitationPage({super.key});

  @override
  State<ShareInvitationPage> createState() => _ShareInvitationPageState();
}

class _ShareInvitationPageState extends State<ShareInvitationPage> {
  final InvitationController _invitationController =
      Get.find<InvitationController>();

  final TextEditingController messageController = TextEditingController();
  final TextEditingController urlController = TextEditingController();

  // Arguments from MyInvitationPage
  String get _eventId => Get.arguments?['eventId'] ?? '';
  List<String> get _inviteeIds =>
      (Get.arguments?['inviteeIds'] as List<String>?) ?? [];

  @override
  void dispose() {
    messageController.dispose();
    urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(left: 12.w),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: Colors.black, size: 18.w),
            onPressed: () => Get.back(),
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
          children: [
            CustomTextField(
              controller: messageController,
              hintText: 'Message (60 words)',
              maxLines: 8,
            ),
            SizedBox(height: 24.h),
            // Social media icons row (UI only — no change)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSocialMediaIcon(
                    Image.asset(AppImages.message,
                        width: 60.w, height: 60.h),
                    'iMessage'),
                _buildSocialMediaIcon(
                    Image.asset(AppImages.whatsapp,
                        width: 60.w, height: 60.h),
                    'WhatsApp'),
                _buildSocialMediaIcon(
                    Image.asset(AppImages.email,
                        width: 60.w, height: 60.h),
                    'Gmail'),
                _buildSocialMediaIcon(
                    Image.asset(AppImages.instagram,
                        width: 60.w, height: 60.h),
                    'Instagram'),
              ],
            ),
            SizedBox(height: 24.h),
            CustomTextField(
              borderColor: AppColors.buttonColor,
              controller: urlController,
              hintText: 'https://www.event.org',
            ),
            SizedBox(height: 16.h),
            // Copy button
            CustomButton(
              onTap: () {
                Clipboard.setData(
                    ClipboardData(text: urlController.text));
              },
              text: 'Copy',
              textColor: AppColors.white,
              borderColor: AppColors.buttonColor,
            ),
            SizedBox(height: 16.h),
            // Send Invitation button
            Obx(() => CustomButton(
                  onTap: _eventId.isEmpty
                      ? () {}
                      : () async {
                          final success = await _invitationController
                              .sendInvitations(
                            eventId: _eventId,
                            inviteeIds: _inviteeIds,
                            message: messageController.text.trim(),
                          );
                          if (success) Get.back();
                        },
                  text: 'Send Invitation',
                  color: _eventId.isEmpty
                      ? AppColors.greyColor
                      : AppColors.buttonA47059,
                  borderColor: AppColors.buttonA47059,
                  textColor: AppColors.textColor,
                  loading: _invitationController.isSending.value,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaIcon(Widget image, String label) {
    return Column(
      children: [
        image,
        SizedBox(height: 8.h),
        CustomText(
            text: label, fontsize: 10.sp, fontWeight: FontWeight.bold),
      ],
    );
  }
}
