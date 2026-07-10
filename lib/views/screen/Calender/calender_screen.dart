import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../helpers/route.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icons.dart';
import '../../base/bottom_menu..dart';
import '../../base/custom_text.dart';
import '../../base/custom_text_field.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
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
      bottomNavigationBar: const BottomMenu(2),
      appBar: AppBar(
        title: CustomText(
          text: 'Calender',
          fontsize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
        centerTitle: true,
        leading: const SizedBox(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //==========================> Search Bar <=====================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomTextField(
                    onTab: () => searchDate(context),
                    readOnly: true,
                    controller: _searchController,
                    hintText: 'Search Date',
                    prifixicon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(AppIcons.locationIcon,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    sufixicons: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.search,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                //=================================> Filter Icon <=========================
                GestureDetector(
                  onTap: (){
                    Get.toNamed(AppRoutes.filterScreen);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.r)),
                      border: Border.all(width: 1.w, color: AppColors.primaryColor)
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 15.h),
                      child: SvgPicture.asset(AppIcons.filterIcon, width: 24.w,height: 24.h,color: AppColors.primaryColor,),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 35.h),
            Container(
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(24.r)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: const CustomText(
                  text: "Search Result",
                  color: Colors.white,
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
                      Get.toNamed(AppRoutes.eventDetailsScreen);
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(vertical: 8.h),
                      color: const Color(0xffedf2f4),
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
                                    onTap: () {
                                      Get.toNamed(AppRoutes.inviteEventScreen);
                                    },
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

//========================================> Search Date Method <=============================
  Future<void> searchDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(3050),
    );
    if (pickedDate != null) {
      _searchController.text =
      "${pickedDate.month}-${pickedDate.day}-${pickedDate.year}";
      print('Selected date: ${_searchController.text}');
    }
  }
}
