import 'package:event_sharing/controllers/connection_controller.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_text_field.dart';
import 'package:event_sharing/views/base/pull_to_refresh.dart';
import 'package:event_sharing/views/base/skeletons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AddedConneectionScreen extends StatefulWidget {
  const AddedConneectionScreen({super.key});

  @override
  State<AddedConneectionScreen> createState() => _AddedConneectionScreenState();
}

class _AddedConneectionScreenState extends State<AddedConneectionScreen> {
  late ConnectionController connectionController;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    connectionController = Get.find<ConnectionController>();
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    connectionController.searchQuery.value = _searchController.text;
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (connectionController.hasMoreConnections.value &&
          !connectionController.isLoadingConnections.value) {
        connectionController.fetchConnections(isRefresh: false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 8.w),
            child: CustomTextField(
              controller: _searchController,
              contenpaddingHorizontal: 12.w,
              contenpaddingVertical: 12.h,
              hintText: "Search Name",
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
          Expanded(
            child: connectionController.isLoadingConnections.value &&
                    connectionController.connections.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: ConnectionListSkeleton(),
                  )
                : connectionController.getFilteredConnections().isEmpty &&
                        connectionController.connections.isEmpty
                ? PullToRefresh.empty(
                    onRefresh: () =>
                        connectionController.fetchConnections(isRefresh: true),
                    child: Center(
                      child: Text(
                        'No connections',
                        style: AppStyles.fontSize16(color: AppColors.color414141),
                      ),
                    ),
                  )
                : PullToRefresh(
                    onRefresh: () =>
                        connectionController.fetchConnections(isRefresh: true),
                    child: ListView.builder(
                    controller: _scrollController,
                    physics: PullToRefresh.alwaysScrollable(),
                    itemCount: connectionController.getFilteredConnections().length,
                    itemBuilder: (context, index) {
                      final connection =
                          connectionController.getFilteredConnections()[index];
                      final requester = connection['requester'];
                      final firstName = requester['firstName'] ?? 'Unknown';
                      final lastName = requester['lastName'] ?? '';
                      final fullName = '$firstName $lastName'.trim();
                      final email = requester['email'] ?? 'N/A';
                      final username = requester['username'] ?? 'N/A';

                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.h,
                          horizontal: 4.h,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 45.r,
                                    backgroundColor: Colors.grey.shade300,
                                    child: const Icon(Icons.person,
                                        size: 40, color: Colors.white),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          fullName,
                                          style: AppStyles.fontSize16(
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.color414141,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              AppIcons.dotIconForFamily,
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                'Username: $username',
                                                style:
                                                    AppStyles.fontSize10(
                                                  color:
                                                      AppColors.color414141,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              AppIcons.dotIconForFamily,
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                'Email: $email',
                                                style:
                                                    AppStyles.fontSize10(
                                                  color:
                                                      AppColors.color414141,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              CustomButton(
                                onTap: () {
                                  _showCustomDeleteBottomSheet(
                                    context,
                                    connection['id'],
                                    fullName,
                                  );
                                },
                                text: 'Remove',
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                color: AppColors.colorD9A951,
                                borderColor: AppColors.colorD9A951,
                                textColor: AppColors.textColor,
                              ),
                              const SizedBox(width: 10),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Divider(
                                  thickness: 0.5,
                                  color: AppColors.greyColor,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  ),
          ),
          if (connectionController.isLoadingConnections.value &&
              connectionController.connections.isNotEmpty)
            const ListLoadMoreSkeleton(),
        ],
      )),
    );
  }

  void _showCustomDeleteBottomSheet(BuildContext context, String connectionId,
      String connectionName) {
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
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
            color: AppColors.backgroundColor,
          ),
          height: 265,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Divider(thickness: 1, color: AppColors.greyColor),
              SizedBox(height: 20.h),
              Text(
                "Remove",
                style: AppStyles.fontSize20(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Are you sure to remove $connectionName ??",
                style: AppStyles.fontSize18(color: AppColors.borderColor),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 58),
                        backgroundColor: AppColors.colorEDF2F4,
                        side: BorderSide(width: 1, color: AppColors.greyColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: AppStyles.fontSize16(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        connectionController.removeConnection(connectionId);
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 58),
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                      ),
                      child: Text(
                        'Yes',
                        style: AppStyles.fontSize16(
                          color: AppColors.backgroundColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
