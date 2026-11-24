import 'package:event_sharing/controllers/invitation_controller.dart';
import 'package:event_sharing/helpers/app_feedback.dart';
import 'package:event_sharing/helpers/event_actions.dart';
import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_images.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:event_sharing/views/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  Map<String, dynamic> get _args {
    final raw = Get.arguments;
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return <String, dynamic>{};
  }

  String get _eventId => _args['eventId']?.toString() ?? '';
  String get _eventLink => _args['eventLink']?.toString() ?? '';
  String get _eventTitle => _args['eventTitle']?.toString() ?? 'Event';
  List<String> get _inviteeIds =>
      List<String>.from(_args['inviteeIds'] ?? const <String>[]);

  @override
  void initState() {
    super.initState();
    // Auto-fill link only; message stays empty for the user to type.
    messageController.clear();
    final link = _eventLink.trim();
    urlController.text = link.isNotEmpty ? link : '';
  }

  @override
  void dispose() {
    messageController.dispose();
    urlController.dispose();
    super.dispose();
  }

  Future<void> _shareVia(String channel) async {
    final typedMessage = messageController.text.trim();
    if (typedMessage.isEmpty) {
      Fluttertoast.showToast(msg: 'Type a message first');
      return;
    }
    // Share only what the user typed — no prefilled invite/link text.
    await shareEventViaChannel(
      channel: channel,
      eventTitle: _eventTitle,
      eventLink: urlController.text.trim(),
      customMessage: typedMessage,
    );
  }

  Future<void> _sendInvitationAndLeave() async {
    if (_inviteeIds.isEmpty) {
      AppFeedback.validation('Select at least one person to invite.');
      return;
    }

    final success = await _invitationController.sendInvitations(
      eventId: _eventId,
      inviteeIds: _inviteeIds,
      message: messageController.text.trim(),
    );
    if (!success || !mounted) return;

    // Leave invitation screens and return to Home (clear success confirmation).
    Get.until((route) {
      final name = route.settings.name;
      return name == AppRoutes.homeScreen ||
          name == AppRoutes.myEventScreen ||
          route.isFirst;
    });

    Future.microtask(() {
      AppFeedback.success(
        'Invitation sent successfully.',
        title: 'Sent',
      );
    });
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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          children: [
            CustomTextField(
              controller: messageController,
              hintText: 'Message (60 words)',
              maxLines: 8,
            ),
            SizedBox(height: 24.h),
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
            CustomButton(
              onTap: () {
                final text = urlController.text.trim().isNotEmpty
                    ? urlController.text.trim()
                    : messageController.text.trim();
                if (text.isEmpty) {
                  Fluttertoast.showToast(msg: 'Nothing to copy');
                  return;
                }
                Clipboard.setData(ClipboardData(text: text));
                Fluttertoast.showToast(msg: 'Copied');
              },
              text: 'Copy',
              textColor: AppColors.white,
              borderColor: AppColors.buttonColor,
            ),
            SizedBox(height: 16.h),
            Obx(() => CustomButton(
                  onTap: _eventId.isEmpty
                      ? () {
                          AppFeedback.validation(
                            'Missing event. Open share from an event.',
                          );
                        }
                      : _sendInvitationAndLeave,
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
    return GestureDetector(
      onTap: () => _shareVia(label),
      child: Column(
        children: [
          image,
          SizedBox(height: 8.h),
          CustomText(
              text: label, fontsize: 10.sp, fontWeight: FontWeight.bold),
        ],
      ),
    );
  }
}
