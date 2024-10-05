import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_images.dart';
import 'package:event_sharing/utils/app_strings.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:event_sharing/views/screen/Home/InnerWidget/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../utils/app_icons.dart';
import '../../base/bottom_menu..dart';
import '../../base/custom_button.dart';
import '../../base/custom_text_field.dart';
import '../../base/event_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

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

  DateTime _focusedDay = DateTime(2024, 1, 1);
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomMenu(0),
      body: SafeArea(
        child: SingleChildScrollView(
          // Wrap everything in a scroll view
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeAppBar(),
                SizedBox(height: 20.h),
                _searchBar(),
                _tableCalendar(),
                SizedBox(height: 16.h),
                _grayEventCard(),
                SizedBox(height: 16.h),
                _pianoList(),
                SizedBox(height: 16.h),
                _sectionHeader(
                  title: AppStrings.upcomingEvent,
                  onSeeAllPressed: () {
                    Get.toNamed(AppRoutes.upcomingEventScreen);
                  },
                ),
                SizedBox(
                  height: 320.h,
                  child: ListView.builder(
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.detailsEventScreen);
                          },
                          child: EventCard());
                    },
                  ),
                ),
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
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
                        Icon(Icons.circle,
                            color: AppColors.primaryColor, size: 8.w),
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
                        Icon(Icons.circle,
                            color: AppColors.primaryColor, size: 8.w),
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
                        Icon(Icons.circle,
                            color: AppColors.primaryColor, size: 8.w),
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
                        Icon(Icons.circle,
                            color: AppColors.primaryColor, size: 8.w),
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
                        Icon(Icons.circle,
                            color: AppColors.primaryColor, size: 8.w),
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

  //=======================> Upcoming Event Text and More Button Section <===========================
  _sectionHeader(
      {required String title, required VoidCallback onSeeAllPressed}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: title,
          fontsize: 20.sp,
          fontWeight: FontWeight.w500,
        ),
        TextButton(
          onPressed: onSeeAllPressed,
          child: CustomText(
            text: 'More',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  //============================> Piano Event List View <=================================
  _pianoList() {
    return SizedBox(
      height: 180.h,
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
                                Icon(Icons.circle,
                                    color: AppColors.primaryColor, size: 8.w),
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
                                Icon(Icons.circle,
                                    color: AppColors.primaryColor, size: 8.w),
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
                                Icon(Icons.circle,
                                    color: AppColors.primaryColor, size: 8.w),
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
                                Icon(Icons.circle,
                                    color: AppColors.primaryColor, size: 8.w),
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
                                Icon(Icons.circle,
                                    color: AppColors.primaryColor, size: 8.w),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TableCalendar(
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
                  rightChevronIcon: Row(
                    children: [
                      /* Container(
                        //padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedGender,
                              dropdownColor: AppColors.fillColor,
                              menuWidth: 245.w,
                              borderRadius: BorderRadius.circular(8.r),
                              hint: Text(
                                "All",
                                style: TextStyle(
                                    fontSize: 18.sp, fontWeight: FontWeight.w500),
                              ),
                              icon: SvgPicture.asset(
                                AppIcons.downArrowIcon,
                                width: 12.w,
                                color: AppColors.primaryColor,
                              ),
                              isExpanded: true,
                              items: genderList.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedGender = newValue;
                                });
                              },
                            ),
                          ),
                        ),
                      ),*/
                      IconButton(
                        icon: const Icon(Icons.calendar_month),
                        onPressed: () {
                          setState(() {
                            _calendarFormat =
                                _calendarFormat == CalendarFormat.week
                                    ? CalendarFormat.month
                                    : CalendarFormat.week;
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          _showCustomBottomSheet(context);
                        },
                      ),
                    ],
                  ),
                  leftChevronIcon: SizedBox(),
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: AppColors.bottomBarColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            /* IconButton(
              icon: const Icon(Icons.calendar_view_month),
              onPressed: () {
                setState(() {
                  _calendarFormat = _calendarFormat == CalendarFormat.week
                      ? CalendarFormat.month
                      : CalendarFormat.week;
                });
             },
            ),*/
          ],
        ),
      ],
    );
  }

  //========================================> SearchDate Method <============================
  Future<void> searchDate() async {
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

  //===============================> Pup Up Bottom Sheet <===============================
  _showCustomBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.r),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.r),
              topRight: Radius.circular(40.r),
            ),
            border: Border(
                top: BorderSide(width: 2.w, color: AppColors.primaryColor)),
            color: AppColors.cardColor,
          ),
          height: 265,
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: 'Logout',
                fontWeight: FontWeight.w500,
                fontsize: 24.sp,
              ),
              SizedBox(
                  width: 115.w, child: Divider(color: AppColors.primaryColor)),
              SizedBox(height: 20.h),
              CustomText(
                text: 'Are you sure you want to log out?',
                fontsize: 16.sp,
              ),
              SizedBox(height: 20.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 115.w,
                      child: CustomButton(
                        onTap: () {
                          Get.back();
                        },
                        text: "No",
                        color: Colors.white,
                        textColor: AppColors.primaryColor,
                      )),
                  SizedBox(width: 16.w),
                  SizedBox(
                      width: 115.w,
                      child: CustomButton(
                          onTap: () {
                            // Get.offAllNamed(AppRoutes.signInScreen);
                          },
                          text: "Yes")),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
