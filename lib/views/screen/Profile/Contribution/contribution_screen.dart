import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_sharing/controllers/contribution_controller.dart';
import 'package:event_sharing/views/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../helpers/route.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/style.dart';

class MyContributionScreen extends StatefulWidget {
  const MyContributionScreen({super.key});

  @override
  State<MyContributionScreen> createState() => _MyContributionScreenState();
}

class _MyContributionScreenState extends State<MyContributionScreen> {
  final ContributionController _controller =
      Get.find<ContributionController>();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.fetchContributions();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _controller.fetchContributions(isLoadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  String _formatDeadline(String? deadline) {
    if (deadline == null) return '-';
    try {
      final dt = DateTime.parse(deadline);
      return DateFormat('d-M-yyyy').format(dt);
    } catch (_) {
      return deadline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
              'Total ${_controller.total.value} Contribution',
              style: TextStyle(
                  fontSize: 18.sp, fontWeight: FontWeight.bold),
            )),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 18.w),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            //==============================> Meta Label <=======================
            Obx(() => Text(
                  _controller.metaLabel.value.isNotEmpty
                      ? _controller.metaLabel.value
                      : 'All Contributions',
                )),
            SizedBox(height: 16.h),
            _searchBar(),
            SizedBox(height: 16.h),
            //=================================> Event List view <========================
            Expanded(
              child: Obx(() {
                if (_controller.isLoading.value &&
                    _controller.contributions.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (_controller.contributions.isEmpty) {
                  return const Center(
                      child: Text('No contributions found'));
                }
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: _controller.contributions.length +
                      (_controller.hasNext.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _controller.contributions.length) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: const Center(
                            child: CircularProgressIndicator()),
                      );
                    }
                    final item = _controller.contributions[index];
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.eventDetailsScreen,
                            arguments: item.id);
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 8.h),
                        decoration: BoxDecoration(
                          color: const Color(0xffedf2f4),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: AppColors.colorC8D7DE,
                            width: 1.0,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 8.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //=====================> Event Image <=========================
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(10.r),
                                child: item.imageUrl != null &&
                                        item.imageUrl!.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: item.imageUrl!,
                                        height: 75.0.h,
                                        width: 75.0.w,
                                        fit: BoxFit.cover,
                                        placeholder: (_, __) => Container(
                                          height: 75.h,
                                          width: 75.w,
                                          color: AppColors.fillColor,
                                          child: const Center(
                                              child:
                                                  CircularProgressIndicator(
                                                      strokeWidth: 2)),
                                        ),
                                        errorWidget: (_, __, ___) =>
                                            Container(
                                          height: 75.h,
                                          width: 75.w,
                                          color: AppColors.fillColor,
                                          child: Icon(
                                              Icons.broken_image,
                                              color: AppColors.greyColor),
                                        ),
                                      )
                                    : Container(
                                        height: 75.h,
                                        width: 75.w,
                                        color: AppColors.fillColor,
                                        child: Icon(Icons.image,
                                            color: AppColors.greyColor),
                                      ),
                              ),
                              SizedBox(width: 16.w),
                              //=====================> Event Details <=========================
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: AppStyles.fontSize14(
                                          fontWeight: FontWeight.w600),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 10.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Left column
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _infoRow(
                                                '${item.type ?? '-'} Event'),
                                            SizedBox(height: 6.h),
                                            _infoRow(
                                                item.location ?? '-'),
                                            SizedBox(height: 6.h),
                                            _infoRow(
                                                'History: ${item.history ?? '-'}'),
                                          ],
                                        ),
                                        // Right column
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            _infoRow(
                                                'Cost: \$${item.cost ?? '-'}'),
                                            SizedBox(height: 6.h),
                                            _infoRow(
                                                'Deadline: ${_formatDeadline(item.deadline)}'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              //=====================> Share Icon <=========================
                              Padding(
                                padding: EdgeInsets.only(top: 8.h),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.toNamed(
                                            AppRoutes.myInvitationPage);
                                      },
                                      child: SvgPicture.asset(
                                        AppIcons.share,
                                        width: 16.w,
                                        height: 16.h,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                    SizedBox(height: 48.h),
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Icon(Icons.more_horiz,
                                            color: Colors.grey),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String text) {
    return Row(
      children: [
        SvgPicture.asset(AppIcons.dotIconForFamily),
        SizedBox(width: 4.w),
        Text(text, style: TextStyle(fontSize: 8.sp)),
      ],
    );
  }

  //============================> Search Bar Section <=================================
  Widget _searchBar() {
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
            onChanged: (value) {
              _controller.searchQuery.value = value;
            },
            sufixicons: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: GestureDetector(
                onTap: () {
                  _controller.fetchContributions(
                      search: _searchController.text.trim());
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
            final result =
                await Get.toNamed(AppRoutes.contributionFilterScreen);
            if (result != null && result is Map<String, dynamic>) {
              _controller.applyFilters(
                programId: result['programId'],
                type: result['type'],
                location: result['location'],
                categoryGroup: result['categoryGroup'],
                timeRange: result['timeRange'],
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
              padding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
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
}
