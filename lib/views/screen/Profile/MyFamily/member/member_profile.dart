import 'package:event_sharing/controllers/family_controller.dart';
import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MyFamilyMemberAddScreen extends StatefulWidget {
  final String? familyId;
  const MyFamilyMemberAddScreen({super.key, this.familyId});

  @override
  State<MyFamilyMemberAddScreen> createState() =>
      _MyFamilyMemberAddScreenState();
}

class _MyFamilyMemberAddScreenState extends State<MyFamilyMemberAddScreen> {
  late FamilyController _familyController;

  @override
  void initState() {
    super.initState();
    _familyController = Get.find<FamilyController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 11.h),
            Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 36.h,
                    width: 36.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30.r)),
                      color: AppColors.buttonColor,
                    ),
                    child: InkWell(
                        onTap: () {
                          Get.toNamed(AppRoutes.createMemberProfileScreen,
                              arguments: {'familyId': widget.familyId});
                        },
                        child: const Icon(Icons.add, color: Colors.white)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.colorEDF2F4,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: AppColors.primaryColor, width: 1.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search Name',
                      hintStyle: TextStyle(color: AppColors.greyColor),
                      border: InputBorder.none,
                      suffixIcon:
                          Icon(Icons.search, color: AppColors.primaryColor),
                    ),
                  ),
                ),
              ),
            ),
            Obx(() {
              if (_familyController.isLoading.value) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.h),
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  ),
                );
              }

              if (_familyController.familyMembers.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.h),
                    child: Column(
                      children: [
                        Icon(Icons.person_off,
                            size: 50.h, color: AppColors.greyColor),
                        SizedBox(height: 10.h),
                        Text(
                          'No members found',
                          style: TextStyle(
                            color: AppColors.greyColor,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: _familyController.familyMembers.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final member = _familyController.familyMembers[index];
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.colorD9A951,
                      ),
                      child: _notification(
                        member.user != null
                            ? '${member.user!.firstName} ${member.user!.lastName}'
                            : '',
                        member.createdAt,
                        member.user?.profilePicture ?? '',
                        member.relationShip ?? 'Member',
                        userId: member.userId,
                        familyMemberId: member.id,
                      ),
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  //=========================>>>>> Delete Custom BottomSheet    <<<================================
  Future<bool?> _showCustomBottomSheet(
      BuildContext context, String memberName) {
    return showModalBottomSheet<bool>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.r),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
            color: AppColors.backgroundColor,
          ),
          height: 265,
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Divider(thickness: 1, color: AppColors.greyColor),
              SizedBox(height: 20.h),
              Text("Delete",
                  style: AppStyles.fontSize20(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600)),
              Text(
                "Are you sure to delete this?",
                style: AppStyles.fontSize18(color: AppColors.borderColor),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back(); // Close the bottom sheet
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 58),
                        backgroundColor: AppColors.colorEDF2F4,
                        side:
                            BorderSide(width: 1, color: AppColors.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style:
                            AppStyles.fontSize16(color: AppColors.primaryColor),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 58),
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                      ),
                      child: Text(
                        'Yes',
                        style: AppStyles.fontSize16(
                            color: AppColors.backgroundColor),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  _notification(
    String title,
    DateTime time,
    String imageUrl,
    String relation, {
    String? userId,
    String? familyMemberId,
  }) {
    return Dismissible(
      key: Key(familyMemberId ?? title),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(21.r),
          color: AppColors.colorD9A951,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 26.w),
        child: SvgPicture.asset(AppIcons.deleteIcon),
      ),
      // Use confirmDismiss to show confirmation dialog
      confirmDismiss: (direction) async {
        final bool? result = await _showCustomBottomSheet(context, title);
        return result ?? false; // Return true to dismiss, false to cancel
      },
      // onDismissed is called only when the item is actually dismissed
      onDismissed: (direction) async {
        if (widget.familyId != null && userId != null) {
          await _familyController.removeFamilyMember(
            familyId: widget.familyId!,
            userId: userId,
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.colorEDF2F4,
          borderRadius: BorderRadius.circular(17.r),
          border: Border.all(color: Colors.black12, width: 1.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: imageUrl.isNotEmpty
                      ? CachedNetworkImageProvider(imageUrl)
                      : null,
                  radius: 30.r,
                  backgroundColor: AppColors.colorEDF2F4,
                  child: imageUrl.isEmpty
                      ? Icon(Icons.person,
                          size: 30.r, color: AppColors.greyColor)
                      : null,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16.sp),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          SvgPicture.asset(AppIcons.dotIconForFamily,
                              width: 5.w, height: 5.h),
                          SizedBox(width: 4.w),
                          Text(
                            relation,
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 12.sp),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: -5,
              right: 0,
              child: InkWell(
                onTap: () {
                  _showViewModeBottomSheet(context, title);
                },
                child: Icon(Icons.more_horiz,
                    color: AppColors.color8C8C8C, size: 20.sp),
              ),
            )
          ],
        ),
      ),
    );
  }

  //profile view
  void _showViewModeBottomSheet(BuildContext context, String memberName) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.r),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
            color: AppColors.backgroundColor,
          ),
          height: 320, // increased height
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Divider(thickness: 1, color: AppColors.greyColor),
              SizedBox(height: 20.h),

              Text(
                "What you want?",
                style: AppStyles.fontSize18(color: AppColors.borderColor),
              ),

              SizedBox(height: 20.h),

              /// 🔹 First Row (2 buttons)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.memberProfileDetailsScreen,
                            arguments: {
                              'userId': _familyController.familyMembers
                                  .firstWhere(
                                      (m) =>
                                          '${m.user?.firstName} ${m.user?.lastName}' ==
                                          memberName,
                                      orElse: () =>
                                          _familyController.familyMembers.first)
                                  .userId
                            });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 58),
                        backgroundColor: AppColors.primaryColor,
                        side: BorderSide(width: 1, color: AppColors.greyColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            AppIcons.eyeIcon,
                            width: 24.w,
                            height: 24.h,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'View Profile',
                            style: AppStyles.fontSize14(
                                color: AppColors.backgroundColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Get.back(); // close option sheet first

                        final bool? result =
                            await _showCustomBottomSheet(context, memberName);

                        if (result == true && widget.familyId != null) {
                          // Get userId from the member by name
                          final member =
                              _familyController.familyMembers.firstWhere(
                            (m) =>
                                '${m.user?.firstName} ${m.user?.lastName}' ==
                                memberName,
                            orElse: () => _familyController.familyMembers.first,
                          );
                          if (member.userId.isNotEmpty) {
                            await _familyController.removeFamilyMember(
                              familyId: widget.familyId!,
                              userId: member.userId,
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 58),
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            AppIcons.delete,
                            width: 24.w,
                            height: 24.h,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'Delete Profile',
                            style: AppStyles.fontSize14(
                                color: AppColors.backgroundColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 15.h),

              /// 🔹 Second Row (Add Owner Button - full width)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    Get.back();
                    if (widget.familyId != null) {
                      final member = _familyController.familyMembers.firstWhere(
                        (m) =>
                            '${m.user?.firstName} ${m.user?.lastName}' ==
                            memberName,
                        orElse: () => _familyController.familyMembers.first,
                      );
                      if (member.userId.isNotEmpty) {
                        await _familyController.makeOwner(
                          familyId: widget.familyId!,
                          newOwnerUserId: member.userId,
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 58),
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_circle_outlined,
                        color: Colors.white,
                        size: 20.h,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Make Owner',
                        style: AppStyles.fontSize14(
                            color: AppColors.backgroundColor),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
