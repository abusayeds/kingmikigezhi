import 'package:event_sharing/helpers/app_feedback.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../models/event_model.dart';
import '../../../../../services/api_service.dart';
import '../../../../../utils/api_constants.dart';

class AppliedEventController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();

  final RxList<AppliedEvent> appliedEvents = <AppliedEvent>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isApplying = false.obs;
  final RxInt totalEvents = 0.obs;
  final RxDouble totalCost = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAppliedEvents();
  }

  bool hasApplied(String? eventId) {
    if (eventId == null || eventId.isEmpty) return false;
    return appliedEvents.any((a) => a.eventId == eventId || a.event.id == eventId);
  }

  void removeByEventId(String eventId) {
    appliedEvents.removeWhere(
      (a) => a.eventId == eventId || a.event.id == eventId,
    );
    appliedEvents.refresh();
    totalEvents.value = appliedEvents.length;
    _recalcCost();
  }

  Future<void> fetchAppliedEvents({bool silent = false, bool force = false}) async {
    // Keep existing rows visible; only show loader on first empty load.
    final showLoader = !silent && (force || appliedEvents.isEmpty);
    if (showLoader) isLoading.value = true;
    try {
      final response = await apiService.get(ApiConstants.appliedEvents);
      if (response['success'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        appliedEvents.value =
            data.map((json) => AppliedEvent.fromJson(json)).toList();
        final meta = response['meta'];
        totalEvents.value = meta is Map
            ? (meta['total'] as num?)?.toInt() ?? appliedEvents.length
            : appliedEvents.length;
        _recalcCost();
      } else if (!silent) {
        AppFeedback.error(
          response['message']?.toString() ??
              'Could not load your applied events.',
        );
      }
    } catch (e) {
      debugPrint("Error fetching applied events: $e");
      if (!silent) {
        AppFeedback.error(e.toString(), title: 'Could not load applied events');
      }
    } finally {
      if (showLoader) isLoading.value = false;
    }
  }

  /// Submit an application for [eventId]. Returns true on success.
  Future<bool> applyToEvent(String eventId, {String? note}) async {
    if (eventId.isEmpty) {
      AppFeedback.validation('This event is missing an ID. Please reopen it.');
      return false;
    }
    if (hasApplied(eventId)) {
      AppFeedback.info('You already applied to this event.');
      return true;
    }

    isApplying.value = true;
    try {
      final body = <String, dynamic>{'eventId': eventId};
      if (note != null && note.trim().isNotEmpty) {
        body['note'] = note.trim();
      }

      final response = await apiService.post(
        ApiConstants.createEventApplication,
        body: body,
      );

      if (response['success'] == true) {
        AppFeedback.success(
          response['message']?.toString() ?? 'Application submitted.',
        );
        await fetchAppliedEvents(silent: true);
        return true;
      }

      AppFeedback.error(
        response['message']?.toString() ??
            'Could not apply to this event. Please try again.',
      );
      return false;
    } catch (e) {
      debugPrint("Error applying to event: $e");
      AppFeedback.error(e.toString(), title: 'Could not apply');
      return false;
    } finally {
      isApplying.value = false;
    }
  }

  void _recalcCost() {
    double costSum = 0;
    for (final applied in appliedEvents) {
      if (applied.event.schedule?.cost != null) {
        costSum += double.tryParse(applied.event.schedule!.cost!) ?? 0.0;
      }
    }
    totalCost.value = costSum;
  }
}

class AppliedEvent {
  final String id;
  final String eventId;
  final String? note;
  final EventModel event;

  AppliedEvent({
    required this.id,
    required this.eventId,
    this.note,
    required this.event,
  });

  factory AppliedEvent.fromJson(Map<String, dynamic> json) {
    final eventRaw = json['event'];
    final Map<String, dynamic> eventMap = eventRaw is Map<String, dynamic>
        ? eventRaw
        : Map<String, dynamic>.from(eventRaw as Map? ?? {'id': json['eventId']});

    return AppliedEvent(
      id: json['id']?.toString() ?? '',
      eventId: json['eventId']?.toString() ?? eventMap['id']?.toString() ?? '',
      note: json['note']?.toString(),
      event: EventModel.fromJson(eventMap),
    );
  }
}
