import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventCardWidget extends StatelessWidget {
  final String eventTitle;
  final String imagePath;
  final String name;
  final String eventType;
  final String address;
  final String time;
  final String history;
  final Color backgroundColor;

  const EventCardWidget({
    Key? key,
    required this.eventTitle,
    required this.imagePath,
    required this.name,
    required this.eventType,
    required this.address,
    required this.time,
    required this.history,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.w, vertical: 10.h),
                    child: Image.asset(
                      imagePath,
                      width: 85.w,
                      height: 104.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        eventTitle,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          _buildIconText('$name'),
                          const Spacer(),
                          _buildIconText("Type: $eventType"),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      _buildIconText('$address'),
                      SizedBox(height: 8.h),
                      _buildIconText('$time'),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          SvgPicture.asset(AppIcons.dotIconForFamily),
                          SizedBox(width: 5.w),
                          SizedBox(width: 5.w),
                          Text("History: ${history}",style: AppStyles.fontSize10(color: Colors.black26)),
                        ],
                      ),
                      SizedBox(height: 8.h),

                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 5.h,
            right: 10.w,
            child: const Icon(
              Icons.more_horiz_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconText(String text) {
    return Row(
      children: [
        SvgPicture.asset(AppIcons.dotIconForFamily),
        SizedBox(width: 5.w),
        SizedBox(width: 5.w),
        Text(
          text,
          style: TextStyle(fontSize: 10.sp, color: Colors.black),
        ),
      ],
    );
  }
}
