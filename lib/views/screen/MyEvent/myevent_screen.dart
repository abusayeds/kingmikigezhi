import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/base/bottom_menu..dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:event_sharing/views/screen/MyEvent/history/my_history_event_screen.dart';
import 'package:event_sharing/views/screen/MyEvent/today/my_today_event_screen.dart';
import 'package:event_sharing/views/screen/MyEvent/upcoming/my_upcoming_event.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/home_controller.dart';

class MyEventScreen extends StatefulWidget {
  const MyEventScreen({super.key});

  @override
  State<MyEventScreen> createState() => _MyEventScreenState();
}

class _MyEventScreenState extends State<MyEventScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    // Prefetch the community event lists once; revisit uses silent refresh.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!Get.isRegistered<HomeController>()) return;
      final home = Get.find<HomeController>();
      home.fetchTodayEvents();
      home.fetchUpcomingEvents();
      home.fetchHistoryEvents();
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(() {});
    _tabController.dispose();
    super.dispose();
  }

  Widget _tabLabel(String text, int index) {
    final selected = _tabController.index == index;
    return Tab(
      child: Container(
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.r),
            topRight: Radius.circular(10.r),
          ),
        ),
        child: Align(
          alignment: Alignment.center,
          child: CustomText(
            text: text,
            color: selected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
            fontsize: 13.sp,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: const BottomMenu(2),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 18.w),
            onPressed: () {
              Get.back();
            },
          ),
          title: Text('Event',
              style: AppStyles.fontSize18(fontWeight: FontWeight.w600)),
          centerTitle: true,
          bottom: TabBar(
            padding: EdgeInsets.symmetric(horizontal: 4.h),
            controller: _tabController,
            indicatorColor: Colors.transparent,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorWeight: 1,
            isScrollable: false,
            labelPadding: EdgeInsets.symmetric(horizontal: 2.w),
            dividerColor: const Color(0xFFC8D7DE),
            tabs: [
              _tabLabel('Today', 0),
              _tabLabel('Upcoming', 1),
              _tabLabel('History', 2),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            MyTodayEventScreen(),
            MyUpcomingEventScreen(),
            MyHistoryEventScreen(),
          ],
        ),
      ),
    );
  }
}
