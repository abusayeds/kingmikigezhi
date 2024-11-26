import 'package:event_sharing/utils/style.dart';
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
            //========================> Details Card
            Dismissible(
              key: UniqueKey(),
              //crossAxisEndOffset : 1,
              direction: DismissDirection.endToStart,
              background: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: AppColors.colorD9A951,
                ),
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 26.w),
                child: SvgPicture.asset(AppIcons.deleteIcon),
              ),
              onDismissed: (direction) {},
              child: Container(
               margin: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  color: const Color(0xffedf2f4),
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(color: AppColors.primaryColor, width: .5),
                ),
                child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
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
                          // Title and Share Icon Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Tom Alax shared Akcent Music',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Icon(Icons.share, color: Colors.blueGrey, size: 16.sp), // Share Icon
                            ],
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
                                      Icon(Icons.circle, size: 8.sp, color: Colors.blueGrey),
                                      SizedBox(width: 4.w),
                                      Text(
                                        'Onsite Event',
                                        style: TextStyle(fontSize: 10.sp, color: Colors.grey[800]),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      Icon(Icons.circle, size: 8.sp, color: Colors.blueGrey),
                                      SizedBox(width: 4.w),
                                      Text(
                                        'Dhaka Bangladesh',
                                        style: TextStyle(fontSize: 10.sp, color: Colors.grey[800]),
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
                                      Icon(Icons.circle, size: 8.sp, color: Colors.blueGrey),
                                      SizedBox(width: 4.w),
                                      Text(
                                        'Cost: \$100',
                                        style: TextStyle(fontSize: 10.sp, color: Colors.grey[800]),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      Icon(Icons.circle, size: 8.sp, color: Colors.blueGrey),
                                      SizedBox(width: 4.w),
                                      Text(
                                        'Deadline: 1-6-2025',
                                        style: TextStyle(fontSize: 10.sp, color: Colors.grey[800]),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),

                          //=====================> More Options Icon at the Bottom Right <=========================
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.only(top: 8.h),
                              child: Icon(Icons.more_horiz, color: AppColors.color87A9B8, size: 20.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
                          ),
          ),

          //========================> Request Card
        Dismissible(
         // crossAxisEndOffset : 1,
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          background: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: AppColors.colorD9A951,

            ),
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 26.r),
            child: SvgPicture.asset(AppIcons.deleteIcon),
          ),
          onDismissed: (direction) {
            // Handle dismissal action here
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.colorEDF2F4,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.primaryColor, width: .5),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //=====================> Image Section <=========================
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50.r),
                        child: Image.asset(
                          'assets/images/shoot.png',
                          height: 59.0.h,
                          width: 59.0.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      //=====================> Details Section <=========================
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sophia',
                              style: AppStyles.fontSize14(fontWeight: FontWeight.w500),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              'requested to join your family',
                              style: AppStyles.fontSize12(fontWeight: FontWeight.w400), // Adjusted style for subtitle
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(height: 8.h),
                            //=====================> Event Info Section <=========================
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.circle, size: 8.sp, color: Colors.blueGrey), // Dot icon
                                    SizedBox(width: 4.w),
                                    Text(
                                      'Account ID: 102',
                                      style: TextStyle(fontSize: 10.sp, color: Colors.grey[800]), // Style adjustment
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20.w),
                                Row(
                                  children: [
                                    Icon(Icons.circle, size: 8.sp, color: Colors.blueGrey), // Dot icon
                                    SizedBox(width: 4.w),
                                    Text(
                                      'Contribution: 100',
                                      style: TextStyle(fontSize: 10.sp, color: Colors.grey[800]), // Style adjustment
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      //=====================> More Options Icon <=========================
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Icon(Icons.more_horiz, color: AppColors.color87A9B8, size: 20.sp),
                      ),
                    ],
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
        child: SvgPicture.asset(AppIcons.deleteIcon),
      ),
      onDismissed: (direction) {},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: AppColors.colorEDF2F4
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
                          fontWeight: FontWeight.w600,
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
