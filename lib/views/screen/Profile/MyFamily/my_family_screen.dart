import 'package:event_sharing/controllers/family_controller.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:event_sharing/views/screen/Profile/MyFamily/member/member_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'owner/owner_profile.dart';

class MyFamilyScreen extends StatefulWidget {
  const MyFamilyScreen({super.key});

  @override
  State<MyFamilyScreen> createState() => _MyFamilyScreenState();
}

class _MyFamilyScreenState extends State<MyFamilyScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late FamilyController _familyController;
  String? familyId;

  @override
  void initState() {
    super.initState();
    _familyController = Get.find<FamilyController>();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      familyId = Get.arguments?['familyId'];
      if (familyId != null) {
        _loadData();
      }
    });
  }

  void _loadData() async {
    print('DEBUG: Loading family members for familyId: $familyId');
    await _familyController.fetchFamilyMembers(familyId!);
    print('DEBUG: Members fetched: ${_familyController.familyMembers.length}');
    await _familyController.fetchFamilyMembers(familyId!, isOwner: true);
    print('DEBUG: Owners fetched: ${_familyController.familyOwners.length}');
  }

  @override
  void dispose() {
    _tabController.removeListener(() {});
    _tabController.dispose();
    super.dispose();
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
        title: Text('My Family',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.transparent,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorWeight: 1,
          dividerColor: Color(0xFFC8D7DE),
          tabs: [
            Tab(
              child: Container(
                decoration: BoxDecoration(
                  color: _tabController.index == 0
                      ? AppColors.primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.r),
                      topRight: Radius.circular(10.r)),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: GetBuilder<FamilyController>(
                    builder: (controller) => CustomText(
                      text: 'Member(${controller.familyMembers.length})',
                      color: _tabController.index == 0
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.w500,
                      fontsize: 14.sp,
                    ),
                  ),
                ),
              ),
            ),
            Tab(
              child: Container(
                decoration: BoxDecoration(
                  color: _tabController.index == 1
                      ? AppColors.primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.r),
                      topRight: Radius.circular(10.r)),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: GetBuilder<FamilyController>(
                    builder: (controller) => CustomText(
                      text: 'Owner (${controller.familyOwners.length})',
                      color: _tabController.index == 1
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.w500,
                      fontsize: 14.sp,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 8.w),
        child: TabBarView(
          controller: _tabController,
          children: [
            MyFamilyMemberAddScreen(familyId: familyId),
            OwnerMemberAddScreen(familyId: familyId),
          ],
        ),
      ),
    );
  }
}
