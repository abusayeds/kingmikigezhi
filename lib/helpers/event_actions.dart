import 'dart:convert';

import 'package:event_sharing/controllers/auth_controller.dart';
import 'package:event_sharing/controllers/event_controller.dart';
import 'package:event_sharing/controllers/home_controller.dart';
import 'package:event_sharing/helpers/app_feedback.dart';
import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/models/event_model.dart';
import 'package:event_sharing/services/api_service.dart';
import 'package:event_sharing/services/content_cache.dart';
import 'package:event_sharing/utils/api_constants.dart';
import 'package:event_sharing/views/screen/MyEvent/controller/applied_event_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Current signed-in user id from profile / prefs.
String? currentUserId() {
  try {
    if (Get.isRegistered<AuthController>()) {
      final profile = Get.find<AuthController>().userProfile.value;
      final fromProfile = profile?['id']?.toString();
      if (fromProfile != null && fromProfile.isNotEmpty) return fromProfile;
    }
  } catch (_) {}
  try {
    if (!Get.isRegistered<ApiService>()) return null;
    final raw = Get.find<ApiService>()
        .sharedPreferences
        .getString(ApiConstants.keyUserData);
    if (raw == null || raw.isEmpty) return null;
    final decoded = jsonDecode(raw);
    if (decoded is Map) {
      final id = decoded['id']?.toString();
      if (id != null && id.isNotEmpty) return id;
    }
  } catch (_) {}
  return null;
}

/// Whether [event] was created by the signed-in user.
bool isEventOwner(EventModel? event, {bool forceOwner = false}) {
  if (forceOwner) return true;
  if (event == null) return false;
  final me = currentUserId();
  if (me == null || me.isEmpty) return false;
  final creatorId = event.creatorId ?? event.creator?.id;
  return creatorId != null && creatorId.isNotEmpty && creatorId == me;
}

/// Remove a deleted event from every in-memory list so cards disappear immediately.
void removeEventFromLocalCaches(String eventId) {
  if (eventId.isEmpty) return;

  if (Get.isRegistered<HomeController>()) {
    final home = Get.find<HomeController>();
    home.todayEvents.removeWhere((e) => e.id == eventId);
    home.upcomingEvents.removeWhere((e) => e.id == eventId);
    home.historyEvents.removeWhere((e) => e.id == eventId);
    home.createdEvents.removeWhere((e) => e.id == eventId);
    home.familyEvents.removeWhere((e) => e.id == eventId);
    home.searchedEvents.removeWhere((e) => e.id == eventId);
    home.todayEvents.refresh();
    home.upcomingEvents.refresh();
    home.historyEvents.refresh();
    home.createdEvents.refresh();
    home.familyEvents.refresh();
    home.searchedEvents.refresh();
  }

  if (Get.isRegistered<EventController>()) {
    final events = Get.find<EventController>();
    events.upcomingEvents.removeWhere((e) => e.id == eventId);
    events.calendarEvents.removeWhere((e) => e.id == eventId);
    events.upcomingEvents.refresh();
    events.calendarEvents.refresh();
    if (events.eventDetails.value?.id == eventId) {
      events.eventDetails.value = null;
    }
  }

  if (Get.isRegistered<AppliedEventController>()) {
    Get.find<AppliedEventController>().removeByEventId(eventId);
  }
}

/// Delete event via API, clear local lists, then show a clear success message.
/// Returns true when the event was deleted successfully.
Future<bool> deleteEventEverywhere(EventModel event, {bool popDetails = false}) async {
  final eventId = event.id;
  if (eventId == null || eventId.isEmpty) return false;

  final confirmed = await Get.dialog<bool>(
    AlertDialog(
      title: const Text('Delete event?'),
      content: const Text('This will permanently remove the event.'),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Get.back(result: true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  if (confirmed != true) return false;

  try {
    final api = Get.find<ApiService>();
    final response = await api.delete(
      ApiConstants.deleteEvent.replaceAll(':eventId', eventId),
    );
    final ok = response is Map && response['success'] == true;
    if (!ok) {
      AppFeedback.error(
        response is Map
            ? response['message']?.toString() ??
                'Could not delete this event. Please try again.'
            : 'Could not delete this event. Please try again.',
      );
      return false;
    }

    removeEventFromLocalCaches(eventId);
    if (Get.isRegistered<ContentCache>()) {
      ContentCache.to.invalidateEvent(eventId);
    }

    // Leave details first so the snackbar shows on the list screen.
    if (popDetails && (Get.key.currentState?.canPop() ?? false)) {
      Get.back(result: true);
    }

    Future.microtask(() {
      AppFeedback.success(
        'Event deleted successfully. It has been removed.',
        title: 'Deleted',
      );
    });
    return true;
  } catch (e) {
    AppFeedback.error(e.toString(), title: 'Could not delete event');
    return false;
  }
}

/// Mark an event as verified.
///
/// Verification means "this event is still active and its details are correct".
/// This is a community action: any signed-in user may verify any event, the
/// same way any signed-in user may edit one.
///
/// Returns the refreshed event on success, or null when it failed.
Future<EventModel?> verifyEvent(EventModel event) async {
  final eventId = event.id;
  if (eventId == null || eventId.isEmpty) {
    AppFeedback.validation('This event is missing an ID. Please reopen it.');
    return null;
  }

  final confirmed = await Get.dialog<bool>(
    AlertDialog(
      title: const Text('Verify this event?'),
      content: const Text(
        'Verifying confirms the event is still active and its information is '
        'accurate and up to date.',
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Get.back(result: true),
          child: const Text('Verify'),
        ),
      ],
    ),
  );
  if (confirmed != true) return null;

  try {
    final api = Get.find<ApiService>();
    final response = await api.patch(
      ApiConstants.verifyEvent(eventId),
      body: {'isVerified': true},
    );

    if (response is! Map || response['success'] != true) {
      AppFeedback.error(
        response is Map
            ? response['message']?.toString() ??
                'Could not verify this event. Please try again.'
            : 'Could not verify this event. Please try again.',
      );
      return null;
    }

    EventModel? updated;
    final data = response['data'];
    if (data is Map) {
      try {
        updated = EventModel.fromJson(Map<String, dynamic>.from(data));
      } catch (_) {}
    }

    if (updated != null && Get.isRegistered<ContentCache>()) {
      ContentCache.to.putEvent(updated);
    }

    AppFeedback.success(
      'Thanks! This event is now marked as verified.',
      title: 'Verified',
    );
    return updated;
  } catch (e) {
    AppFeedback.error(e.toString(), title: 'Could not verify event');
    return null;
  }
}

String buildEventShareLink(EventModel event) {
  if (event.eventPortal?.trim().isNotEmpty == true) {
    return event.eventPortal!.trim();
  }
  if (event.id != null && event.id!.isNotEmpty) {
    return '${ApiConstants.baseUrl}/events/${event.id}';
  }
  return '';
}

String buildEventShareMessage({
  required String eventTitle,
  required String eventLink,
}) {
  final title = eventTitle.trim().isEmpty ? 'this event' : eventTitle.trim();
  if (eventLink.trim().isEmpty) {
    return "You're invited to $title!";
  }
  return "You're invited to $title!\n$eventLink";
}

Map<String, dynamic> invitationRouteArgs(EventModel event) {
  final link = buildEventShareLink(event);
  return {
    'eventId': event.id ?? '',
    'eventLink': link,
    'eventTitle': event.eventName ?? 'Event',
  };
}

void openEventInvitationPage(EventModel event) {
  Get.toNamed(
    AppRoutes.myInvitationPage,
    arguments: invitationRouteArgs(event),
  );
}

Future<bool> _launchExternalUri(Uri uri) async {
  try {
    return await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {
    return false;
  }
}

Future<void> shareEventViaChannel({
  required String channel,
  required String eventTitle,
  required String eventLink,
  String? customMessage,
}) async {
  final link = eventLink.trim();
  final typed = customMessage?.trim() ?? '';
  final hasTypedMessage = typed.isNotEmpty;

  // Prefer the user's typed message; otherwise build one from the event.
  final message = hasTypedMessage
      ? typed
      : buildEventShareMessage(eventTitle: eventTitle, eventLink: link);

  if (message.isEmpty) {
    Fluttertoast.showToast(msg: 'Nothing to share for this event');
    return;
  }

  final subject = eventTitle.trim().isEmpty
      ? 'Event invitation'
      : 'Invitation: ${eventTitle.trim()}';

  switch (channel) {
    case 'iMessage':
      final smsUri = Uri.parse(
        'sms:?body=${Uri.encodeComponent(message)}',
      );
      if (await _launchExternalUri(smsUri)) return;
      break;
    case 'WhatsApp':
      final waUri = Uri.parse(
        'https://wa.me/?text=${Uri.encodeComponent(message)}',
      );
      if (await _launchExternalUri(waUri)) return;
      break;
    case 'Gmail':
      final mailUri = Uri(
        scheme: 'mailto',
        queryParameters: {
          'subject': subject,
          'body': message,
        },
      );
      if (await _launchExternalUri(mailUri)) return;
      break;
    case 'Instagram':
      final clip = hasTypedMessage
          ? typed
          : (link.isNotEmpty ? link : message);
      await Clipboard.setData(ClipboardData(text: clip));
      final igUri = Uri.parse('instagram://app');
      if (await _launchExternalUri(igUri)) {
        Fluttertoast.showToast(msg: 'Message copied — paste it in Instagram');
        return;
      }
      break;
  }

  try {
    await Share.share(message, subject: subject);
  } catch (_) {
    await Clipboard.setData(ClipboardData(text: message));
    Fluttertoast.showToast(msg: 'Message copied. Share app not available.');
  }
}

Future<void> handleEventMenuAction(String action, EventModel event) async {
  switch (action) {
    case 'view':
      Get.toNamed(AppRoutes.eventDetailsScreen, arguments: event);
      break;
    case 'edit':
      await Get.toNamed(AppRoutes.createEventOne, arguments: event);
      break;
    case 'share':
      openEventInvitationPage(event);
      break;
    case 'delete':
      await deleteEventEverywhere(event);
      break;
  }
}

class EventMoreMenuButton extends StatelessWidget {
  final EventModel? event;
  final Color iconColor;
  final double iconSize;
  /// When true (e.g. Created tab), always show Edit/Delete.
  final bool forceOwnerActions;

  const EventMoreMenuButton({
    super.key,
    required this.event,
    this.iconColor = Colors.grey,
    this.iconSize = 24,
    this.forceOwnerActions = false,
  });

  @override
  Widget build(BuildContext context) {
    if (event == null) {
      return Icon(Icons.more_horiz, color: iconColor, size: iconSize);
    }

    // Shared community platform: anyone signed in may edit any event.
    // Only the creator may delete it.
    final owner = isEventOwner(event, forceOwner: forceOwnerActions);

    return Material(
      color: Colors.transparent,
      child: PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        icon: Icon(Icons.more_horiz, color: iconColor, size: iconSize),
        onSelected: (value) => handleEventMenuAction(value, event!),
        itemBuilder: (context) => [
          const PopupMenuItem(value: 'view', child: Text('View details')),
          const PopupMenuItem(value: 'edit', child: Text('Edit')),
          const PopupMenuItem(value: 'share', child: Text('Share')),
          if (owner)
            const PopupMenuItem(value: 'delete', child: Text('Delete')),
        ],
      ),
    );
  }
}