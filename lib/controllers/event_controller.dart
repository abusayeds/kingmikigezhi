import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event_model.dart';
import '../services/api_service.dart';
import '../utils/api_constants.dart';

class EventController extends GetxController {
  final ApiService apiService;
  final SharedPreferences sharedPreferences;

  EventController({required this.apiService, required this.sharedPreferences});

  final RxList<EventModel> upcomingEvents = <EventModel>[].obs;
  final RxBool isLoadingUpcoming = false.obs;
  final RxInt upcomingPage = 1.obs;
  final RxBool upcomingHasNext = false.obs;
  final RxInt totalUpcomingEvents = 0.obs;

  final Rx<EventModel?> eventDetails = Rx<EventModel?>(null);
  final RxBool isLoadingDetails = false.obs;

  final RxString searchUpcomingQuery = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchUpcomingEvents();
  }

  Future<void> fetchUpcomingEvents({bool isLoadMore = false, String? search}) async {
    if (isLoadMore) {
      if (!upcomingHasNext.value) return;
      upcomingPage.value++;
    } else {
      upcomingPage.value = 1;
      isLoadingUpcoming.value = true;
      if (search != null) {
        searchUpcomingQuery.value = search;
      }
    }

    try {
      String url = "${ApiConstants.getUpcomingEvents}?page=${upcomingPage.value}&limit=10";
      if (searchUpcomingQuery.value.isNotEmpty) {
        url += "&searchTerm=${searchUpcomingQuery.value}";
      }

      final response = await apiService.get(url);
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        final List<EventModel> newEvents = data.map((json) => EventModel.fromJson(json)).toList();

        if (isLoadMore) {
          upcomingEvents.addAll(newEvents);
        } else {
          upcomingEvents.value = newEvents;
        }

        upcomingHasNext.value = response['meta']['hasNext'] ?? false;
        totalUpcomingEvents.value = response['meta']['total'] ?? 0;
      }
    } catch (e) {
      debugPrint("Error fetching upcoming events: $e");
    } finally {
      isLoadingUpcoming.value = false;
    }
  }

  Future<void> fetchEventDetails(String eventId) async {
    isLoadingDetails.value = true;
    eventDetails.value = null;
    try {
      final url = ApiConstants.getEventsDetails.replaceAll(':eventId', eventId);
      final response = await apiService.get(url);
      if (response['success'] == true) {
        eventDetails.value = EventModel.fromJson(response['data']);
      }
    } catch (e) {
      debugPrint("Error fetching event details: $e");
    } finally {
      isLoadingDetails.value = false;
    }
  }
}
