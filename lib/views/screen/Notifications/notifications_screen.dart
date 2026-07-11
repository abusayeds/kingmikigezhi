import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as TimeAgo;
import '../../../controllers/notification_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icons.dart';
import '../../base/custom_text.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationController _notificationController = Get.find<NotificationController>();

  @override
  void initState() {
    super.initState();
    _notificationController.getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //================================> App bar section <=======================
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 20.sp,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: Align(
                child: Obx(() {
                  final count = _notificationController.unreadCount.value;
                  return CustomText(
                    text: 'Notification($count)',
                    fontsize: 18.sp,
                    fontWeight: FontWeight.w500,
                  );
                }),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),

      //================================> Body section <=======================
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //================================> Notification section <=======================

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await _notificationController.markAllAsRead();
                    },
                    child: Text(
                      'Ignore All',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (_notificationController.isLoading.value &&
                    _notificationController.notifications.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (_notificationController.notifications.isEmpty) {
                  return Center(
                    child: Text(
                      'No notifications yet',
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: _notificationController.notifications.length,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final notification = _notificationController.notifications[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.w),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: notification.isRead == true
                              ? AppColors.colorEDF2F4
                              : AppColors.colorD9A951,
                        ),
                        child: _notification(
                          notification.title ?? '',
                          notification.createdAt ?? DateTime.now(),
                          notification.message ?? '',
                          isRead: notification.isRead ?? false,
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  _notification(
      String title,
      DateTime time,
      String shorDescription,
      {bool isRead = false}) {
    return Dismissible(
      key: Key(title + time.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: AppColors.colorD9A951,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 26.w),
        child: SvgPicture.asset(AppIcons.deleteIcon),
      ),
      onDismissed: (direction) {},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17.7.r),
          color: isRead ? AppColors.colorEDF2F4 : AppColors.colorD9A951,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        CustomText(
                          text: title,
                          fontsize: 18.h,
                          color: AppColors.color414141,
                          fontWeight: FontWeight.w500,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            top: 2.h,
                            text: TimeAgo.format(time),
                            fontsize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.color414141,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
