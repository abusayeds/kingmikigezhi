import 'package:event_sharing/views/base/app_remote_image.dart';
import 'package:event_sharing/views/base/custom_text_field.dart';
import 'package:event_sharing/views/base/pull_to_refresh.dart';
import 'package:event_sharing/views/base/skeletons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../helpers/event_actions.dart';
import '../../../../../helpers/route.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_icons.dart';
import '../../../../utils/style.dart';
import '../../../../../controllers/home_controller.dart';
import '../../../../../models/event_model.dart';

/// "My Event" — events the signed-in user created.
///
/// This is deliberately separate from the Event screen, which shows universal
/// community events. Reached from Profile → My Event.
///
/// Set [standalone] to false when embedding inside another Scaffold/tab.
class MyCreatedEventScreen extends StatefulWidget {
  final bool standalone;

  const MyCreatedEventScreen({super.key, this.standalone = true});

  @override
  State<MyCreatedEventScreen> createState() => _MyCreatedEventScreenState();
}

class _MyCreatedEventScreenState extends State<MyCreatedEventScreen> {
  final HomeController _homeController = Get.find<HomeController>();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _homeController.fetchCreatedEvents();
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _homeController.fetchCreatedEvents(isLoadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final body = Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10),
      child: Column(
        children: [
          _searchBar(),
          SizedBox(height: 16.h),
          Expanded(
            child: Obx(() {
              if (_homeController.isLoadingCreated.value &&
                  _homeController.createdEvents.isEmpty) {
                return const EventListSkeleton();
              }
              if (_homeController.createdEvents.isEmpty) {
                return PullToRefresh.empty(
                  onRefresh: () =>
                      _homeController.fetchCreatedEvents(force: true),
                  child: const Center(child: Text("No events created yet")),
                );
              }
              return PullToRefresh(
                onRefresh: () =>
                    _homeController.fetchCreatedEvents(force: true),
                child: ListView.builder(
                  controller: _scrollController,
                  physics: PullToRefresh.alwaysScrollable(),
                  itemCount: _homeController.createdEvents.length +
                      (_homeController.createdHasNext.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _homeController.createdEvents.length) {
                      return const ListLoadMoreSkeleton();
                    }
                    final EventModel event =
                        _homeController.createdEvents[index];
                    return _eventCard(event);
                  },
                ),
              );
            }),
          )
        ],
      ),
    );

    if (!widget.standalone) {
      return Scaffold(backgroundColor: Colors.white, body: body);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 18.w),
          onPressed: Get.back,
        ),
        title: Text('My Event',
            style: AppStyles.fontSize18(fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: body,
    );
  }

  Widget _eventCard(EventModel event) {
    String deadline = '';
    if (event.schedule?.deadline != null) {
      deadline = DateFormat('d-M-yyyy').format(event.schedule!.deadline!);
    }

    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.eventDetailsScreen, arguments: event);
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xffedf2f4),
              border: Border.all(color: AppColors.colorC8D7DE, width: 1.w),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: AppRemoteImage(
                      url: event.coverImage,
                      height: 75.0.h,
                      width: 75.0.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(event.eventName ?? '',
                            style: AppStyles.fontSize14(
                                fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _infoRow(event.schedule?.eventType ??
                                      'Onsite Event'),
                                  _infoRow(event.location ?? '—'),
                                  if (_historyLabel(event) != null)
                                    _infoRow(_historyLabel(event)!,
                                        color: AppColors.color808080),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _infoRow(
                                    'Cost: \$${event.schedule?.cost ?? '0'}'),
                                if (deadline.isNotEmpty)
                                  _infoRow('Deadline: $deadline'),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => openEventInvitationPage(event),
                    child: SvgPicture.asset(
                      AppIcons.share,
                      width: 16.w,
                      height: 16.h,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: GestureDetector(
              onTap: () {},
              child: EventMoreMenuButton(
                event: event,
                iconColor: AppColors.greyColor,
                forceOwnerActions: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Best achievement recorded for this event, when there is one.
  String? _historyLabel(EventModel event) {
    final records = event.previousEvents;
    if (records == null || records.isEmpty) return null;
    final name = records.first.recordName?.trim();
    if (name == null || name.isEmpty) return null;
    return 'History: $name';
  }

  Widget _infoRow(String text, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          SvgPicture.asset(AppIcons.dotIconForFamily),
          SizedBox(width: 4.w),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 8.sp,
                color: color ?? AppColors.color414141,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
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
            hintText: "Search Event",
            onFieldSubmitted: (value) {
              if (value.isNotEmpty) {
                Get.toNamed(AppRoutes.searchEventScreen,
                    arguments: {'searchTerm': value});
              }
            },
            sufixicons: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: GestureDetector(
                onTap: () {
                  if (_searchController.text.isNotEmpty) {
                    Get.toNamed(AppRoutes.searchEventScreen,
                        arguments: {'searchTerm': _searchController.text});
                  }
                },
                child: SvgPicture.asset(
                  AppIcons.search,
                  width: 24.w,
                  height: 24.h,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            final result = await Get.toNamed(AppRoutes.myEventFilterScreen);
            if (result is Map && result.isNotEmpty) {
              Get.toNamed(
                AppRoutes.searchEventScreen,
                arguments: Map<String, dynamic>.from(result),
              );
            }
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
