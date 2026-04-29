import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../models/event_model.dart';
import '../../../../../services/api_service.dart';
import '../../../../../utils/api_constants.dart';

class AppliedEventController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();

  final RxList<AppliedEvent> appliedEvents = <AppliedEvent>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt totalEvents = 0.obs;
  final RxDouble totalCost = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAppliedEvents();
  }

  Future<void> fetchAppliedEvents() async {
    isLoading.value = true;
    try {
      final response = await apiService.get(ApiConstants.appliedEvents);
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        appliedEvents.value = data.map((json) => AppliedEvent.fromJson(json)).toList();
        totalEvents.value = response['meta']['total'] ?? appliedEvents.length;
        
        // Optionally calculate total cost from available data
        double costSum = 0;
        for (var applied in appliedEvents) {
          if (applied.event.schedule?.cost != null) {
            costSum += double.tryParse(applied.event.schedule!.cost!) ?? 0.0;
          }
        }
        totalCost.value = costSum;
      }
    } catch (e) {
      debugPrint("Error fetching applied events: $e");
    } finally {
      isLoading.value = false;
    }
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
    return AppliedEvent(
      id: json['id'],
      eventId: json['eventId'],
      note: json['note'],
      event: EventModel.fromJson(json['event']),
    );
  }
}
