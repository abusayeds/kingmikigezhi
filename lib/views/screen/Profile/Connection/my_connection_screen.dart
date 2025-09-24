import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:event_sharing/views/screen/Profile/Connection/remove_connection_screen.dart';
import 'package:event_sharing/views/screen/Profile/Connection/new_connection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


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
          title:  Text('Connection',style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.bold)),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: Colors.black, size: 18.w),
            onPressed: () {
              Get.back();
            },
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.transparent,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorWeight: 1,
            //dividerColor: Color(0xFFFFFFFF),
            dividerColor: Color(0xFFC8D7DE),
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
                      text: 'New Invitations(30)',
                      color: _tabController.index == 0
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.w500,
                      fontsize: 14.sp,
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
                      text:  'Connections(30)',
                      color: _tabController.index == 1
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.w500,
                      fontsize: 14.sp,
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
