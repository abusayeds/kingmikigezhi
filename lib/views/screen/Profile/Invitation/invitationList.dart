import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_sharing/controllers/invitation_controller.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../base/custom_button.dart';
import '../../../base/custom_text.dart';
import '../../../base/pull_to_refresh.dart';
import '../../../base/skeletons.dart';

class Invitationlist extends StatefulWidget {
  const Invitationlist({super.key});

  @override
  State<Invitationlist> createState() => _InvitationlistState();
}

class _InvitationlistState extends State<Invitationlist> {
  final InvitationController _invitationController =
      Get.find<InvitationController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _invitationController.fetchReceivedInvitations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
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
      body: Obx(() {
        final invitations = _invitationController.receivedInvitations;

        if (_invitationController.isLoadingReceived.value &&
            invitations.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(12),
            child: ConnectionListSkeleton(),
          );
        }

        return Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: const Text(
                      'All the people who has invited you!'),
                ),
                SizedBox(height: 8.h),
                Expanded(
                  child: invitations.isEmpty
                      ? PullToRefresh.empty(
                          onRefresh: () => _invitationController
                              .fetchReceivedInvitations(),
                          child: const Center(
                              child: Text('No invitations received')),
                        )
                      : PullToRefresh(
                          onRefresh: () => _invitationController
                              .fetchReceivedInvitations(),
                          child: ListView.builder(
                          padding: EdgeInsets.all(12.r),
                          physics: PullToRefresh.alwaysScrollable(),
                          itemCount: invitations.length,
                          itemBuilder: (context, index) {
                            final rawInvitation = invitations[index];
                            final invitation = rawInvitation is Map<String, dynamic>
                                ? rawInvitation
                                : Map<String, dynamic>.from(
                                    rawInvitation as Map);
                            final invitationId =
                                invitation['id']?.toString() ?? '';

                            // Sender info (nested structure may vary)
                            final rawSender =
                                invitation['sender'] ?? invitation['inviter'];
                            final sender = rawSender is Map<String, dynamic>
                                ? rawSender
                                : rawSender is Map
                                    ? Map<String, dynamic>.from(rawSender)
                                    : <String, dynamic>{};
                            final name =
                                '${sender['firstName'] ?? ''} ${sender['lastName'] ?? ''}'
                                    .trim();
                            final profilePicture =
                                sender['profilePicture']?.toString() ?? '';
                            final accountId =
                                sender['accountId']?.toString() ??
                                    sender['id']?.toString() ??
                                    '';
                            final contributionScore =
                                sender['contributionScore']?.toString() ??
                                    '0';

                            return Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4.h, horizontal: 8.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(10.r),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 45.r,
                                        backgroundColor:
                                            Colors.grey.shade300,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(
                                                  45.r),
                                          child: profilePicture
                                                  .isNotEmpty
                                              ? CachedNetworkImage(
                                                  imageUrl:
                                                      profilePicture,
                                                  fit: BoxFit.cover,
                                                  width: 90.r,
                                                  height: 90.r,
                                                  placeholder: (_, __) =>
                                                      Shimmer.fromColors(
                                                    baseColor: Colors.grey
                                                        .withOpacity(0.6),
                                                    highlightColor: Colors
                                                        .grey
                                                        .withOpacity(0.3),
                                                    child: Container(
                                                      width: 90.r,
                                                      height: 90.r,
                                                      color: Colors.grey
                                                          .withOpacity(0.6),
                                                    ),
                                                  ),
                                                  errorWidget: (_, __,
                                                          ___) =>
                                                      Icon(Icons.person,
                                                          size: 45.r,
                                                          color: Colors
                                                              .grey
                                                              .shade600),
                                                )
                                              : Icon(Icons.person,
                                                  size: 45.r,
                                                  color: Colors
                                                      .grey.shade600),
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            name.isEmpty
                                                ? 'Unknown'
                                                : name,
                                            style: AppStyles.fontSize16(
                                                fontWeight:
                                                    FontWeight.w600,
                                                color: AppColors
                                                    .color414141),
                                          ),
                                          SizedBox(height: 8.h),
                                          if (accountId.isNotEmpty)
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                    AppIcons
                                                        .dotIconForFamily),
                                                const SizedBox(
                                                    width: 4),
                                                Text(
                                                  'Account ID: $accountId',
                                                  style:
                                                      AppStyles.fontSize10(
                                                          color: AppColors
                                                              .color414141),
                                                ),
                                              ],
                                            ),
                                          SizedBox(height: 8.h),
                                          Row(
                                            children: [
                                              SvgPicture.asset(AppIcons
                                                  .dotIconForFamily),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Contribution: $contributionScore',
                                                style:
                                                    AppStyles.fontSize10(
                                                        color: AppColors
                                                            .color414141),
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
                                        child: CustomButton(
                                          onTap: () {
                                            _invitationController
                                                .declineInvitation(
                                                    invitationId);
                                          },
                                          text: 'Ignore',
                                          textStyle: const TextStyle(
                                              fontSize: 16,
                                              fontWeight:
                                                  FontWeight.w500),
                                          color: AppColors.fillColor,
                                          borderColor:
                                              AppColors.buttonA47059,
                                          textColor:
                                              AppColors.blackColor,
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: CustomButton(
                                          onTap: () {
                                            _invitationController
                                                .acceptInvitation(
                                                    invitationId);
                                          },
                                          text: 'Accept',
                                          textStyle: const TextStyle(
                                              fontSize: 16,
                                              fontWeight:
                                                  FontWeight.w500),
                                          color: AppColors.buttonA47059,
                                          borderColor:
                                              AppColors.buttonA47059,
                                          textColor:
                                              AppColors.textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.w),
                                    child: Divider(
                                        thickness: .5,
                                        color: AppColors.greyColor),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        ),
                ),
              ],
            ),
            // Accept All / Ignore All bottom bar
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
                        child: CustomButton(
                          onTap: () {
                            _invitationController.declineAllInvitations();
                          },
                          text: 'Ignore All',
                          textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                          color: AppColors.fillColor,
                          borderColor: AppColors.buttonColor,
                          textColor: AppColors.blackColor,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: CustomButton(
                          onTap: () {
                            _invitationController.acceptAllInvitations();
                          },
                          text: 'Accept All',
                          textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                          color: AppColors.buttonColor,
                          borderColor: AppColors.buttonA47059,
                          textColor: AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}
