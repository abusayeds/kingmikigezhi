import 'package:event_sharing/controllers/settings_controller.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsController _controller = Get.find<SettingsController>();

  // Language is always English (US) — backend only accepts en-US
  final String _language = 'English (US)';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        _controller.fetchSettingsOptions(),
        _controller.fetchSettings(),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 18.w),
          onPressed: () => Get.back(),
        ),
        title: CustomText(
          text: 'Settings',
          fontWeight: FontWeight.w500,
          fontsize: 18.sp,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (_controller.isLoadingSettings.value ||
            _controller.isLoadingOptions.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h),

                //============ Display Language (read-only, always English US) ============
                _sectionLabel('Display language'),
                _staticField(_language),

                //============ Date Time Format ============
                _sectionLabel('Date time format'),
                _dropdown(
                  hint: 'Select Date Time',
                  value: _controller.dateTimeFormat.value.isEmpty
                      ? null
                      : _controller.dateTimeFormat.value,
                  options: _controller.dateTimeFormatOptions,
                  onChanged: (v) => _controller.dateTimeFormat.value = v ?? '',
                ),

                //============ Time Zone ============
                _sectionLabel('Time zone'),
                _dropdown(
                  hint: 'Select Time Zone',
                  value: _controller.timeZone.value.isEmpty
                      ? null
                      : _controller.timeZone.value,
                  options: _controller.timeZoneOptions,
                  onChanged: (v) => _controller.timeZone.value = v ?? '',
                ),

                //============ Currency ============
                _sectionLabel('Currency'),
                _dropdown(
                  hint: 'Select Currency',
                  value: _controller.currency.value.isEmpty
                      ? null
                      : _controller.currency.value,
                  options: _controller.currencyOptions,
                  onChanged: (v) => _controller.currency.value = v ?? '',
                ),

                SizedBox(height: 14.h),
                Divider(thickness: .5, color: AppColors.color808080),

                //============ Notifications ============
                _sectionLabel('Notifications'),
                _dropdown(
                  hint: 'Select Notifications',
                  value: _controller.notifications.value.isEmpty
                      ? null
                      : _controller.notifications.value,
                  options: _controller.notificationOptions,
                  onChanged: (v) => _controller.notifications.value = v ?? '',
                ),

                SizedBox(height: 14.h),

                //============ Event Share ============
                _sectionLabel('Event Share'),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email', style: AppStyles.fontSize14()),
                          SizedBox(height: 8.h),
                          _compactDropdown(
                            hint: 'Select',
                            value: _controller.eventShareEmail.value.isEmpty
                                ? null
                                : _controller.eventShareEmail.value,
                            options: _controller.eventShareEmailOptions,
                            onChanged: (v) =>
                                _controller.eventShareEmail.value = v ?? '',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.w),
                    // SMS not supported by backend — show disabled
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('SMS', style: AppStyles.fontSize14()),
                          SizedBox(height: 8.h),
                          _staticField('Not available', small: true),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                //============ Applied Event Update ============
                _sectionLabel('Applied Event Update'),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email', style: AppStyles.fontSize14()),
                          SizedBox(height: 8.h),
                          _compactDropdown(
                            hint: 'Select',
                            value: _controller
                                    .appliedEventUpdateEmail.value.isEmpty
                                ? null
                                : _controller.appliedEventUpdateEmail.value,
                            options:
                                _controller.appliedEventUpdateEmailOptions,
                            onChanged: (v) => _controller
                                .appliedEventUpdateEmail.value = v ?? '',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.w),
                    // SMS not supported by backend
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('SMS', style: AppStyles.fontSize14()),
                          SizedBox(height: 8.h),
                          _staticField('Not available', small: true),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                //============ Save Button ============
                Obx(() => CustomButton(
                      onTap: () => _controller.saveSettings(),
                      text: 'Save Settings',
                      color: AppColors.buttonColor,
                      textColor: Colors.white,
                      loading: _controller.isSaving.value,
                    )),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ── Helpers ──────────────────────────────────────────────

  Widget _sectionLabel(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Text(
        text,
        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
      ),
    );
  }

  /// Full-height dropdown (for top sections)
  Widget _dropdown({
    required String hint,
    required String? value,
    required RxList<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Obx(() => SizedBox(
          height: AppStyles.standardHeight,
          child: InputDecorator(
            decoration: InputDecoration(
              fillColor: AppColors.fillColor,
              filled: true,
              border: OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppColors.primaryColor, width: 1.w),
                borderRadius: BorderRadius.circular(8.r),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppColors.primaryColor, width: 1.w),
                borderRadius: BorderRadius.circular(8.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppColors.primaryColor, width: 1.w),
                borderRadius: BorderRadius.circular(8.r),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                padding: EdgeInsets.symmetric(vertical: 5.h),
                iconDisabledColor: AppColors.primaryColor,
                iconEnabledColor: AppColors.primaryColor,
                icon: SvgPicture.asset(
                  AppIcons.downArrowIcon,
                  colorFilter: ColorFilter.mode(
                      AppColors.primaryColor, BlendMode.srcIn),
                ),
                isExpanded: true,
                value: options.contains(value) ? value : null,
                hint: CustomText(
                    text: hint,
                    fontsize: 14.sp,
                    color: AppColors.color666666),
                items: options
                    .map((o) =>
                        DropdownMenuItem<String>(value: o, child: Text(o)))
                    .toList(),
                onChanged: options.isNotEmpty ? onChanged : null,
              ),
            ),
          ),
        ));
  }

  /// Compact dropdown (for side-by-side sections)
  Widget _compactDropdown({
    required String hint,
    required String? value,
    required RxList<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Obx(() => Container(
          height: 52.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderColor),
            borderRadius: BorderRadius.circular(8.r),
            color: AppColors.fillColor,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              padding: EdgeInsets.symmetric(vertical: 5.h),
              icon: SvgPicture.asset(
                AppIcons.downArrowIcon,
                colorFilter: ColorFilter.mode(
                    AppColors.primaryColor, BlendMode.srcIn),
              ),
              isExpanded: true,
              value: options.contains(value) ? value : null,
              hint: Text(
                hint,
                style: TextStyle(
                    color: AppColors.color414141, fontSize: 14.sp),
              ),
              items: options
                  .map((o) =>
                      DropdownMenuItem<String>(value: o, child: Text(o)))
                  .toList(),
              onChanged: options.isNotEmpty ? onChanged : null,
            ),
          ),
        ));
  }

  /// Static read-only display field
  Widget _staticField(String text, {bool small = false}) {
    return Container(
      height: small ? 52.h : AppStyles.standardHeight,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.fillColor,
        border: Border.all(color: AppColors.primaryColor, width: 1.w),
        borderRadius: BorderRadius.circular(8.r),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
            fontSize: 14.sp, color: AppColors.color414141),
      ),
    );
  }
}
