import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_images.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:event_sharing/views/screen/Home/InnerWidget/calender_widget.dart';
import 'package:event_sharing/views/screen/Home/InnerWidget/home_app_bar.dart';
import 'package:event_sharing/views/screen/Home/addBottomSheet/addBottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../utils/app_icons.dart';
import '../../base/bottom_menu..dart';
import '../../base/custom_text_field.dart';
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

  DateTime _focusedDay = DateTime(2024, 10, 1);
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  String dropdownValue = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomMenu(0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
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
                      height: 30.h,
                      width: 120.w,
                      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 2.w),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey, // Background color
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        underline: SizedBox(),
                        icon: Icon(Icons.arrow_drop_down, color: Colors.white, size: 12.sp),
                        dropdownColor: AppColors.primaryColor,
                        style: TextStyle(color: Colors.white70, fontSize: 10.sp),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items: <String>['All', 'Self', 'Spous', 'Child Stephanie', 'Child Sophia'].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: [
                                Text(value),
                                SizedBox(width: 10.w),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        HomePageAddBottomSheetWidget.addBottomSheet(context);
                      },
                    ),
                  ],
                ),
               // CalendarWidget(),
                _tableCalendar(),
                SizedBox(height: 16.h),
                _grayEventCard(),
                SizedBox(height: 16.h),
                _pianoList(),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Upcoming Event', style: TextStyle(fontSize: 20.sp)),
                      InkWell(
                          onTap: () {
                            Get.toNamed(AppRoutes.upcomingEventScreen);
                          },
                          child: Text('More', style: TextStyle(fontSize: 12.sp))),
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

//============================> Gray Event Card Section <=================================
  _grayEventCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffAAAFAE),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffd5d7d7),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.w, vertical: 10.h),
                    child: Image.asset(AppImages.logoCard,
                        color: AppColors.primaryColor,
                        width: 85.w,
                        height: 104.h),
                  ),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Piano Song Event',
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        SvgPicture.asset(AppIcons.dotIconForFamily),
                        Padding(
                          padding: EdgeInsets.only(left: 5.w),
                          child: CustomText(
                            text: 'Piano',
                            fontsize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        SvgPicture.asset(AppIcons.dotIconForFamily),
                        Padding(
                          padding: EdgeInsets.only(left: 5.w),
                          child: CustomText(
                            text: 'Type: Online',
                            fontsize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        SvgPicture.asset(AppIcons.dotIconForFamily),
                        Padding(
                          padding: EdgeInsets.only(left: 5.w),
                          child: CustomText(
                            text: 'Dhaka Bangladesh',
                            fontsize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        SvgPicture.asset(AppIcons.dotIconForFamily),
                        Padding(
                          padding: EdgeInsets.only(left: 5.w),
                          child: CustomText(
                            text: '7.00 AM-7.00PM',
                            fontsize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        SvgPicture.asset(AppIcons.dotIconForFamily),
                        Padding(
                          padding: EdgeInsets.only(left: 5.w),
                          child: CustomText(
                            text: 'History: 2023-1st winner',
                            fontsize: 10.sp,
                            color: Colors.black26,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                  ],
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
              ))
        ],
      ),
    );
  }

  //============================> Piano Event List View <=================================
  _pianoList() {
    return SizedBox(
      height: 190.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffE5CCFF),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 10.h),
                            child: Image.asset(AppImages.logoCard,
                                color: AppColors.primaryColor,
                                width: 85.w,
                                height: 104.h),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'Piano Song Event',
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(height: 12.h),
                            Row(
                              children: [
                                SvgPicture.asset(AppIcons.dotIconForFamily),
                                Padding(
                                  padding: EdgeInsets.only(left: 5.w),
                                  child: CustomText(
                                    text: 'Piano',
                                    fontsize: 10.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                SvgPicture.asset(AppIcons.dotIconForFamily),
                                Padding(
                                  padding: EdgeInsets.only(left: 5.w),
                                  child: CustomText(
                                    text: 'Type: Online',
                                    fontsize: 10.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                SvgPicture.asset(AppIcons.dotIconForFamily),
                                Padding(
                                  padding: EdgeInsets.only(left: 5.w),
                                  child: CustomText(
                                    text: 'Dhaka Bangladesh',
                                    fontsize: 10.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                SvgPicture.asset(AppIcons.dotIconForFamily),
                                Padding(
                                  padding: EdgeInsets.only(left: 5.w),
                                  child: CustomText(
                                    text: '7.00 AM-7.00PM',
                                    fontsize: 10.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                SvgPicture.asset(AppIcons.dotIconForFamily),
                                Padding(
                                  padding: EdgeInsets.only(left: 5.w),
                                  child: CustomText(
                                    text: 'History: 2023-1st winner',
                                    fontsize: 10.sp,
                                    color: Colors.black26,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                          ],
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
                      ))
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  //========================================> Table Calendar Method <=============================

  _tableCalendar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // TableCalendar Widget
        TableCalendar(
          firstDay: DateTime.utc(2020, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          startingDayOfWeek: StartingDayOfWeek.monday,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          headerStyle: HeaderStyle(
            rightChevronIcon: InkWell(
                onTap: () {
                  setState(() {
                    _calendarFormat = _calendarFormat == CalendarFormat.week
                        ? CalendarFormat.month
                        : CalendarFormat.week;
                  });
                },
                child: SvgPicture.asset(AppIcons.calendarIcon) // Update this path
            ),
            leftChevronVisible: false,
            leftChevronIcon: const SizedBox(),
            formatButtonVisible: false,
            titleCentered: false,
            titleTextStyle: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold),
          ),
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color:  AppColors.colorCDBDB6,
              shape: BoxShape.rectangle,
            ),
            selectedDecoration: BoxDecoration(
              color: AppColors.colorCDBDB6,
              shape: BoxShape.rectangle,
            ),
          ),
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              // Check if today has appointments
              bool hasAppointments = _checkForAppointments(day);
              return Container(
                margin: EdgeInsets.only(bottom: 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Using Row for horizontal alignment
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Center the content
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0), // Add vertical padding
                          child: Text(
                            '${day.day}',
                            style: TextStyle(
                              color: isSameDay(day, _selectedDay) ? Colors.white : Colors.black,
                              fontWeight: isSameDay(day, _selectedDay) ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (hasAppointments)
                      Container(
                        height: 8, // Height of the circular indicator
                        width: 8, // Width of the circular indicator
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.amber, // Change this to your desired color
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
/*  _tableCalendar2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // TableCalendar Widget
        TableCalendar(
          firstDay: DateTime.utc(2020, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          startingDayOfWeek: StartingDayOfWeek.monday,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          headerStyle: HeaderStyle(
            rightChevronIcon: InkWell(
                onTap: () {
                  setState(() {
                    _calendarFormat = _calendarFormat == CalendarFormat.week
                        ? CalendarFormat.month
                        : CalendarFormat.week;
                  });
                },
                //  child: Icon(Icons.calendar_today_rounded, color: AppColors.primaryColor),
                child: SvgPicture.asset(AppIcons.calendarIcon)
            ),
            leftChevronIcon: const SizedBox(),
            formatButtonVisible: false,
            titleCentered: false,
            titleTextStyle: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold),
          ),
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: AppColors.colorCDBDB6,
              shape: BoxShape.rectangle,
            ),
            selectedDecoration: BoxDecoration(
              color: AppColors.colorCDBDB6,
              shape: BoxShape.rectangle,
            ),
          ),
        ),
      ],
    );
  }*/
  // Function to check for appointments for a specific day
  bool _checkForAppointments(DateTime day) {
    // Check if the day exists in the appointment map
    return appointmentDates.containsKey(day);
  }
}



