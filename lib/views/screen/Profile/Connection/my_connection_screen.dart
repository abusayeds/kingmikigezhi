import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:event_sharing/views/screen/Profile/Connection/added_connection_screen.dart';
import 'package:event_sharing/views/screen/Profile/Connection/new_invitations_screen.dart';
import 'package:event_sharing/views/screen/Profile/MyFamily/member/member_profile.dart';
import 'package:event_sharing/views/screen/Profile/MyFamily/owner/owner_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class MyConnectionScreen extends StatefulWidget {
  const MyConnectionScreen({super.key});

  @override
  State<MyConnectionScreen> createState() => _MyConnectionScreenState();
}

class _MyConnectionScreenState extends State<MyConnectionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        // bottomNavigationBar: const UserBottomMenu(2),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Connection',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600)),
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
                      text: 'New Invitations(300)',
                      color: _tabController.index == 0
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ),
              //========================> Tab 01  <====================
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
                      text:  'Connections(300)',
                      color: _tabController.index == 1
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
          children: const [
            NewInvitationScreen(),
            AddedConneectionScreen(),
          ],
        ),
      ),
    );
  }
}
