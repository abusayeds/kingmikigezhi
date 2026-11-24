import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../utils/api_constants.dart';

class TermsConditionsController extends GetxController {
  final SharedPreferences sharedPreferences;
  final ApiService apiService;

  TermsConditionsController({required this.sharedPreferences, required this.apiService});

  final isLoading = false.obs;
  final title = ''.obs;
  final content = ''.obs;

  Future<void> getTermsCondition() async {
    try {
      if (content.value.isEmpty) isLoading.value = true;
      final res = await apiService.get(ApiConstants.getTermsSettings);
      if (res != null && res['data'] != null) {
        final data = res['data'];
        title.value = (data['title'] ?? 'Terms & Conditions').toString();
        content.value = (data['content'] ?? '').toString();
      }
    } catch (e) {
      print('getTermsCondition error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
