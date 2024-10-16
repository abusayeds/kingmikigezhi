import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_strings.dart';
import 'package:event_sharing/views/screen/Home/upcoming_event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../utils/app_icons.dart';
import '../../base/custom_text.dart';
import '../../base/custom_text_field.dart';

class UpcomingEventScreen extends StatefulWidget {
  @override
  State<UpcomingEventScreen> createState() => _UpcomingEventScreenState();
}

class _UpcomingEventScreenState extends State<UpcomingEventScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                alignment: Alignment.center,
                child: CustomText(
                  text: AppStrings.upcomingEvent,
                  fontsize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //==========================> Search Bar <=====================
            _searchBar(),
            SizedBox(height: 16.h),
            //==========================> List View Section <=====================
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.eventDetailsScreen);
                      },
                      child: EventCard());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

//============================> Search Bar Section <=================================
  _searchBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 290.w,
          child: CustomTextField(
            controller: _searchController,
            contenpaddingHorizontal: 12.w,
            contenpaddingVertical: 12.h,
            hintText: "Search",
            sufixicons: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: SvgPicture.asset(
                AppIcons.search,
                width: 24.w,
                height: 24.h,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.filterScreen);
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.fillColor,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(width: 1.w, color: AppColors.primaryColor),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: SvgPicture.asset(
                AppIcons.filterIcon,
                width: 24.w,
                height: 24.h,
              ),
            ),
          ),
        )
      ],
    );
  }
}
