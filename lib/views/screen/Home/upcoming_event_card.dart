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
import '../../base/app_remote_image.dart';

class EventCard extends StatelessWidget {
  final EventModel? eventModel;
  const EventCard({super.key, this.eventModel});

  @override
  Widget build(BuildContext context) {
    String displayDate = '';
    if (eventModel?.schedule?.registrationDate != null) {
      displayDate =
          DateFormat('dd MMM').format(eventModel!.schedule!.registrationDate!);
    }
    String deadline = '';
    if (eventModel?.schedule?.deadline != null) {
      deadline = DateFormat('d-M-yyyy').format(eventModel!.schedule!.deadline!);
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      color: const Color(0xffedf2f4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 4.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24.r),
                    child: SizedBox.expand(
                      child: AppRemoteImage(
                        url: eventModel?.coverImage,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 4.w,
                    top: 6.h,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        border: Border.all(width: 1.w, color: Colors.white),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 12.h),
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
            ),
            SizedBox(height: 6.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    eventModel?.eventName ?? 'Snowboard Festival',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 13.sp,
                      color: const Color(0xFF111111),
                    ),
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
                    height: 18.h,
                    width: 18.w,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    eventModel?.schedule?.eventType ?? 'Onsite Event',
                    style: GoogleFonts.poppins(
                      color: AppColors.color414141,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  'Cost-${eventModel?.schedule?.cost ?? '100'}',
                  style: GoogleFonts.poppins(
                    color: AppColors.color414141,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    eventModel?.location ?? 'Dhaka Bangladesh',
                    style: GoogleFonts.poppins(
                      color: AppColors.color414141,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  'Deadline: ${deadline.isNotEmpty ? deadline : '1-6-2025'}',
                  style: GoogleFonts.poppins(
                    color: AppColors.color414141,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                EventMoreMenuButton(
                  event: eventModel,
                  iconColor: AppColors.greyColor,
                  iconSize: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
