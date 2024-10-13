import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as TimeAgo;
import '../../../utils/app_colors.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_strings.dart';
import '../../base/custom_text.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //================================> App bar section <=======================
      appBar: AppBar(
        title: CustomText(
          text: AppStrings.notifications,
          fontsize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
        centerTitle: true,
      ),

      //================================> Body section <=======================
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h),
        child: Column(
          children: [
            //================================> Notification section <=======================
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.notificationBGcolor,
                      ),

                      child: _notification(
                          'Account Setup Successful!',
                          DateTime.now(),
                          'Your account creation is successful, you can now experience our services.'),
                    ),
                  );
                },
              ),
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
  ) {
    return Dismissible(
      key: Key(title),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: AppColors.colorD9A951,
        ),

        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 16.w),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: AppColors.colorEDF2F4,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Notification Icon
                    Container(
                      margin: EdgeInsets.only(left: 8.w, right: 7.w),
                      padding: EdgeInsets.all(7.r),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xffffffff)),
                      child: SvgPicture.asset(
                        AppIcons.notificationIcon,
                        color: AppColors.primaryColor,
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      CustomText(
                        text: title,
                        fontsize: 14.h,
                        color: Colors.black,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CustomText(
                          top: 2.h,
                          text: TimeAgo.format(time),
                          fontsize: 8.h,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF8C8C8C),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Short Description
            CustomText(
              top: 8.h,
              text: shorDescription,
              color: Colors.black,
              textAlign: TextAlign.start,
              maxline: 5,
            ),
          ],
        ),
      ),
    );

  }
}
