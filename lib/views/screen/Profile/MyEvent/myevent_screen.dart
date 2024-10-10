import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:event_sharing/views/screen/Profile/MyEvent/history/my_history_event_screen.dart';
import 'package:event_sharing/views/screen/Profile/MyEvent/today/my_today_event_screen.dart';
import 'package:event_sharing/views/screen/Profile/MyEvent/upcoming/my_upcoming_event.dart';
import 'package:event_sharing/views/screen/UpComingEvent/upcoming_event_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../MyFamily/member/member_profile.dart';



class MyEventScreen extends StatefulWidget {
   MyEventScreen({super.key});

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
  }

  @override
  void dispose() {
    _tabController.removeListener(() {});
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        // bottomNavigationBar: const UserBottomMenu(2),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('My Event',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600)),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.transparent,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: [
              //========================> Tab 01  <====================
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    color: _tabController.index == 0
                        ?  AppColors.primaryColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.r),
                        topRight: Radius.circular(10.r)),
                    // border: Border.all(color: const Color(0xFFBD9A73)),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: CustomText(
                      text: 'Today',
                      color: _tabController.index == 0
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ),
              //========================> Tab 02  <====================
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    color: _tabController.index == 1
                        ? AppColors.primaryColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.r),
                        topRight: Radius.circular(10.r)),
                    //border: Border.all(color: const Color(0xFFBD9A73)),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: CustomText(
                      text:  'Upcoming',
                      color: _tabController.index == 1
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ),
              //========================> Tab 03  <====================
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    color: _tabController.index == 2
                        ? AppColors.primaryColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.r),
                        topRight: Radius.circular(10.r)),
                    //border: Border.all(color: const Color(0xFFBD9A73)),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: CustomText(
                      text:  'History',
                      color: _tabController.index == 2
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            MyTodayEventScreen(),
            MyUpcomingEventScreen(),
            MyHistoryEventScreen(),
          ],
        ),
      ),
    );
  }
}
