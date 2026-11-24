import 'package:event_sharing/controllers/family_controller.dart';
import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/utils/media_url_utils.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/base/custom_network_image.dart';
import 'package:event_sharing/views/base/pull_to_refresh.dart';
import 'package:event_sharing/views/base/skeletons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class FamilyGroupScreen extends StatefulWidget {
  const FamilyGroupScreen({super.key});

  @override
  State<FamilyGroupScreen> createState() => _FamilyGroupScreenState();
}

class _FamilyGroupScreenState extends State<FamilyGroupScreen> {
  late FamilyController _familyController;

  @override
  void initState() {
    super.initState();
    _familyController = Get.find<FamilyController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _familyController.fetchFamilies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 18.w),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'My Family',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 8.w, top: 14.h),
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
                          Get.toNamed(AppRoutes.createFamilyGroup);
                        },
                        child: const Icon(Icons.add, color: Colors.white)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 11.h),
            Expanded(
              child: _buildFamilyContent(),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildFamilyContent() {
    if (_familyController.isLoading.value &&
        _familyController.families.isEmpty) {
      return const ConnectionListSkeleton();
    }

    if (_familyController.families.isEmpty) {
      return PullToRefresh.empty(
        onRefresh: () => _familyController.fetchFamilies(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.family_restroom, size: 64, color: Colors.grey),
              SizedBox(height: 16.h),
              const Text(
                'No families yet',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 8.h),
              const Text(
                'Create your first family',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return PullToRefresh(
      onRefresh: () => _familyController.fetchFamilies(),
      child: SingleChildScrollView(
      physics: PullToRefresh.alwaysScrollable(),
      child: Column(
        children: [
          ListView.builder(
            itemCount: _familyController.families.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final family = _familyController.families[index];
              return Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.colorD9A951,
                  ),
                  child: _notification(
                    family.name,
                    family.createdAt,
                    MediaUrlUtils.resolve(family.imageUrl) ?? '',
                    family.description ?? '',
                    familyId: family.id,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 16.h),
          if (_familyController.hasNext || _familyController.hasPrev)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_familyController.hasPrev)
                    ElevatedButton(
                      onPressed: () => _familyController.loadPreviousPage(),
                      child: const Text('Previous'),
                    ),
                  SizedBox(width: 16.w),
                  Text(
                    'Page ${_familyController.currentPage}/${_familyController.totalPages}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  SizedBox(width: 16.w),
                  if (_familyController.hasNext)
                    ElevatedButton(
                      onPressed: () => _familyController.loadNextPage(),
                      child: const Text('Next'),
                    ),
                ],
              ),
            ),
          SizedBox(height: 20.h),
        ],
      ),
    ),
    );
  }

  Widget _notification(
    String title,
    DateTime time,
    String imageUrl,
    String relation, {
    required String familyId,
  }) {
    return Dismissible(
      key: Key(familyId),
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
      confirmDismiss: (direction) async {
        final bool? result = await _showCustomBottomSheet(context, title);
        return result ?? false;
      },
      onDismissed: (direction) {
        _familyController.deleteFamily(familyId);
      },
      child: GestureDetector(
        onTap: () {
          Get.toNamed(AppRoutes.myFamilyScreen,
              arguments: {'familyId': familyId});
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
                  CustomNetworkImage(
                    imageUrl: imageUrl,
                    height: 60.r,
                    width: 60.r,
                    boxShape: BoxShape.circle,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        if (relation.isNotEmpty)
                          Row(
                            children: [
                              SvgPicture.asset(
                                AppIcons.dotIconForFamily,
                                width: 5.w,
                                height: 5.h,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                relation,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.sp,
                                ),
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
                    _showViewModeBottomSheet(context, title, familyId);
                  },
                  child: Icon(Icons.more_horiz,
                      color: AppColors.color8C8C8C, size: 20.sp),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _showCustomBottomSheet(BuildContext context, String name) {
    return showModalBottomSheet<bool>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.w),
          height: 180.h,
          child: Column(
            children: [
              Text(
                'Remove $name?',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child:
                          const Text('Cancel', style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child:
                          const Text('Remove', style: TextStyle(color: Colors.white)),
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

  void _showViewModeBottomSheet(
      BuildContext context, String memberName, String familyId) {
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
          height: 320,
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
                        Get.back();
                        Get.toNamed(AppRoutes.updateFamilyGroup,
                            arguments: {'familyId': familyId});
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 58),
                        backgroundColor: AppColors.primaryColor,
                        side: BorderSide(width: 1, color: AppColors.greyColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              AppIcons.eyeIcon,
                              width: 18.w,
                              height: 18.h,
                              color: Colors.white,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Update Family',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppStyles.fontSize12(
                                  color: AppColors.backgroundColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Get.back();
                        final bool? result =
                            await _showCustomBottomSheet(context, memberName);
                        if (result == true) {
                          _familyController.deleteFamily(familyId);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 58),
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              AppIcons.delete,
                              width: 18.w,
                              height: 18.h,
                              color: Colors.white,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Delete Family',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppStyles.fontSize12(
                                  color: AppColors.backgroundColor),
                            ),
                          ],
                        ),
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
}
