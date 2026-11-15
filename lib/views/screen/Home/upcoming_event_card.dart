import 'package:event_sharing/helpers/event_actions.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../models/event_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_images.dart';
import '../../base/app_remote_image.dart';

class EventCard extends StatelessWidget {
  final EventModel? eventModel;
  const EventCard({super.key, this.eventModel});

  @override
  Widget build(BuildContext context) {
    String displayDate = '';
    if (eventModel?.schedule?.registrationDate != null) {
      displayDate = DateFormat('dd MMM').format(eventModel!.schedule!.registrationDate!);
    }
    String deadline = '';
    if (eventModel?.schedule?.deadline != null) {
      deadline = DateFormat('d-M-yyyy').format(eventModel!.schedule!.deadline!);
    }

    return Card(
      color: const Color(0xffedf2f4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Padding(
        padding: EdgeInsets.only(
            left: 8.w,
            right: 8.w,
            top: 10.h,
            bottom: 4.h  // Reduced bottom padding of the main card
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,  // This ensures the column takes minimum space
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24.r),
                  child: AppRemoteImage(
                    url: eventModel?.coverImage,
                    height: 154.h,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  right: -4.w,
                  top: 6.h,
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        border: Border.all(width: 1.w, color: Colors.white),
                        shape: BoxShape.circle
                      // borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 16.h),
                      child: CustomText(
                        text: displayDate.isNotEmpty ? displayDate : '20 Feb',
                        fontsize: 10.sp,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 4.w,
                  right: 4.w,
                  top: 8.h,
                  bottom: 0.h  // Removed bottom padding completely
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,  // Column takes minimum space
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            eventModel?.eventName ?? 'Snowboard Festival',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                                color: const Color(0xFF111111)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (eventModel != null) {
                              handleEventMenuAction('share', eventModel!);
                            }
                          },
                          child: SvgPicture.asset(
                            AppIcons.share,
                            color: AppColors.primaryColor,
                            height: 20.h,
                            width: 20.w,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.circle, color: AppColors.primaryColor, size: 8.w),
                              SizedBox(width: 4.w),
                              Text(eventModel?.schedule?.eventType ?? 'Onsite Event',style: GoogleFonts.poppins(color: AppColors.color414141,fontSize: 10.sp,fontWeight: FontWeight.w400))
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.circle,
                                  color: AppColors.primaryColor, size: 8.w),
                              SizedBox(width: 4.w),
                              Text(eventModel?.location ?? 'Dhaka Bangladesh',style: GoogleFonts.poppins(color: AppColors.color414141,fontSize: 10.sp,fontWeight: FontWeight.w400),)
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.circle,
                                  color: AppColors.primaryColor, size: 8.w),
                              SizedBox(width: 4.w),
                              Text('Cost-${eventModel?.schedule?.cost ?? '100'}',style: GoogleFonts.poppins(color: AppColors.color414141,fontSize: 10.sp,fontWeight: FontWeight.w400),)
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.circle, color: AppColors.primaryColor, size: 8.w),
                              SizedBox(width: 4.w),
                              Text('Deadline: ${deadline.isNotEmpty ? deadline : '1-6-2025'}',style: GoogleFonts.poppins(color: AppColors.color414141,fontSize: 10.sp,fontWeight: FontWeight.w400),)
                            ],
                          ),
                        ],
                      ),
                      const Spacer()
                    ],
                  ),
                  SizedBox(height: 2.h), // Very minimal spacing before the icon
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 2.h),
                        child: EventMoreMenuButton(
                          event: eventModel,
                          iconColor: AppColors.greyColor,
                        ),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}