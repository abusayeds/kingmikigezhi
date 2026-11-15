import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/models/event_model.dart';
import 'package:event_sharing/services/api_service.dart';
import 'package:event_sharing/utils/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

Future<void> handleEventMenuAction(String action, EventModel event) async {
  switch (action) {
    case 'view':
      Get.toNamed(AppRoutes.eventDetailsScreen, arguments: event);
      break;
    case 'share':
      final link = (event.eventPortal?.trim().isNotEmpty == true)
          ? event.eventPortal!.trim()
          : (event.id != null
              ? '${ApiConstants.baseUrl}/events/${event.id}'
              : null);
      if (link == null || link.isEmpty) {
        Fluttertoast.showToast(msg: 'No event link available');
        return;
      }
      await Clipboard.setData(ClipboardData(text: link));
      Fluttertoast.showToast(msg: 'Event link copied');
      break;
    case 'delete':
      if (event.id == null) return;
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
      if (confirmed != true) return;
      try {
        final api = Get.find<ApiService>();
        final response = await api.delete(
          ApiConstants.deleteEvent.replaceAll(':eventId', event.id!),
        );
        if (response['success'] == true) {
          Fluttertoast.showToast(
            msg: response['message']?.toString() ?? 'Event deleted',
          );
        } else {
          Fluttertoast.showToast(
            msg: response['message']?.toString() ?? 'Failed to delete event',
          );
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'Failed to delete event: $e');
      }
      break;
  }
}

class EventMoreMenuButton extends StatelessWidget {
  final EventModel? event;
  final Color iconColor;
  final double iconSize;

  const EventMoreMenuButton({
    super.key,
    required this.event,
    this.iconColor = Colors.grey,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    if (event == null) {
      return Icon(Icons.more_horiz, color: iconColor, size: iconSize);
    }

    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.more_horiz, color: iconColor, size: iconSize),
      onSelected: (value) => handleEventMenuAction(value, event!),
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'view', child: Text('View details')),
        PopupMenuItem(value: 'share', child: Text('Share link')),
        PopupMenuItem(value: 'delete', child: Text('Delete')),
      ],
    );
  }
}