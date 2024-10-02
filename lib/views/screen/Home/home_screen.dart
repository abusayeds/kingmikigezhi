import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/utils/app_colors.dart';
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
import '../../base/custom_text_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, String>> categories = [
    {"image": "assets/images/concert.png", "label": "Concert"},
    {"image": "assets/images/sports.png", "label": "Sports"},
    {"image": "assets/images/show.png", "label": "Show"},
    {"image": "assets/images/game.png", "label": "Game"},
    {"image": "assets/images/sports.png", "label": "Olympic"},
  ];
  final List<Map<String, String>> events = [
    {
      "date": "20 Feb",
      "title": "Basketball Game",
      "location": "Dhaka, Bangladesh",
      "time": "10:30 PM",
      "image": "assets/images/upcoming.png"
    },
    {
      "date": "21 Mar",
      "title": "Music Concert",
      "location": "Chittagong, Bangladesh",
      "time": "08:00 PM",
      "image": "assets/images/upcoming.png"
    },
    {
      "date": "15 Apr",
      "title": "Art Exhibition",
      "location": "Sylhet, Bangladesh",
      "time": "02:00 PM",
      "image": "assets/images/upcoming.png"
    }
  ];
  DateTime _focusedDay = DateTime(2024, 1, 1);
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat =
      CalendarFormat.week; // Default format is week
  String? selectedGender;
  List<String> genderList = [
    'Self',
    'Spouse',
    'Child Stephanie',
    'Child Sophia',
  ];


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
                //===========================> AppBar Section <======================
                HomeAppBar(),
                SizedBox(height: 20.h),
                _searchBar(context),
                //===============================> My Appointments Section <======================
                _tableCalendar(),
                SizedBox(height: 16.h),
                //=========================> Upcoming Event Section <=====================
                _sectionHeader(
                  title: AppStrings.upcomingEvent,
                  onSeeAllPressed: () {
                    Get.toNamed(AppRoutes.upcomingEventScreen);
                  },
                ),
                SizedBox(height: 245.h, child: _eventList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

//===============================> Search Bar Section <=========================================
  _searchBar(BuildContext context) {
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
            sufixicons: IconButton(
              onPressed: () => searchDate(context),
              icon: SvgPicture.asset(
                AppIcons.search,
                width: 24.w,
                height: 24.h,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ),
        //=========================> Filter Icon Section <==========================
        GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.filterScreen);
          },
          child: Container(
            decoration: BoxDecoration(
                color: AppColors.fillColor,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(width: 1.w, color: AppColors.primaryColor)),
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

//===============================> Hello Section <=========================================
  _greetingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomText(
              text: 'Hello Mr. Swapon',
              fontsize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.w),
              child: SvgPicture.asset(
                AppIcons.helloIcon,
                width: 16.w,
                height: 22.h,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        CustomText(
          text: AppStrings.welcomeBack,
          fontsize: 8.sp,
        ),
      ],
    );
  }

//===============================> Categories Text Section <=========================================
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

//===============================> Categories ListView Section <=========================================
  _categoryList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
          child: Column(
            children: [
              CircleAvatar(
                radius: 40.r,
                backgroundImage: AssetImage(category["image"]!),
              ),
              Text(category["label"]!),
            ],
          ),
        );
      },
    );
  }

//===============================> Upcoming Event ListView Section <=========================================
  _eventList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Card(
            color: const Color(0xffedf2f4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(6.w),
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10.r),
                        ),
                        child: Image.asset(
                          event["image"]!,
                          height: 140.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10.w,
                      top: 12.h,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryColor,
                          border: Border.all(width: 1.w, color: Colors.white),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 18.h,
                          ),
                          child: CustomText(
                            text: event["date"]!,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(5.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 270.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: event["title"]!,
                              fontWeight: FontWeight.w500,
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  AppIcons.share,
                                  color: AppColors.primaryColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.circle, color:AppColors.primaryColor, size: 8.w),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5.w),
                                    child: CustomText(
                                      text: event["location"]!,
                                      fontsize: 10.sp,
                                      color: Colors.grey,
                                      textOverflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                children: [
                                  Icon(Icons.circle, color:AppColors.primaryColor, size: 8.w),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5.w),
                                    child: CustomText(
                                      text: event["location"]!,
                                      fontsize: 10.sp,
                                      color: Colors.grey,
                                      textOverflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.circle, color:AppColors.primaryColor, size: 8.w),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5.w),
                                    child: CustomText(
                                      text: event["location"]!,
                                      fontsize: 10.sp,
                                      color: Colors.grey,
                                      textOverflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                children: [
                                  Icon(Icons.circle, color:AppColors.primaryColor, size: 8.w),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5.w),
                                    child: CustomText(
                                      text: event["location"]!,
                                      fontsize: 10.sp,
                                      color: Colors.grey,
                                      textOverflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
                            _calendarFormat = _calendarFormat == CalendarFormat.week
                                ? CalendarFormat.month
                                : CalendarFormat.week;
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {},
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
