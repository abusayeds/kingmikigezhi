import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/connection_controller.dart';
import '../controllers/event_controller.dart';
import '../controllers/auth_controller.dart';
import '../controllers/family_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/localization_controller.dart';
import '../controllers/theme_controller.dart';
import '../controllers/splash_controller.dart';
import '../models/language_model.dart';
import '../services/api_service.dart';
import '../utils/app_constants.dart';


Future<Map<String, Map<String, String>>> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.put(sharedPreferences, permanent: true);

  // Repository - permanent to prevent deletion when navigating
  Get.put(ApiService(sharedPreferences: Get.find()), permanent: true);
  Get.put(AuthController(apiService: Get.find(), sharedPreferences: Get.find()),
      permanent: true);

  Get.put(ThemeController(sharedPreferences: Get.find()), permanent: true);
  Get.put(LocalizationController(sharedPreferences: Get.find()),
      permanent: true);
  Get.put(SplashController(sharedPreferences: Get.find(), apiService: Get.find()),
      permanent: true);
  Get.put(HomeController(apiService: Get.find(), sharedPreferences: Get.find()),
      permanent: true);
  Get.put(
      FamilyController(apiService: Get.find(), sharedPreferences: Get.find()),
      permanent: true);
  Get.put(EventController(apiService: Get.find(), sharedPreferences: Get.find()),
      permanent: true);
  Get.put(ConnectionController(sharedPreferences: Get.find(), apiService: Get.find()),
      permanent: true);

  //Retrieving localized data
  Map<String, Map<String, String>> languages = {};
  for (LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues = await rootBundle
        .loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    Map<String, String> languageJson = {};
    mappedJson.forEach((key, value) {
      languageJson[key] = value.toString();
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] =
        languageJson;
  }
  return languages;
}
