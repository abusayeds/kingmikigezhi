import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_model.dart';
import '../services/api_service.dart';
import '../utils/api_constants.dart';

class NotificationController extends GetxController {
  final ApiService apiService;
  final SharedPreferences sharedPreferences;

  NotificationController({required this.apiService, required this.sharedPreferences});

  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxInt unreadCount = 0.obs;
  final RxBool isLoading = false.obs;

  Future<void> getNotifications() async {
    try {
      isLoading.value = true;
      update();

      final response = await apiService.get(
        ApiConstants.getMyNotification,
      );

      isLoading.value = false;
      update();

      if (response != null && response['success'] == true) {
        final notificationResponse = NotificationResponse.fromJson(response);
        notifications.value = notificationResponse.items;
        unreadCount.value = notificationResponse.unreadCount ?? 0;
      }
    } catch (e) {
      isLoading.value = false;
      update();
      Fluttertoast.showToast(
        msg: "Failed to load notifications: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<bool> markAllAsRead() async {
    try {
      isLoading.value = true;
      update();

      final response = await apiService.patch(
        ApiConstants.readAllNotification,
      );

      isLoading.value = false;
      update();

      if (response != null && response['success'] == true) {
        unreadCount.value = 0;
        notifications.value = notifications.map((n) => n.copyWith(isRead: true)).toList();

        Fluttertoast.showToast(
          msg: response['message'] ?? "All notifications marked as read",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
        return true;
      }
      return false;
    } catch (e) {
      isLoading.value = false;
      update();
      Fluttertoast.showToast(
        msg: "Failed to mark all as read: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }
}
