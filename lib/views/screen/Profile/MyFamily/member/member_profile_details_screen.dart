import 'package:event_sharing/helpers/route_args.dart';
import 'package:event_sharing/utils/api_constants.dart';
import 'package:event_sharing/utils/app_strings.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:event_sharing/views/base/custom_list_tile.dart';
import 'package:event_sharing/views/base/skeletons.dart';
import 'package:event_sharing/controllers/family_controller.dart';
import 'package:event_sharing/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class MemberProfileDetailsScreen extends StatefulWidget {
  const MemberProfileDetailsScreen({super.key});

  @override
  State<MemberProfileDetailsScreen> createState() =>
      _MemberProfileDetailsScreenState();
}

class _MemberProfileDetailsScreenState
    extends State<MemberProfileDetailsScreen> {
  final FamilyController _familyController = Get.find<FamilyController>();
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final userId = routeArgString('userId');
    if (userId.isEmpty) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final apiService = Get.find<ApiService>();
      final url = ApiConstants.getUserProfile.replaceAll(':userId', userId);
      final response = await apiService.get(url);

      if (response != null && response['success'] == true) {
        setState(() {
          _userData = response['data'];
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  /// Relationship comes from the family membership row, not from the user
  /// profile. Resolve it for the member being viewed and show a readable label.
  String get _relationshipLabel {
    final userId = routeArgString('userId');
    if (userId.isEmpty) return 'N/A';

    final members = [
      ..._familyController.familyMembers,
      ..._familyController.familyOwners,
    ];
    for (final member in members) {
      if (member.userId == userId) {
        return _relationDisplayName(member.relationShip);
      }
    }
    return 'N/A';
  }

  /// API enum values are not display-friendly (`Spous`, `ChildStephanie`).
  String _relationDisplayName(String? relation) {
    final value = (relation ?? '').trim();
    if (value.isEmpty) return 'N/A';
    switch (value) {
      case 'Self':
        return 'Self';
      case 'Spous':
        return 'Spouse';
      case 'ChildStephanie':
        return 'Child Stephanie';
      case 'ChildSophia':
        return 'Child Sophia';
      case 'Other':
        return 'Other';
      default:
        return value;
    }
  }

  String _formatBirthDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}-${date.month}-${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: CustomText(
          text: AppStrings.memberProfile,
          fontWeight: FontWeight.w500,
          fontsize: 18.sp,
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const ProfileSkeleton()
          : _userData == null
              ? const Center(child: Text('No data found'))
              : SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primaryColor),
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 11.h),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 120.h,
                                      width: 120.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5.r),
                                        ),
                                        shape: BoxShape.rectangle,
                                        border: Border.all(
                                            width: 2.w, color: Colors.white),
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(5.r),
                                        child: _userData!['profilePicture'] !=
                                                null
                                            ? CachedNetworkImage(
                                                imageUrl: _userData![
                                                    'profilePicture'],
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    Shimmer.fromColors(
                                                  baseColor: Colors.grey
                                                      .withOpacity(0.6),
                                                  highlightColor: Colors.grey
                                                      .withOpacity(0.3),
                                                  child: Container(
                                                    color: Colors.grey
                                                        .withOpacity(0.6),
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Container(
                                                  color: AppColors.colorEDF2F4,
                                                  child: Icon(Icons.person,
                                                      size: 50,
                                                      color:
                                                          AppColors.greyColor),
                                                ),
                                              )
                                            : Container(
                                                color: AppColors.colorEDF2F4,
                                                child: Icon(Icons.person,
                                                    size: 50,
                                                    color: AppColors.greyColor),
                                              ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            text:
                                                '${_userData!['firstName']} ${_userData!['lastName']}',
                                            textAlign: TextAlign.start,
                                            fontsize: 20.sp,
                                            color: Colors.white,
                                          ),
                                          SizedBox(height: 4.h),
                                          CustomText(
                                            text:
                                                '@${_userData!['username'] ?? ''}',
                                            textAlign: TextAlign.start,
                                            fontsize: 14.sp,
                                            color: Colors.white70,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        _buildFieldLabel('Relationship'),
                        CustomListTile(
                          backgroundColor: AppColors.colorEDF2F4,
                          title: _relationshipLabel,
                        ),
                        _buildFieldLabel('Account ID'),
                        CustomListTile(
                          backgroundColor: AppColors.colorEDF2F4,
                          title: _userData!['accountId'] ?? 'N/A',
                        ),
                        _buildFieldLabel('First Name'),
                        CustomListTile(
                          title: _userData!['firstName'] ?? 'N/A',
                          backgroundColor: AppColors.colorEDF2F4,
                        ),
                        _buildFieldLabel('Last Name'),
                        CustomListTile(
                          title: _userData!['lastName'] ?? 'N/A',
                          backgroundColor: AppColors.colorEDF2F4,
                        ),
                        _buildFieldLabel('Public Display Name'),
                        CustomListTile(
                          title: '@${_userData!['username'] ?? 'N/A'}',
                          backgroundColor: AppColors.colorEDF2F4,
                        ),
                        _buildFieldLabel('Gender'),
                        CustomListTile(
                          title: _userData!['gender'] ?? 'N/A',
                          backgroundColor: AppColors.colorEDF2F4,
                        ),
                        _buildFieldLabel('Birthday'),
                        CustomListTile(
                          title: _formatBirthDate(_userData!['birthDate']),
                          backgroundColor: AppColors.colorEDF2F4,
                        ),
                        _buildFieldLabel('Email'),
                        CustomListTile(
                          prefixIcon: Icon(Icons.email_rounded,
                              color: AppColors.primaryColor),
                          title: _userData!['email'] ?? 'N/A',
                          backgroundColor: AppColors.colorEDF2F4,
                        ),
                        _buildFieldLabel('Location'),
                        CustomListTile(
                          title: _userData!['location'] ?? 'N/A',
                          backgroundColor: AppColors.colorEDF2F4,
                        ),
                        if (_userData!['skills'] != null &&
                            (_userData!['skills'] as List).isNotEmpty) ...[
                          _buildFieldLabel('Skills'),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.colorEDF2F4,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              border: Border.all(
                                  color: AppColors.primaryColor, width: 1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: (_userData!['skills'] as List)
                                    .map<Widget>((skill) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 4.h),
                                    child: Row(
                                      children: [
                                        Text('\u2022 ',
                                            style: TextStyle(
                                                color: AppColors.primaryColor,
                                                fontSize: 16.sp)),
                                        SizedBox(width: 4.w),
                                        Expanded(
                                          child: Text(
                                            skill.toString(),
                                            style: AppStyles.fontSize14(
                                                color: AppColors.color414141),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Text(label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
    );
  }
}
