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
        try {
          final notificationResponse = NotificationResponse.fromJson(response);
          notifications.value = notificationResponse.items;
          unreadCount.value = notificationResponse.unreadCount ??
              notificationResponse.items.where((n) => n.isRead != true).length;
        } catch (_) {
          // Soft-fail parse errors so UI shows empty state instead of raw JSON toast.
          notifications.clear();
          unreadCount.value = 0;
        }
      } else {
        notifications.clear();
        unreadCount.value = 0;
      }
    } catch (e) {
      isLoading.value = false;
      notifications.clear();
      unreadCount.value = 0;
      update();
      Fluttertoast.showToast(
        msg: "Could not load notifications. Pull to refresh later.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Future<bool> markAllAsRead() async {
    if (notifications.isEmpty) {
      Fluttertoast.showToast(msg: 'No notifications to ignore');
      return false;
    }
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
