import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../utils/api_constants.dart';

class SettingsController extends GetxController {
  final SharedPreferences sharedPreferences;
  final ApiService apiService;

  SettingsController({required this.sharedPreferences, required this.apiService});

  // Loading states
  final RxBool isLoadingSettings = false.obs;
  final RxBool isLoadingOptions = false.obs;
  final RxBool isSaving = false.obs;

  // Current settings values from GET /user-settings
  final RxString dateTimeFormat = ''.obs;
  final RxString timeZone = ''.obs;
  final RxString currency = ''.obs;
  final RxString notifications = ''.obs;
  final RxString eventShareEmail = ''.obs;
  final RxString appliedEventUpdateEmail = ''.obs;

  // Dropdown options from GET /user-settings/options
  final RxList<String> dateTimeFormatOptions = <String>[].obs;
  final RxList<String> timeZoneOptions = <String>[].obs;
  final RxList<String> currencyOptions = <String>[].obs;
  final RxList<String> notificationOptions = <String>[].obs;
  final RxList<String> eventShareEmailOptions = <String>[].obs;
  final RxList<String> appliedEventUpdateEmailOptions = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  /// Fetch current saved settings
  Future<void> fetchSettings() async {
    try {
      if (dateTimeFormat.value.isEmpty &&
          timeZone.value.isEmpty &&
          currency.value.isEmpty) {
        isLoadingSettings.value = true;
      }
      final response = await apiService.get(ApiConstants.getUserSettings);
      if (response != null && response['success'] == true) {
        final data = response['data'] ?? {};
        dateTimeFormat.value = data['dateTimeFormat'] ?? '';
        timeZone.value = data['timeZone'] ?? '';
        currency.value = data['currency'] ?? '';
        notifications.value = data['notifications'] ?? '';
        eventShareEmail.value = data['eventShareEmail'] ?? '';
        appliedEventUpdateEmail.value = data['appliedEventUpdateEmail'] ?? '';
      }
    } catch (e) {
      print('fetchSettings error: $e');
    } finally {
      isLoadingSettings.value = false;
    }
  }

  /// Fetch dropdown options
  Future<void> fetchSettingsOptions() async {
    try {
      if (dateTimeFormatOptions.isEmpty) {
        isLoadingOptions.value = true;
      }
      final response = await apiService.get(ApiConstants.getUserSettingsOptions);
      if (response != null && response['success'] == true) {
        final data = response['data'] ?? {};

        dateTimeFormatOptions.value =
            _extractList(data['dateTimeFormats']);
        timeZoneOptions.value =
            _extractList(data['timeZones']);
        currencyOptions.value =
            _extractList(data['currencies']);
        notificationOptions.value =
            _extractList(data['notifications']);
        eventShareEmailOptions.value =
            _extractList(data['eventShareEmail']);
        appliedEventUpdateEmailOptions.value =
            _extractList(data['appliedEventUpdateEmail']);
      }
    } catch (e) {
      print('fetchSettingsOptions error: $e');
    } finally {
      isLoadingOptions.value = false;
    }
  }

  /// Helper — extract string list from option items
  /// Handles both plain string arrays and [{value, label}] arrays
  List<String> _extractList(dynamic raw) {
    if (raw == null) return [];
    if (raw is List) {
      return raw.map((item) {
        if (item is String) return item;
        if (item is Map) return (item['value'] ?? item['label'] ?? '').toString();
        return item.toString();
      }).where((s) => s.isNotEmpty).toList();
    }
    return [];
  }

  /// Save settings via PATCH
  Future<bool> saveSettings() async {
    try {
      isSaving.value = true;

      final Map<String, dynamic> body = {};
      if (dateTimeFormat.value.isNotEmpty) body['dateTimeFormat'] = dateTimeFormat.value;
      if (timeZone.value.isNotEmpty) body['timeZone'] = timeZone.value;
      if (currency.value.isNotEmpty) body['currency'] = currency.value;
      if (notifications.value.isNotEmpty) body['notifications'] = notifications.value;
      if (eventShareEmail.value.isNotEmpty) body['eventShareEmail'] = eventShareEmail.value;
      if (appliedEventUpdateEmail.value.isNotEmpty) {
        body['appliedEventUpdateEmail'] = appliedEventUpdateEmail.value;
      }

      final response = await apiService.patch(
        ApiConstants.updateUserSettings,
        body: body,
      );

      isSaving.value = false;

      if (response != null && response['success'] == true) {
        Fluttertoast.showToast(
          msg: response['message'] ?? 'Settings saved successfully!',
          gravity: ToastGravity.BOTTOM,
        );
        return true;
      }
      return false;
    } catch (e) {
      isSaving.value = false;
      Fluttertoast.showToast(
        msg: 'Failed to save settings: $e',
        gravity: ToastGravity.BOTTOM,
      );
      return false;
    }
  }
}
