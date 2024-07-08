/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../base/custom_text.dart';

class UpcomingEvent extends StatelessWidget {
  const UpcomingEvent({
    super.key,
    required this.events,
  });

  final List<Map<String, String>> events;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 245.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Card(
              color: Color(0xffedf2f4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(6.w),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(10.r)),
                          child: Image.asset(
                            event["image"]!,
                            // width: 240.w,
                            height: 140.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 10.w,
                        top: 12.h,
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryColor,
                              border:
                                  Border.all(width: 1.w, color: Colors.white)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 18.h),
                            child: CustomText(
                              text: event["date"]!,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 270.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: event["title"]!,
                                fontWeight: FontWeight.w500,
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    AppIcons.timeIcon,
                                    color: AppColors.primaryColor,
                                  ),
                                  SizedBox(width: 5.w),
                                  CustomText(
                                    text: event["time"]!,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            SvgPicture.asset(
                              AppIcons.locationIcon,
                              width: 14.w,
                              height: 17.h,
                              color: AppColors.primaryColor,
                            ),
                            SizedBox(width: 5.w),
                            CustomText(
                              text: event["location"]!,
                              color: Colors.grey,
                              textOverflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
*/
