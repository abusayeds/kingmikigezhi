import 'package:event_sharing/controllers/auth_controller.dart';
import 'package:event_sharing/controllers/family_controller.dart';
import 'package:event_sharing/controllers/home_controller.dart';
import 'package:event_sharing/controllers/notification_controller.dart';
import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/models/family_model.dart';
import 'package:event_sharing/utils/app_colors.dart';
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
  final AuthController _authController = Get.find<AuthController>();
  final HomeController _homeController = Get.find<HomeController>();
  final FamilyController _familyController = Get.find<FamilyController>();
  final NotificationController _notificationController =
      Get.find<NotificationController>();
  final TextEditingController _searchController = TextEditingController();

  /// Display label shown on the filter chip.
  String dropdownValue = 'Self';

  /// API relationShip value used for fetching.
  String _selectedRelationShip = 'Self';

  final List<Color> _memberColors = [
    AppColors.color67AB9F,
    AppColors.colorE5CCFF,
    AppColors.colorCCFFE6,
    AppColors.colorFFF2CC,
    const Color(0xffAAAFAE),
    const Color(0xffC8D7DE),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authController.fetchUserProfile();
      _homeController.fetchTodayEvents();
      _homeController.fetchFamilyEvents('Self');
      _homeController.fetchUpcomingEvents();
      _notificationController.getNotifications();
      _loadFamilyMembersForFilter();
    });
  }

  Future<void> _loadFamilyMembersForFilter() async {
    try {
      await _familyController.fetchFamilies(showErrorToast: false);
      if (_familyController.families.isEmpty) return;
      final familyId = _familyController.families.first.id;
      await _familyController.fetchFamilyMembers(
        familyId,
        showErrorToast: false,
      );
    } catch (_) {}
  }

  bool get _hasFamilyMemberFilters =>
      _familyController.familyMembers.any((m) {
        final r = (m.relationShip ?? '').trim();
        return r.isNotEmpty && r != 'Self';
      });

  String _relationDisplayName(String? relation) {
    switch (relation) {
      case 'Spous':
        return 'Spouse';
      case 'ChildStephanie':
        return 'Child Stephanie';
      case 'ChildSophia':
        return 'Child Sophia';
      case 'Self':
        return 'Self';
      case 'Other':
        return 'Other';
      default:
        return relation?.isNotEmpty == true ? relation! : 'Member';
    }
  }

  String _memberLabel(FamilyMemberModel member) {
    final name = [
      member.user?.firstName,
      member.user?.lastName,
    ].whereType<String>().where((e) => e.trim().isNotEmpty).join(' ');
    final relation = _relationDisplayName(member.relationShip);
    if (name.isNotEmpty) return '$name ($relation)';
    return relation;
  }

  List<({String label, String relationShip})> _filterOptions() {
    final options = <({String label, String relationShip})>[
      (label: 'Self', relationShip: 'Self'),
    ];
    final seen = <String>{'Self'};
    for (final member in _familyController.familyMembers) {
      final relation = (member.relationShip ?? '').trim();
      if (relation.isEmpty || relation == 'Self') continue;
      final key = relation.isNotEmpty ? relation : member.userId;
      if (seen.contains(key)) continue;
      seen.add(key);
      options.add((label: _memberLabel(member), relationShip: relation));
    }
    return options;
  }

  Color _colorForRelation(String relation) {
    final options = _filterOptions();
    final index = options.indexWhere((o) => o.relationShip == relation);
    if (index < 0) return const Color(0xffAAAFAE);
    return _memberColors[index % _memberColors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Obx(() {
                    if (!_hasFamilyMemberFilters) {
                      return Container(
                        height: 23.h,
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Self',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                          ),
                        ),
                      );
                    }
                    return GestureDetector(
                      onTap: () async {
                        if (_familyController.familyMembers.isEmpty) {
                          await _loadFamilyMembersForFilter();
                        }
                        if (!mounted) return;
                        final options = _filterOptions();
                        final selected = await showMenu<String>(
                          context: context,
                          position: const RelativeRect.fromLTRB(100, 100, 0, 0),
                          items: options.map<PopupMenuEntry<String>>((option) {
                            final backgroundColor =
                                _colorForRelation(option.relationShip);
                            return PopupMenuItem<String>(
                              value: option.relationShip,
                              child: Container(
                                width: double.infinity,
                                color: backgroundColor,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 4.h),
                                child: Text(
                                  option.label,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                        if (selected != null) {
                          final match = options.firstWhere(
                            (o) => o.relationShip == selected,
                            orElse: () =>
                                (label: selected, relationShip: selected),
                          );
                          setState(() {
                            dropdownValue = match.label;
                            _selectedRelationShip = match.relationShip;
                          });
                          _homeController.fetchFamilyEvents(match.relationShip);
                        }
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
                            SvgPicture.asset(AppIcons.down_ArrowIcon),
                          ],
                        ),
                      ),
                    );
                  }),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: IconButton(
                      icon: const Icon(Icons.add, size: 30),
                      onPressed: () {
                        HomePageAddBottomSheetWidget.addBottomSheet(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.h),
              child: const CalendarWithDropdown(),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.h),
              child: SizedBox(
                height: 160.h,
                child: Obx(() {
                  if (_homeController.isLoadingToday.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (_homeController.todayEvents.isEmpty) {
                    return const Center(child: Text("No events today"));
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _homeController.todayEvents.length,
                    itemBuilder: (context, index) {
                      final event = _homeController.todayEvents[index];
                      return Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: EventCardWidget(
                          eventModel: event,
                          backgroundColor: const Color(0xffAAAFAE),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
            SizedBox(height: 16.h),
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
                      color: const Color(0xFF20353F),
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
                        color: const Color(0xFF414141),
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
                child: Obx(() {
                  if (_homeController.isLoadingUpcoming.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (_homeController.upcomingEvents.isEmpty) {
                    return const Center(child: Text("No upcoming events"));
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _homeController.upcomingEvents.length,
                    itemBuilder: (context, index) {
                      final event = _homeController.upcomingEvents[index];
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoutes.eventDetailsScreen,
                              arguments: event);
                        },
                        child: SizedBox(
                          width: 369.w,
                          child: EventCard(eventModel: event),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: TextFormField(
            controller: _searchController,
            onFieldSubmitted: (value) {
              if (value.isNotEmpty) {
                Get.toNamed(AppRoutes.searchEventScreen,
                    arguments: {'searchTerm': value});
              }
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.fillColor,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              hintText: "Search Event",
              hintStyle: AppStyles.fontSize14(color: AppColors.greyColor),
              suffixIcon: IconButton(
                onPressed: () {
                  final term = _searchController.text.trim();
                  if (term.isNotEmpty) {
                    Get.toNamed(AppRoutes.searchEventScreen,
                        arguments: {'searchTerm': term});
                  }
                },
                icon: SvgPicture.asset(
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
          onTap: () async {
            final result = await Get.toNamed(AppRoutes.filterScreen);
            if (result != null) {
              Get.toNamed(AppRoutes.searchEventScreen, arguments: result);
            }
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

  Widget _pianoList() {
    final selectedColor = _colorForRelation(_selectedRelationShip);

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 180.h,
      child: Obx(() {
        if (_homeController.isLoadingFamily.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_homeController.familyEvents.isEmpty) {
          return const Center(child: Text("No events found"));
        }
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _homeController.familyEvents.length,
          itemBuilder: (context, index) {
            final event = _homeController.familyEvents[index];
            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: EventCardWidget(
                eventModel: event,
                backgroundColor: selectedColor,
              ),
            );
          },
        );
      }),
    );
  }
}
