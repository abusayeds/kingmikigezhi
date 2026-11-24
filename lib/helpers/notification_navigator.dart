import 'package:event_sharing/helpers/app_feedback.dart';
import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/models/notification_model.dart';
import 'package:get/get.dart';

/// Routes a notification tap to the related screen when [linkType]/[linkId]
/// (or nested `data`) point at something we can open.
class NotificationNavigator {
  NotificationNavigator._();

  static Future<void> open(NotificationModel notification) async {
    final type = (notification.linkType ?? notification.type ?? '')
        .trim()
        .toLowerCase()
        .replaceAll('_', '-');

    final data = _asMap(notification.data);
    final linkId = (notification.linkId ?? '').trim();
    final eventId = _firstNonEmpty([
      data['eventId']?.toString(),
      if (type == 'event' || type == 'eventapplication' || type == 'event-application')
        linkId,
    ]);
    final invitationId = _firstNonEmpty([
      data['invitationId']?.toString(),
      if (type == 'event-invitation' || type == 'eventinvitation') linkId,
    ]);
    final donationId = _firstNonEmpty([
      data['donationId']?.toString(),
      if (type == 'donation') linkId,
    ]);

    switch (type) {
      case 'event':
      case 'eventapplication':
      case 'event-application':
        if (eventId != null) {
          await Get.toNamed(AppRoutes.eventDetailsScreen, arguments: eventId);
          return;
        }
        break;
      case 'event-invitation':
      case 'eventinvitation':
        if (eventId != null) {
          await Get.toNamed(AppRoutes.eventDetailsScreen, arguments: eventId);
          return;
        }
        // Fall back to invitations inbox when we only have an invitation id.
        if (invitationId != null) {
          await Get.toNamed(AppRoutes.myInvitationPage);
          return;
        }
        break;
      case 'donation':
        if (donationId != null || linkId.isNotEmpty) {
          await Get.toNamed(
            AppRoutes.donationScreen,
            arguments: {'donationId': donationId ?? linkId},
          );
          return;
        }
        await Get.toNamed(AppRoutes.myContributionScreen);
        return;
      case 'system':
      default:
        // No deep-link destination — stay on notifications.
        if (eventId != null) {
          await Get.toNamed(AppRoutes.eventDetailsScreen, arguments: eventId);
          return;
        }
        break;
    }

    // Last-resort: if any id looks like an event, open details.
    if (linkId.isNotEmpty &&
        (type.isEmpty || type == 'system') &&
        data['eventId'] != null) {
      await Get.toNamed(
        AppRoutes.eventDetailsScreen,
        arguments: data['eventId'].toString(),
      );
      return;
    }

    AppFeedback.toast('No related page for this notification.');
  }

  static Map<String, dynamic> _asMap(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return const {};
  }

  static String? _firstNonEmpty(List<String?> values) {
    for (final v in values) {
      final t = v?.trim();
      if (t != null && t.isNotEmpty) return t;
    }
    return null;
  }
}
