import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_sharing/controllers/invitation_controller.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

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
  final InvitationController _invitationController =
      Get.find<InvitationController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _invitationController.fetchReceivedInvitations();
    });
  }

  // Derive an eventId for accept-all/decline-all from first invitation
  String get _eventId {
    final list = _invitationController.receivedInvitations;
    if (list.isEmpty) return '';
    return list.first['eventId'] as String? ?? '';
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
      body: Obx(() {
        if (_invitationController.isLoadingReceived.value) {
          return const Center(child: CircularProgressIndicator());
        }


        final invitations = _invitationController.receivedInvitations;

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
                      ? const Center(
                          child: Text('No invitations received'))
                      : ListView.builder(
                          padding: EdgeInsets.all(12.r),
                          itemCount: invitations.length,
                          itemBuilder: (context, index) {
                            final invitation = invitations[index]
                                as Map<String, dynamic>;
                            final invitationId =
                                invitation['id'] as String? ?? '';

                            // Sender info (nested structure may vary)
                            final sender =
                                invitation['sender'] as Map<String, dynamic>?
                                    ?? invitation['inviter'] as Map<String, dynamic>?
                                    ?? {};
                            final name =
                                '${sender['firstName'] ?? ''} ${sender['lastName'] ?? ''}'
                                    .trim();
                            final profilePicture =
                                sender['profilePicture'] as String? ?? '';
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
                            if (_eventId.isNotEmpty) {
                              _invitationController
                                  .declineAllInvitations(_eventId);
                            }
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
                            if (_eventId.isNotEmpty) {
                              _invitationController
                                  .acceptAllInvitations(_eventId);
                            }
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
