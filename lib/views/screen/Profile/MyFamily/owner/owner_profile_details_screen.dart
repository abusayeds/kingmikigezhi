import 'package:event_sharing/helpers/route_args.dart';
import 'package:event_sharing/utils/api_constants.dart';
import 'package:event_sharing/utils/app_strings.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:event_sharing/views/base/custom_list_tile.dart';
import 'package:event_sharing/views/base/skeletons.dart';
import 'package:event_sharing/controllers/family_controller.dart';
import 'package:event_sharing/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class OwnerProfileDetailsScreen extends StatefulWidget {
  const OwnerProfileDetailsScreen({super.key});

  @override
  State<OwnerProfileDetailsScreen> createState() =>
      _OwnerProfileDetailsScreenState();
}

class _OwnerProfileDetailsScreenState extends State<OwnerProfileDetailsScreen> {
  final FamilyController _familyController = Get.find<FamilyController>();
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  /// Relationship comes from the family membership row, not the user profile.
  String get _relationshipLabel {
    final userId = routeArgString('userId');
    if (userId.isEmpty) return 'N/A';

    final members = [
      ..._familyController.familyOwners,
      ..._familyController.familyMembers,
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
        title: CustomText(
          text: AppStrings.ownerProfile,
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
                            color: const Color(0xFF285B75),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: _userData!['profilePicture'] != null
                                      ? CachedNetworkImage(
                                          imageUrl:
                                              _userData!['profilePicture'],
                                          height: 120,
                                          width: 120,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Shimmer.fromColors(
                                            baseColor:
                                                Colors.grey.withOpacity(0.6),
                                            highlightColor:
                                                Colors.grey.withOpacity(0.3),
                                            child: Container(
                                              height: 120,
                                              width: 120,
                                              color: Colors.grey
                                                  .withOpacity(0.6),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            height: 120,
                                            width: 120,
                                            color: AppColors.colorEDF2F4,
                                            child: Icon(Icons.person,
                                                size: 50,
                                                color: AppColors.greyColor),
                                          ),
                                        )
                                      : Container(
                                          height: 120,
                                          width: 120,
                                          color: AppColors.colorEDF2F4,
                                          child: Icon(Icons.person,
                                              size: 50,
                                              color: AppColors.greyColor),
                                        ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${_userData!['firstName']} ${_userData!['lastName']}',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SvgPicture.asset(AppIcons.medalStar),
                                        ],
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        '@${_userData!['username'] ?? ''}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
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
                        _buildFieldLabel('Location'),
                        CustomListTile(
                          title: _userData!['location'] ?? 'N/A',
                          backgroundColor: AppColors.colorEDF2F4,
                        ),
                        _buildFieldLabel('Email'),
                        CustomListTile(
                          prefixIcon: Icon(Icons.email_rounded,
                              color: AppColors.primaryColor),
                          title: _userData!['email'] ?? 'N/A',
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
                                            style:
                                                const TextStyle(color: Colors.black),
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
