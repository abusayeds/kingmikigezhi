import 'package:event_sharing/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

/// Friendly, consistent validation / status feedback for the whole app.
/// Prefer this over raw Fluttertoast / Get.snackbar("Error", ...).
class AppFeedback {
  AppFeedback._();

  static void validation(
    String message, {
    String title = 'Almost there',
  }) {
    _snack(
      title: title,
      message: message,
      background: const Color(0xFF4C7E95),
      icon: Icons.info_outline_rounded,
    );
  }

  static void success(
    String message, {
    String title = 'Done',
  }) {
    _snack(
      title: title,
      message: message,
      background: const Color(0xFF2E7D32),
      icon: Icons.check_circle_outline_rounded,
    );
  }

  static void error(
    String message, {
    String title = 'Something went wrong',
  }) {
    final clean = _friendlyMessage(message);
    _snack(
      title: title,
      message: clean,
      background: const Color(0xFFC62828),
      icon: Icons.error_outline_rounded,
    );
  }

  static void info(
    String message, {
    String title = 'Heads up',
  }) {
    _snack(
      title: title,
      message: message,
      background: AppColors.primaryColor,
      icon: Icons.notifications_none_rounded,
    );
  }

  /// Lightweight toast fallback when a snackbar would be too heavy.
  static void toast(String message, {bool isError = false}) {
    Fluttertoast.showToast(
      msg: _friendlyMessage(message),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: isError ? const Color(0xFFC62828) : const Color(0xFF333333),
      textColor: Colors.white,
      fontSize: 14,
    );
  }

  static void _snack({
    required String title,
    required String message,
    required Color background,
    required IconData icon,
  }) {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    Get.snackbar(
      title,
      _friendlyMessage(message),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      borderRadius: 12,
      backgroundColor: background,
      colorText: Colors.white,
      icon: Icon(icon, color: Colors.white),
      shouldIconPulse: false,
      duration: const Duration(seconds: 3),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
      overlayBlur: 0,
      maxWidth: 520,
    );
  }

  static String _friendlyMessage(String raw) {
    var text = raw.trim();
    if (text.isEmpty) return 'Please check your input and try again.';

    // Strip noisy exception prefixes users should never see.
    text = text
        .replaceFirst(RegExp(r'^Exception:\s*', caseSensitive: false), '')
        .replaceFirst(RegExp(r'^ApiError:\s*', caseSensitive: false), '')
        .replaceFirst(RegExp(r'^Error:\s*', caseSensitive: false), '');

    final lower = text.toLowerCase();

    if (lower.contains('cannot be shared') ||
        lower.contains('not accepting') ||
        lower.contains('cannot share')) {
      return 'This event cannot be shared right now. Check that it is active and published.';
    }
    if (lower.contains('only invite users from your connections') ||
        lower.contains('from your connections')) {
      return 'You can only invite people from your connections.';
    }
    if (lower.contains('cannot invite yourself')) {
      return 'You cannot send an invitation to yourself.';
    }
    if (lower.contains('competitionlevel') ||
        lower.contains('competition level')) {
      return 'Please select a valid competition level from the list '
          '(for example Local-Easy or National-Medium).';
    }
    if (lower.contains('eventtype') || lower.contains('event type')) {
      return 'Please select an event type: Onsite, Online, or Hybrid.';
    }
    if (lower.contains('must be one of') ||
        lower.contains('invalid enum') ||
        lower.contains('invalid_enum') ||
        RegExp(r'\bzod\b', caseSensitive: false).hasMatch(text) ||
        lower.contains('validation failed')) {
      return 'Some details look incomplete or invalid. '
          'Please review the highlighted fields and try again.';
    }
    if (lower.contains('network') ||
        lower.contains('socket') ||
        lower.contains('failed host lookup') ||
        lower.contains('connection')) {
      return 'Network issue. Check your connection and try again.';
    }

    // Hide technical dumps / stack-like messages.
    final looksTechnical = (text.contains('{') && text.contains('}')) ||
        RegExp(r'#\d+\s+[A-Za-z_.]+').hasMatch(text) ||
        lower.contains('stack trace') ||
        lower.contains('instanceof');
    if (looksTechnical || text.length > 180) {
      return 'Something went wrong. Please check your details and try again.';
    }

    return text;
  }
}
