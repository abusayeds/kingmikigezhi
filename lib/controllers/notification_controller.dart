import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/notification_navigator.dart';
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

  /// [force] only shows a loader when the list is empty (silent revisit).
  Future<void> getNotifications({bool force = false}) async {
    try {
      if (force || notifications.isEmpty) {
        isLoading.value = notifications.isEmpty;
      }
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
          if (notifications.isEmpty) {
            notifications.clear();
            unreadCount.value = 0;
          }
        }
      } else if (notifications.isEmpty) {
        notifications.clear();
        unreadCount.value = 0;
      }
    } catch (e) {
      isLoading.value = false;
      if (notifications.isEmpty) {
        notifications.clear();
        unreadCount.value = 0;
      }
      update();
      Fluttertoast.showToast(
        msg: "Could not load notifications. Pull to refresh later.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Future<void> markAsRead(String notificationId) async {
    if (notificationId.isEmpty) return;
    try {
      await apiService.patch(
        ApiConstants.readNotification(notificationId),
        body: {},
      );
      final idx = notifications.indexWhere((n) => n.id == notificationId);
      if (idx >= 0 && notifications[idx].isRead != true) {
        notifications[idx] = notifications[idx].copyWith(isRead: true);
        notifications.refresh();
        if (unreadCount.value > 0) unreadCount.value--;
      }
    } catch (_) {
      // Non-blocking — navigation should still proceed.
    }
  }

  Future<void> openNotification(NotificationModel notification) async {
    final id = notification.id;
    if (id != null && notification.isRead != true) {
      await markAsRead(id);
    }
    await NotificationNavigator.open(notification);
  }

  Future<bool> markAllAsRead() async {
    if (notifications.isEmpty) {
      Fluttertoast.showToast(msg: 'No notifications to ignore');
      return false;
    }
    try {
      final response = await apiService.patch(
        ApiConstants.readAllNotification,
        body: {},
      );

      if (response != null && response['success'] == true) {
        unreadCount.value = 0;
        notifications.value =
            notifications.map((n) => n.copyWith(isRead: true)).toList();

        Fluttertoast.showToast(
          msg: response['message'] ?? "All notifications marked as read",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
        return true;
      }
      return false;
    } catch (e) {
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
