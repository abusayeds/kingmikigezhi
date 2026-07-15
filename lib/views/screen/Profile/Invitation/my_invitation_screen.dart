import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_sharing/controllers/auth_controller.dart';
import 'package:event_sharing/controllers/invitation_controller.dart';
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
  const MyInvitationPage({super.key});

  @override
  State<MyInvitationPage> createState() => _MyInvitationPageState();
}

class _MyInvitationPageState extends State<MyInvitationPage> {
  final InvitationController _invitationController =
      Get.find<InvitationController>();
  final AuthController _authController = Get.find<AuthController>();

  // eventId passed via Get.arguments (optional)
  String get _eventId => Get.arguments?['eventId'] ?? '';

  // Tracks which connection IDs are checked
  final Set<String> _selectedIds = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _invitationController.fetchMyConnections();
    });
  }

  String get _currentUserId =>
      _authController.userProfile.value?['id'] ?? '';

  void _toggleCheckbox(String userId, bool? value) {
    setState(() {
      if (value == true) {
        _selectedIds.add(userId);
      } else {
        _selectedIds.remove(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(left: 24.w),
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
            Expanded(
              child: Obx(() {
                if (_invitationController.isLoadingConnections.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (_invitationController.myConnections.isEmpty) {
                  return const Center(
                      child: Text('No connections found'));
                }
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: _invitationController.myConnections.length,
                  itemBuilder: (context, index) {
                    final connection =
                        _invitationController.myConnections[index]
                            as Map<String, dynamic>;
                    final peer = _invitationController
                        .getConnectionPeer(connection, _currentUserId);
                    final userId = peer['id'] as String? ?? '';
                    final name =
                        '${peer['firstName'] ?? ''} ${peer['lastName'] ?? ''}'
                            .trim();
                    final location =
                        peer['location'] as String? ?? 'Unknown location';
                    final profilePicture =
                        peer['profilePicture'] as String? ?? '';

                    // Avatar background colors cycling
                    final colors = [
                      AppColors.color67AB9F,
                      AppColors.colorE5CCFF,
                      AppColors.colorCCFFE6,
                      AppColors.colorFFF2CC,
                      const Color(0xFFd9d9d9),
                    ];
                    final avatarColor = colors[index % colors.length];

                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        children: [
                          // Avatar
                          Container(
                            height: 64.w,
                            width: 64.w,
                            decoration: BoxDecoration(
                              color: avatarColor,
                              borderRadius:
                                  BorderRadius.circular(100.r),
                            ),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(100.r),
                              child: profilePicture.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: profilePicture,
                                      fit: BoxFit.cover,
                                      errorWidget: (_, __, ___) =>
                                          Icon(Icons.person,
                                              size: 32.w,
                                              color: Colors.white),
                                    )
                                  : Icon(Icons.person,
                                      size: 32.w, color: Colors.white),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          // Name + location
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Text(
                                  name.isEmpty ? 'Unknown' : name,
                                  style: AppStyles.fontSize14(
                                    color: AppColors.color414141,
                                    fontWeight: FontWeight.w500,
                                  ).copyWith(fontSize: 15.sp),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  location,
                                  style: GoogleFonts.poppins(
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.color414141,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Checkbox
                          Checkbox(
                            activeColor: AppColors.primaryColor,
                            side: BorderSide(
                              color: AppColors.primaryColor,
                              width: 1.w,
                            ),
                            value: _selectedIds.contains(userId),
                            onChanged: userId.isNotEmpty
                                ? (v) => _toggleCheckbox(userId, v)
                                : null,
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
            // Share button — navigates to share page with selected IDs
            Obx(() => CustomButton(
                  onTap: _selectedIds.isEmpty
                      ? () {}
                      : () {
                          Get.toNamed(
                            AppRoutes.shareInvitationPage,
                            arguments: {
                              'eventId': _eventId,
                              'inviteeIds': _selectedIds.toList(),
                            },
                          );
                        },
                  text: 'Share',
                  borderColor: AppColors.buttonA47059,
                  color: _selectedIds.isEmpty
                      ? AppColors.greyColor
                      : AppColors.buttonA47059,
                  textColor: AppColors.textColor,
                  loading: _invitationController.isSending.value,
                )),
            SizedBox(height: 41.h),
          ],
        ),
      ),
    );
  }
}
