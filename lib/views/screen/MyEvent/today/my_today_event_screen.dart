import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../helpers/route.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_icons.dart';

class MyTodayEventScreen extends StatefulWidget {
   MyTodayEventScreen({super.key});

  @override
  State<MyTodayEventScreen> createState() => _MyTodayEventScreenState();
}

class _MyTodayEventScreenState extends State<MyTodayEventScreen> {
  final List<Map<String, String>> events = [

    {
      "imageUrl": "assets/images/music.png",
      "title": "Bangla Music",
      "location": "Dhaka, Bangladesh",
      "time": "10:00 AM",
    },
    {
      "imageUrl": "assets/images/music.png",
      "title": "Bangla Music",
      "location": "Dhaka, Bangladesh",
      "time": "10:00 AM",
    },
    {
      "imageUrl": "assets/images/music.png",
      "title": "Bangla Music",
      "location": "Dhaka, Bangladesh",
      "time": "10:00 AM",
    },
  ];
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 24.w,vertical: 10),
        child: Column(
          children: [
            //==============================> Create Event Button <=======================
            _searchBar(),
            SizedBox(height: 16.h),
            //=================================> Event List view <========================
            Expanded(
              child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.eventDetailsScreen);
                      },
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 8.h),
                            decoration: BoxDecoration(
                              color: const Color(0xffedf2f4),
                              border: Border.all(color: AppColors.colorC8D7DE, width: 1.w),
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
                                      event['imageUrl']!,
                                      height: 75.0.h,
                                      width: 75.0.w,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  //=====================> Event Details Section <=========================
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(event['title']!,style: AppStyles.fontSize14(fontWeight: FontWeight.w600)),
                                        //=====================> Event Info Section <=========================
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                                                  child: Row(
                                                    children: [
                                                      SvgPicture.asset(AppIcons.dotIconForFamily),
                                                      SizedBox(width: 4.w),
                                                      Text('Onsite Event', style: TextStyle(fontSize: 8.sp, color: AppColors.color414141)),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                                                  child: Row(
                                                    children: [
                                                      SvgPicture.asset(AppIcons.dotIconForFamily),
                                                      SizedBox(width: 4.w),
                                                      Text('Dhaka Bangladesh', style: TextStyle(fontSize: 8.sp, color: AppColors.color414141)),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                                                  child: Row(
                                                    children: [
                                                      SvgPicture.asset(AppIcons.dotIconForFamily),
                                                      SizedBox(width: 4.w),
                                                      Text('History: 2023-1st winner', style: TextStyle(fontSize: 8.sp, color: AppColors.color808080)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                                                  child: Row(
                                                    children: [
                                                      SvgPicture.asset(AppIcons.dotIconForFamily),
                                                      SizedBox(width: 4.w),
                                                      Text('Cost: \$100', style: TextStyle(fontSize: 8.sp, color: AppColors.color414141)),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                                                  child: Row(
                                                    children: [
                                                      SvgPicture.asset(AppIcons.dotIconForFamily),
                                                      SizedBox(width: 4.w),
                                                      Text('Deadline: 1-6-2025', style: TextStyle(fontSize: 8.sp, color: AppColors.color414141)),
                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  //=====================> Share Icon <=========================
                                  SvgPicture.asset(
                                    AppIcons.share,
                                    width: 16.w,
                                    height: 16.h,
                                    color: Colors.blueGrey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //=====================> Positioned More Icon at Top Right <=========================
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: Icon(Icons.more_horiz, color:AppColors.greyColor),
                          ),
                        ],
                      )

                  );
                },
              ),
            )

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
          width: 271.w,
          child: CustomTextField(
            controller: _searchController,
            contenpaddingHorizontal: 12.w,
            contenpaddingVertical: 12.h,
            hintText: "Search Event",
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
            Get.toNamed(AppRoutes.myEventFilterScreen);
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
