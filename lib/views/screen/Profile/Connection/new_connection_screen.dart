import 'package:event_sharing/controllers/connection_controller.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class NewInvitationScreen extends StatefulWidget {
  const NewInvitationScreen({super.key});

  @override
  State<NewInvitationScreen> createState() => _NewInvitationScreenState();
}

class _NewInvitationScreenState extends State<NewInvitationScreen> {
  late ConnectionController connectionController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    connectionController = Get.find<ConnectionController>();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (connectionController.hasMoreInvitations.value &&
          !connectionController.isLoadingInvitations.value) {
        connectionController.fetchInvitations(isRefresh: false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Stack(
        children: [
          if (connectionController.invitations.isEmpty &&
              !connectionController.isLoadingInvitations.value)
            Center(
              child: Text(
                'No invitations',
                style: AppStyles.fontSize16(color: AppColors.color414141),
              ),
            )
          else
            ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(12.r),
              itemCount: connectionController.invitations.length,
              itemBuilder: (context, index) {
                final invitation = connectionController.invitations[index];
                final requester = invitation['requester'];
                final firstName = requester['firstName'] ?? 'Unknown';
                final lastName = requester['lastName'] ?? '';
                final fullName = '$firstName $lastName'.trim();

                return Container(
                  padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
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
                            child: const Icon(Icons.person, size: 40, color: Colors.white),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fullName,
                                  style: AppStyles.fontSize16(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.color414141,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  children: [
                                    SvgPicture.asset(AppIcons.dotIconForFamily),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        requester['email'] ?? 'N/A',
                                        style: AppStyles.fontSize10(
                                          color: AppColors.color414141,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  children: [
                                    SvgPicture.asset(AppIcons.dotIconForFamily),
                                    const SizedBox(width: 4),
                                    Text(
                                      "Username: ${requester['username'] ?? 'N/A'}",
                                      style: AppStyles.fontSize10(
                                        color: AppColors.color414141,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              onTap: () {
                                connectionController
                                    .rejectConnection(invitation['id']);
                              },
                              text: 'Ignore',
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              color: AppColors.fillColor,
                              borderColor: AppColors.buttonA47059,
                              textColor: AppColors.blackColor,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: CustomButton(
                              onTap: () {
                                connectionController
                                    .acceptConnection(invitation['id']);
                              },
                              text: 'Accept',
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              color: AppColors.buttonA47059,
                              borderColor: AppColors.buttonA47059,
                              textColor: AppColors.textColor,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Divider(
                          thickness: 0.5,
                          color: AppColors.greyColor,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          if (connectionController.invitations.isNotEmpty)
            Positioned(
              bottom: 15,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.all(12.r),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        onTap: () {
                          connectionController.rejectAllConnections();
                        },
                        text: 'Ignore All',
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        color: AppColors.fillColor,
                        borderColor: AppColors.buttonColor,
                        textColor: AppColors.blackColor,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: CustomButton(
                        onTap: () {
                          connectionController.acceptAllConnections();
                        },
                        text: 'Accept All',
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        color: AppColors.buttonColor,
                        borderColor: AppColors.buttonA47059,
                        textColor: AppColors.textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (connectionController.isLoadingInvitations.value)
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              ),
            ),
        ],
      )),
    );
  }
}
