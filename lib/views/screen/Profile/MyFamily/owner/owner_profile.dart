import 'package:event_sharing/controllers/family_controller.dart';
import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as TimeAgo;

import '../../../../base/custom_text.dart';

class OwnerMemberAddScreen extends StatefulWidget {
  final String? familyId;
  const OwnerMemberAddScreen({super.key, this.familyId});

  @override
  State<OwnerMemberAddScreen> createState() => _OwnerMemberAddScreenState();
}

class _OwnerMemberAddScreenState extends State<OwnerMemberAddScreen> {
  late FamilyController _familyController;

  @override
  void initState() {
    super.initState();
    _familyController = Get.find<FamilyController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.redColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20.h),
            /*    //     Top action button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 36.h,
                    width: 36.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: AppColors.buttonColor,
                    ),
                    child: InkWell(
                        onTap: (){
                          Get.toNamed(AppRoutes.createMemberProfileScreen, arguments: {'familyId': widget.familyId});
                        },
                        child: Icon(Icons.add, color: Colors.white)),
                  ),
                ),
              ],
            ),*/

            // Search bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.colorEDF2F4,
                  borderRadius: BorderRadius.all(Radius.circular(8.r)),
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
            // Family members list

            // this is the new one. i want the
            Obx(() => ListView.builder(
                  itemCount: _familyController.familyOwners.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final member = _familyController.familyOwners[index];
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
                          member.user?.email ?? '',
                          member.createdAt,
                          member.user?.profilePicture ?? '',
                          member.relationShip ?? '',
                          userId: member.userId,
                          familyMemberId: member.id,
                        ),
                      ),
                    );
                  },
                )),
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
          top: Radius.circular(40.r),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 282.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.r),
              topRight: Radius.circular(40.r),
            ),
            color: AppColors.backgroundColor,
          ),

          // padding: EdgeInsets.all(16),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.w),
            child: Column(
              children: [
                SizedBox(
                  height: 16.h,
                ),
                Container(
                  height: 3.h,
                  width: 38.w,
                  color: Color(0xFF4C7E95),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Divider(thickness: 1.w, color: AppColors.primaryColor),
                SizedBox(height: 20.h),
                Text("Delete",
                    style: AppStyles.fontSize20(
                        color: AppColors.blackColor,
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
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 58),
                          backgroundColor: AppColors.colorEDF2F4,
                          side: BorderSide(
                              width: 1, color: AppColors.primaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: AppStyles.fontSize16(
                              color: AppColors.primaryColor),
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
          ),
        );
      },
    );
  }

  _notification(
    String title,
    String phone,
    DateTime time,
    String imageUrl,
    String email, {
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
      child: GestureDetector(
        onTap: () {
          Get.toNamed(AppRoutes.ownerProfileDetailsScreen);
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
                    backgroundImage: AssetImage(imageUrl),
                    radius: 30.r,
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
                              'Phone: $phone',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 12.sp),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            SvgPicture.asset(AppIcons.dotIconForFamily,
                                width: 5.w, height: 5.h),
                            SizedBox(width: 4.w),
                            Text(
                              'Email : abac@gmail.com',
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
            ],
          ),
        ),
      ),
    );
  }

  //profile view
  void _showViewModeBottomSheet(BuildContext context) {
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
          height: 265,
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
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.ownerProfileDetailsScreen);
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
                        children: [
                          SvgPicture.asset(AppIcons.eyeIcon,
                              width: 24.w,
                              height: 24.h,
                              color: AppColors.backgroundColor),
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
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 58),
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(AppIcons.delete,
                              width: 24.w, height: 24.h),
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
            ],
          ),
        );
      },
    );
  }
  //
  // _notification(
  //     String name,
  //     DateTime time,
  //     String shorDescription,
  //     ) {
  //   return Dismissible(
  //     key: Key(name),
  //     direction: DismissDirection.endToStart,
  //     background: Container(
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(20.r),
  //         color: AppColors.colorD9A951,
  //       ),
  //       alignment: Alignment.centerRight,
  //       padding: EdgeInsets.only(right: 26.w),
  //       child: SvgPicture.asset(AppIcons.deleteIcon),
  //     ),
  //     onDismissed: (direction) async {
  //
  //       final bool? result = await _showCustomBottomSheet(context, name!);
  //       shouldRemove = result ?? false;
  //       return shouldRemove;
  //     },
  //     child: Container(
  //       padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
  //       decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(17.7.r),
  //           color: AppColors.colorEDF2F4
  //       ),
  //       child: Column(
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               children: [
  //                 Expanded(
  //                   child: Column(
  //                     mainAxisSize: MainAxisSize.min,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       // Title
  //                       CustomText(
  //                         text: title,
  //                         fontsize: 18.h,
  //                         color: AppColors.color414141,
  //                         fontWeight: FontWeight.w500,
  //                       ),
  //                       Align(
  //                         alignment: Alignment.centerLeft,
  //                         child: CustomText(
  //                           top: 2.h,
  //                           text: TimeAgo.format(time),
  //                           fontsize: 14.sp,
  //                           fontWeight: FontWeight.w400,
  //                           color: AppColors.color414141,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
