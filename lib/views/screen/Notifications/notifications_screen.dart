import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:timeago/timeago.dart' as TimeAgo;
import '../../../utils/app_colors.dart';
import '../../../utils/app_icons.dart';
import '../../base/custom_text.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //================================> App bar section <=======================
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                alignment: Alignment.center, // Center the text
                child: CustomText(
                  text: 'Notification(20)',
                  fontsize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),

      //================================> Body section <=======================
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h),
        child: Column(
          children: [
            //================================> Notification section <=======================

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Ignore All',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 8.h),
              color: const Color(0xffedf2f4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //=====================> Event Image Section <=========================
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Image.asset(
                        'assets/images/shoot.png',
                        height: 75.0.h,
                        width: 75.0.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    //=====================> Event Details Section <=========================
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: 'Event Name',
                            fontsize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: 8.h),
                          //=====================> Event Info Section <=========================
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(AppIcons.dotIconForFamily),
                                      SizedBox(width: 4.w),
                                      Text(
                                        'Onsite Event',
                                        style: TextStyle(fontSize: 8.sp),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SvgPicture.asset(AppIcons.dotIconForFamily),
                                      SizedBox(width: 4.w),
                                      Text(
                                        'Dhaka Bangladesh',
                                        style: TextStyle(fontSize: 8.sp),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SvgPicture.asset(AppIcons.dotIconForFamily),
                                      SizedBox(width: 4.w),
                                      Text(
                                        'History: 2023-1st winner',
                                        style: TextStyle(fontSize: 8.sp),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(AppIcons.dotIconForFamily),
                                      SizedBox(width: 4.w),
                                      Text(
                                        'Cost : \$100',
                                        style: TextStyle(fontSize: 8.sp),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SvgPicture.asset(AppIcons.dotIconForFamily),
                                      SizedBox(width: 4.w),
                                      Text(
                                        'Deadline: 1-6-2025',
                                        style: TextStyle(fontSize: 8.sp),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(Icons.more_horiz, color: Colors.grey)
                            ],
                          )
                        ],
                      ),
                    ),

                    //=====================> Share Icon <=========================
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: SvgPicture.asset(
                        AppIcons.share, // Share icon
                        width: 16.w,
                        height: 16.h,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 2,
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
                        'Your account creation is successful, you can now experience our services.',
                      ),
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
        padding: EdgeInsets.only(right: 26.w),
        child: SvgPicture.asset(AppIcons.remove),
      ),
      onDismissed: (direction) {},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: AppColors.colorEDF2F4,
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
                          fontsize: 14.h,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            top: 2.h,
                            text: TimeAgo.format(time),
                            fontsize: 12.h,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF8C8C8C),
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
