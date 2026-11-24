import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../utils/api_constants.dart';

class AboutUsController extends GetxController {
  final SharedPreferences sharedPreferences;
  final ApiService apiService;

  AboutUsController({required this.sharedPreferences, required this.apiService});

  final isLoading = false.obs;
  final title = ''.obs;
  final content = ''.obs;

  Future<void> getAboutUs() async {
    try {
      if (content.value.isEmpty) isLoading.value = true;
      final res = await apiService.get(ApiConstants.getAboutSettings);
      if (res != null && res['data'] != null) {
        final data = res['data'];
        title.value = (data['title'] ?? 'About Us').toString();
        content.value = (data['content'] ?? '').toString();
      }
    } catch (e) {
      print('getAboutUs error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
