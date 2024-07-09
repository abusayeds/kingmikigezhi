import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../helpers/route.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icons.dart';
import '../../base/custom_text.dart';
import '../../base/custom_text_field.dart';

class SearchEventScreen extends StatefulWidget {
  @override
  State<SearchEventScreen> createState() => _SearchEventScreenState();
}

class _SearchEventScreenState extends State<SearchEventScreen> {
  final TextEditingController _searchController = TextEditingController();
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
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'Search',
          fontsize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
        child: Column(
          children: [
            //==========================> Search Bar <=====================
            CustomTextField(
              onTab: () {
                Get.toNamed(AppRoutes.searchEventScreen);
              },
              controller: _searchController,
              hintText: 'Find Upcoming Event',
              sufixicons: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.search,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            //=================================> Event List view <========================
            Expanded(
              child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return GestureDetector(
                    onTap: (){
                      Get.toNamed(AppRoutes.detailsEventScreen);
                    },
                    child: Card(
                      color: const Color(0xffedf2f4),
                      margin: EdgeInsets.symmetric(vertical: 8.h),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        child: Row(
                          children: [
                            //=====================> Event Image Section <=========================
                            Container(
                              width: 77.w,
                              height: 76.h,
                              decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.r))),
                              child: Image.asset(
                                event['imageUrl']!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 16.h),
                            //=====================> Event Title Section <=========================
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: event['title']!,
                                    fontsize: 14.sp,
                                  ),
                                  SizedBox(height: 8.h),
                                  //=====================> Event Location Section <=========================
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        AppIcons.locationIcon,
                                        color: AppColors.primaryColor,
                                      ),
                                      CustomText(
                                        text: event['location']!,
                                        fontsize: 10.sp,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                //===========================> Share Icon Button <======================
                                InkWell(
                                    onTap: () {},
                                    child: Icon(
                                      Icons.share,
                                      color: AppColors.primaryColor,
                                      size: 20.h,
                                    )),
                                SizedBox(height: 8.h),
                                //=====================> Event Time Section <=========================
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SvgPicture.asset(
                                      AppIcons.timeIcon,
                                      color: AppColors.primaryColor,
                                    ),
                                    SizedBox(width: 5.w),
                                    CustomText(text: event['time']!),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
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
}
