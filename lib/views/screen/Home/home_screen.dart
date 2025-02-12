 import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_images.dart';
import 'package:event_sharing/utils/style.dart';

import 'package:event_sharing/views/screen/Home/InnerWidget/calender_widget.dart';
import 'package:event_sharing/views/screen/Home/InnerWidget/eventCard_widget.dart';
import 'package:event_sharing/views/screen/Home/InnerWidget/home_app_bar.dart';
import 'package:event_sharing/views/screen/Home/addBottomSheet/addBottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../utils/app_icons.dart';
import '../../base/bottom_menu..dart';
import 'upcoming_event_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
// Dummy data for appointments
final Map<DateTime, List<String>> appointmentDates = {
  DateTime.utc(2024, 10, 16): ['Meeting with team', 'Doctor appointment'],
  DateTime.utc(2024, 10, 18): ['Project deadline'],
  DateTime.utc(2024, 10, 20): ['Lunch with client', 'Gym session'],
  DateTime.utc(2024, 10, 22): ['Webinar'],
};

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, String>> events = [
    {
      "date": "20 Feb",
      "title": "Basketball Game",
      "type": "Onsite Event",
      "location": "Dhaka, Bangladesh",
      "time": "Deadline: 1-6-2025",
      "cost": " Cost-100",
      "image": "assets/images/upcoming.png"
    },
    {
      "date": "21 Mar",
      "title": "Music Concert",
      "type": "Onsite Event",
      "location": "Chittagong, Bangladesh",
      "time": "Deadline: 1-6-2025",
      "cost": " Cost-100",
      "image": "assets/images/upcoming.png"
    },
    {
      "date": "15 Apr",
      "type": "Onsite Event",
      "title": "Art Exhibition",
      "location": "Sylhet, Bangladesh",
      "time": "Deadline: 1-6-2025",
      "cost": " Cost-100",
      "image": "assets/images/upcoming.png"
    }
  ];
  String dropdownValue = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomMenu(0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeAppBar(),
                SizedBox(height: 20.h),
                 _searchBar(),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 35.h,
                      padding: EdgeInsets.symmetric(horizontal: 8.h),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        padding: EdgeInsets.zero,
                        underline: const SizedBox(),
                        icon: SvgPicture.asset(AppIcons.down_ArrowIcon),
                        dropdownColor: Colors.white,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        selectedItemBuilder: (BuildContext context) {
                          return <String>[
                            'All',
                            'Self',
                            'Spouse',
                            'Child Stephanie',
                            'Child Sophia',
                          ].map<Widget>((String value) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: Center(
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                            );
                          }).toList();
                        },
                        items: <String>[
                          'All',
                          'Self',
                          'Spouse',
                          'Child Stephanie',
                          'Child Sophia',
                        ].map<DropdownMenuItem<String>>((String value) {
                          Color backgroundColor;
                          switch (value) {
                            case 'Self':
                              backgroundColor = AppColors.color67AB9F;
                              break;
                            case 'Spouse':
                              backgroundColor = AppColors.colorE5CCFF;
                              break;
                            case 'Child Stephanie':
                              backgroundColor = AppColors.colorCCFFE6;
                              break;
                            case 'Child Sophia':
                              backgroundColor = AppColors.colorFFF2CC;
                              break;
                            default:
                              backgroundColor = Colors.white;
                          }
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: EdgeInsets.all(4.r),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        HomePageAddBottomSheetWidget.addBottomSheet(context);
                      },
                    ),
                  ],
                  ),
               // _tableCalendar(),
                CalendarWithDropdown(),
                SizedBox(height: 16.h),
                //gray color event
                EventCardWidget(
                  eventTitle: 'Piano Song Event',
                  imagePath: AppImages.logoCard,
                  backgroundColor: Color(0xffAAAFAE),
                  name: 'Piano',
                  eventType: 'Online',
                  address: 'Dhaka, Bangladesh',
                  time: '7:00 AM - 8:00 PM',
                  history: '2023-1st winner',
                ),
                SizedBox(height: 16.h),
                //gray color event
                _pianoList(),
                SizedBox(height: 16.h),


                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Upcoming Event', style: AppStyles.fontSize18(fontWeight: FontWeight.w500)),
                      InkWell(
                          onTap: () {
                            Get.toNamed(AppRoutes.upcomingEventScreen);
                          },
                          child: Text('More',style: AppStyles.fontSize14(fontWeight: FontWeight.w500))),
                    ],
                  ),
                ),
                SizedBox(
                  height: 320.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoutes.eventDetailsScreen);
                        },
                        child: SizedBox(
                          width: 350.w,
                          child: EventCard(),
                        ),
                      );
                    },
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }

//============================> Search Bar Section <=================================
  Widget _searchBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: TextFormField(
            controller: _searchController,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.fillColor,
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              hintText: "Search Event",
              hintStyle: AppStyles.fontSize14(color: AppColors.greyColor),
              suffixIcon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: SvgPicture.asset(
                  AppIcons.search,
                  width: 24.w,
                  height: 24.h,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppColors.primaryColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppColors.primaryColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppColors.primaryColor, width: 2.w),
              ),
            ),
          ),
        ),
        SizedBox(width: 18.w),
        GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.filterScreen);
          },
          child: Container(
            height: 53.h,
            width: 53.h,
            decoration: BoxDecoration(
              color: AppColors.fillColor,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(width: 1.w, color: AppColors.primaryColor),
            ),
            child: Center(
              child: SvgPicture.asset(
                AppIcons.filterIcon,
                width: 24.w,
                height: 24.h,
              ),
            ),
          ),
        ),
      ],
    );
  }




  //============================> Piano Event List View <=================================
  _pianoList() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 160.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: EventCardWidget(
              eventTitle: 'Piano Song Event',
              imagePath: AppImages.logoCard,
              backgroundColor: Color(0xffE5CCFF),
              name: 'Piano',
              eventType: 'Online',
              address: 'Dhaka, Bangladesh',
              time: '7:00 AM - 8:00 PM',
              history: '2023-1st winner',
            ),
          );
        },
      ),
    );
  }

}



