
import 'package:event_sharing/views/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../helpers/route.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../base/custom_text.dart';

class MyContributionScreen extends StatefulWidget {
  MyContributionScreen({super.key});

  @override
  State<MyContributionScreen> createState() => _MyContributionScreenState();
}

class _MyContributionScreenState extends State<MyContributionScreen> {
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
      appBar: AppBar(
        title:  Text('Total 1000 Contribution',style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.bold),),
       leading: IconButton(
         icon: Icon(Icons.arrow_back_ios,
             color: Colors.black, size: 18.w),
         onPressed: () {
           Get.back();
         },
       ),
        centerTitle: true,
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            //==============================> Create Event Button <=======================
            const Text('Year 2024 25 Contribution'),
            SizedBox(height: 16.h),
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
                    child: Card(
                      margin: EdgeInsets.symmetric(vertical: 8.h),
                      color: const Color(0xffedf2f4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
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
                            SizedBox(width: 16.w),
                            //=====================> Event Details Section <=========================
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: event['title']!,
                                    fontsize: 16.sp,
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
                                              Text('Onsite Event',style: TextStyle(fontSize: 8.sp),),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              SvgPicture.asset(AppIcons.dotIconForFamily),
                                              SizedBox(width: 4.w),
                                              Text('Dhaka Bangladesh',style: TextStyle(fontSize: 8.sp),),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              SvgPicture.asset(AppIcons.dotIconForFamily),
                                              SizedBox(width: 4.w),
                                              Text('History: 2023-1st winner',style: TextStyle(fontSize: 8.sp),),
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
                                              Text('Cost : \$100',style: TextStyle(fontSize: 8.sp),),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              SvgPicture.asset(AppIcons.dotIconForFamily),
                                              SizedBox(width: 4.w),
                                              Text('Deadline: 1-6-2025',style: TextStyle(fontSize: 8.sp),),
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
                                      Icon(Icons.more_horiz,color: Colors.grey,)
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
            Get.toNamed(AppRoutes.contributionFilterScreen);
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
