import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_strings.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:event_sharing/views/screen/Home/InnerWidget/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
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
      "title": "Snowboard Festival",
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
                SizedBox(height: 16.h),
                _greetingSection(),
                //===========================> Categories Section <======================
                SizedBox(height: 28.h),
                _sectionHeader(
                  title: AppStrings.categories,
                  onSeeAllPressed: () {},
                ),
                SizedBox(height: 139.h, child: _categoryList()),
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
    return CustomTextField(
      onTab: () => searchDate(context),
      readOnly: true,
      controller: _searchController,
      contenpaddingHorizontal: 12.w,
      contenpaddingVertical: 12.h,
      hintText: "Search",
      sufixicons: IconButton(
        onPressed: () => searchDate(context),
        icon: SvgPicture.asset(
          AppIcons.calendarIcon,
          width: 24.w,
          height: 24.h,
          color: AppColors.primaryColor,
        ),
      ),
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
            text: AppStrings.seeAll,
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
                  padding: EdgeInsets.all(8.w),
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
                                  AppIcons.timeIcon,
                                  color: AppColors.primaryColor,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5.w),
                                  child: CustomText(
                                    text: event["time"]!,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          SvgPicture.asset(
                            AppIcons.locationIcon,
                            width: 14.w,
                            height: 17.h,
                            color: AppColors.primaryColor,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5.w),
                            child: CustomText(
                              text: event["location"]!,
                              color: Colors.grey,
                              textOverflow: TextOverflow.ellipsis,
                            ),
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
