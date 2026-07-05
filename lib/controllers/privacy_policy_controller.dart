import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../utils/api_constants.dart';

class PrivacyPolicyController extends GetxController {
  final SharedPreferences sharedPreferences;
  final ApiService apiService;

  PrivacyPolicyController({required this.sharedPreferences, required this.apiService});

  final isLoading = false.obs;
  final title = ''.obs;
  final content = ''.obs;

  Future<void> getPrivacy() async {
    try {
      isLoading.value = true;
      final res = await apiService.get(ApiConstants.getPrivacySettings);
      if (res != null && res['data'] != null) {
        final data = res['data'];
        title.value = (data['title'] ?? 'Privacy Policy').toString();
        content.value = (data['content'] ?? '').toString();
      }
    } catch (e) {
      print('getPrivacy error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
