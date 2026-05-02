import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../models/event_model.dart';

class EventCardWidget extends StatelessWidget {
  final String? eventTitle;
  final String? imagePath;
  final String? name;
  final String? eventType;
  final String? address;
  final String? time;
  final String? history;
  final Color backgroundColor;
  final EventModel? eventModel;

  const EventCardWidget({
    Key? key,
    this.eventTitle,
    this.imagePath,
    this.name,
    this.eventType,
    this.address,
    this.time,
    this.history,
    required this.backgroundColor,
    this.eventModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String displayTitle = eventModel?.eventName ?? eventTitle ?? '';
    String displayName = eventModel?.program?.name ?? name ?? '';
    String displayType = eventModel?.schedule?.eventType ?? eventType ?? '';
    String displayAddress = eventModel?.location ?? address ?? '';
    String displayTime = time ?? '';
    if (eventModel?.schedule?.registrationDate != null) {
       displayTime = DateFormat('hh:mm a').format(eventModel!.schedule!.registrationDate!);
    }
    String displayHistory = history ?? '';

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
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: eventModel?.coverImage != null
                      ? Image.network(
                          eventModel!.coverImage!,
                           width: 125.w,
                           height: 125.h,
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                  width: 125.w,
                                  height: 125.h,
                                color: Colors.grey[300],
                                child: Icon(Icons.image, size: 30.w)
                              ),
                        )
                      : Image.asset(
                          imagePath ?? '',
                          width: 125.w,
                          height: 125.h,
                          fit: BoxFit.fill,
                        ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayTitle,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Expanded(child: _buildIconText(displayName)),
                          SizedBox(width: 4.w),
                          _buildIconText("Type: $displayType"),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      _buildIconText(displayAddress),
                      SizedBox(height: 8.h),
                      _buildIconText(displayTime),
                      if (displayHistory.isNotEmpty) ...[
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            SvgPicture.asset(AppIcons.dotIconForFamily),
                            SizedBox(width: 5.w),
                            SizedBox(width: 5.w),
                            Text("History: $displayHistory",
                                style: AppStyles.fontSize10(color: Colors.black26)),
                          ],
                        ),
                      ],
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
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(AppIcons.dotIconForFamily),
        SizedBox(width: 5.w),
        SizedBox(width: 5.w),
        Flexible(
          child: Text(
            text,
            style: TextStyle(fontSize: 10.sp, color: Colors.black),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
