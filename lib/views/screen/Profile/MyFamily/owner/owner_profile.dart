import 'package:event_sharing/controllers/family_controller.dart';
import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/models/family_model.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/base/skeletons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OwnerMemberAddScreen extends StatefulWidget {
  final String? familyId;
  const OwnerMemberAddScreen({super.key, this.familyId});

  @override
  State<OwnerMemberAddScreen> createState() => _OwnerMemberAddScreenState();
}

class _OwnerMemberAddScreenState extends State<OwnerMemberAddScreen> {
  late FamilyController _familyController;
  final TextEditingController _searchController = TextEditingController();
  final RxString _searchQuery = ''.obs;

  @override
  void initState() {
    super.initState();
    _familyController = Get.find<FamilyController>();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Name / username / email wise filter (case-insensitive).
  List<FamilyMemberModel> get _visibleOwners {
    final query = _searchQuery.value.trim().toLowerCase();
    final all = _familyController.familyOwners;
    if (query.isEmpty) return all.toList();
    return all.where((member) {
      final first = member.user?.firstName ?? '';
      final last = member.user?.lastName ?? '';
      final username = member.user?.username ?? '';
      final email = member.user?.email ?? '';
      return '$first $last'.toLowerCase().contains(query) ||
          username.toLowerCase().contains(query) ||
          email.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20.h),
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
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    onChanged: (value) => _searchQuery.value = value,
                    decoration: InputDecoration(
                      hintText: 'Search Name',
                      hintStyle: TextStyle(color: AppColors.greyColor),
                      border: InputBorder.none,
                      suffixIcon: Obx(
                        () => _searchQuery.value.isEmpty
                            ? Icon(Icons.search, color: AppColors.primaryColor)
                            : InkWell(
                                onTap: () {
                                  _searchController.clear();
                                  _searchQuery.value = '';
                                  FocusScope.of(context).unfocus();
                                },
                                child: Icon(Icons.close,
                                    color: AppColors.primaryColor),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Obx(() {
              if (_familyController.isLoading.value) {
                return Padding(
                  padding: EdgeInsets.all(20.h),
                  child: const ConnectionListSkeleton(itemCount: 4),
                );
              }

              final owners = _visibleOwners;

              if (owners.isEmpty) {
                final isSearching = _searchQuery.value.trim().isNotEmpty;
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.h),
                    child: Column(
                      children: [
                        Icon(isSearching ? Icons.search_off : Icons.person_off,
                            size: 50.h, color: AppColors.greyColor),
                        SizedBox(height: 10.h),
                        Text(
                          isSearching
                              ? 'No owner matches "${_searchQuery.value.trim()}"'
                              : 'No owners found',
                          textAlign: TextAlign.center,
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
                itemCount: owners.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final member = owners[index];
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
                  color: const Color(0xFF4C7E95),
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
                          minimumSize: const Size(double.infinity, 58),
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
                          minimumSize: const Size(double.infinity, 58),
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
    String email,
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
      child: GestureDetector(
        onTap: () {
          final owner = _familyController.familyOwners.firstWhere(
            (o) => '${o.user?.firstName} ${o.user?.lastName}' == title,
            orElse: () => _familyController.familyOwners.first,
          );
          Get.toNamed(AppRoutes.ownerProfileDetailsScreen,
              arguments: {'userId': owner.userId});
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
                            Expanded(
                              child: Text(
                                email.isNotEmpty ? email : 'N/A',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp),
                                overflow: TextOverflow.ellipsis,
                              ),
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
          padding: const EdgeInsets.all(16),
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
                        minimumSize: const Size(double.infinity, 58),
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
                        minimumSize: const Size(double.infinity, 58),
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
