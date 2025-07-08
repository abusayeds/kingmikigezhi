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
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/app_icons.dart';
import '../../base/bottom_menu..dart';
import 'upcoming_event_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
  String dropdownValue = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(40.h), // Adjust height as needed
      //   child: Container(
      //     padding: EdgeInsets.only(
      //       top: MediaQuery.of(context).padding.top,
      //       left: 24.w,
      //       right: 24.w,
      //     ),
      //     child: HomeAppBar(),
      //   ),
      // ),
       appBar: customHomeAppBar(),
      bottomNavigationBar: const BottomMenu(0),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.h),
              child: _searchBar(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Show dropdown menu
                      showMenu<String>(
                        context: context,
                        position: RelativeRect.fromLTRB(100, 100, 0, 0),
                        // Adjust position as needed
                        items: <String>[
                          'All',
                          'Self',
                          'Spouse',
                          'Child Stephanie',
                          'Child Sophia',
                        ].map<PopupMenuEntry<String>>((String value) {
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
                          return PopupMenuItem<String>(
                            value: value,
                            child: Container(
                              width: double.infinity,
                              color: backgroundColor,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 4.h),
                              child: Text(
                                value,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ).then((String? selectedValue) {
                        if (selectedValue != null) {
                          setState(() {
                            dropdownValue = selectedValue;
                          });
                        }
                      });
                    },
                    child: Container(
                      height: 23.h,
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            dropdownValue,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                            ),
                          ),
                          SizedBox(width: 20.w),
                          // Small space between text and icon
                          SvgPicture.asset(AppIcons.down_ArrowIcon),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: IconButton(
                      icon: Icon(Icons.add, size: 30),
                      onPressed: () {
                        HomePageAddBottomSheetWidget.addBottomSheet(context);
                      },
                    ),
                  ),
                ],
              ),
            ),

            // _tableCalendar(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.h),
              child: CalendarWithDropdown(),
            ),
            SizedBox(height: 16.h),
            //gray color event
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.h),
              child: EventCardWidget(
                eventTitle: 'Piano Song Event',
                imagePath: AppImages.logoCard,
                backgroundColor: Color(0xffAAAFAE),
                name: 'Piano',
                eventType: 'Online',
                address: 'Dhaka, Bangladesh',
                time: '7:00 AM - 8:00 PM',
                history: '2023-1st winner',
              ),
            ),
            SizedBox(height: 16.h),
            //gray color event
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.h),
              child: _pianoList(),
            ),

            SizedBox(height: 16.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Upcoming Event',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 20.sp,
                      color: Color(0xFF20353F),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.toNamed(AppRoutes.upcomingEventScreen);
                    },
                    child: Text(
                      'More',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                        color: Color(0xFF414141),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 6.w, right: 6.w),
              child: SizedBox(
                height: 275.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.eventDetailsScreen);
                      },
                      child: SizedBox(
                        width: 369.w,
                        child: EventCard(),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: 30.h,
            )
          ],
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
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
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
                borderSide:
                    BorderSide(color: AppColors.primaryColor, width: 2.w),
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
