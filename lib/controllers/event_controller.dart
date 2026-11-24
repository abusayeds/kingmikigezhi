import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event_model.dart';
import '../models/home_event_model.dart';
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

  final RxList<HomeEventModel> homeEvents = <HomeEventModel>[].obs;
  final RxBool isLoadingHomeEvents = false.obs;

  final RxList<EventModel> calendarEvents = <EventModel>[].obs;

  final Rx<EventModel?> eventDetails = Rx<EventModel?>(null);
  final RxBool isLoadingDetails = false.obs;

  final RxString searchUpcomingQuery = "".obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchUpcomingEvents({
    bool isLoadMore = false,
    bool force = false,
    String? search,
  }) async {
    if (isLoadMore) {
      if (!upcomingHasNext.value) return;
      upcomingPage.value++;
    } else {
      upcomingPage.value = 1;
      // Only show full-page loader when we have nothing to display yet.
      if (force || upcomingEvents.isEmpty) {
        isLoadingUpcoming.value = upcomingEvents.isEmpty;
      }
      if (search != null) {
        searchUpcomingQuery.value = search.trim();
      }
    }

    try {
      String url = "${ApiConstants.getUpcomingEvents}?page=${upcomingPage.value}&limit=10";
      if (searchUpcomingQuery.value.isNotEmpty) {
        url += "&searchTerm=${Uri.encodeQueryComponent(searchUpcomingQuery.value)}";
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
    final hasCached =
        eventDetails.value != null && eventDetails.value?.id == eventId;
    if (!hasCached) {
      isLoadingDetails.value = true;
    }
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

  Future<void> fetchHomeEvents() async {
    if (homeEvents.isEmpty) {
      isLoadingHomeEvents.value = true;
    }
    try {
      final response = await apiService.get(ApiConstants.getHomeEvents);
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        homeEvents.value = data.map((json) => HomeEventModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint("Error fetching home events: $e");
    } finally {
      isLoadingHomeEvents.value = false;
    }
  }

  /// Relationship currently shown on the calendar ('Self' by default).
  final RxString calendarRelationShip = 'Self'.obs;
  final RxBool isLoadingCalendar = false.obs;

  /// Events for the calendar.
  ///
  /// With [relationShip] the calendar shows the events of that family member
  /// (API enum value, e.g. `Self`, `Spous`, `ChildStephanie`). Without one it
  /// falls back to the combined today + upcoming + history feeds.
  Future<void> fetchCalendarEvents({String? relationShip}) async {
    final relation = (relationShip ?? calendarRelationShip.value).trim();
    calendarRelationShip.value = relation.isEmpty ? 'Self' : relation;

    isLoadingCalendar.value = calendarEvents.isEmpty;
    try {
      final List<EventModel> allEvents = [];

      if (relation.isNotEmpty) {
        final response = await apiService.get(
          '${ApiConstants.familyEventsByRelation(relation)}&page=1&limit=100',
        );
        if (response['success'] == true) {
          final List<dynamic> data = response['data'] ?? [];
          allEvents.addAll(data.map((json) => EventModel.fromJson(json)));
        }
      } else {
        final urls = [
          ApiConstants.getUpcomingEvents,
          ApiConstants.getHistoryEvents,
          ApiConstants.todayEvents,
        ];

        final responses = await Future.wait(
          urls.map((url) => apiService.get("$url?page=1&limit=100")),
        );

        for (final response in responses) {
          if (response['success'] == true) {
            final List<dynamic> data = response['data'];
            allEvents.addAll(data.map((json) => EventModel.fromJson(json)));
          }
        }
      }

      // One entry per event id — the feeds can overlap.
      final seen = <String>{};
      calendarEvents.value = allEvents.where((e) {
        final id = e.id;
        if (id == null || id.isEmpty) return true;
        return seen.add(id);
      }).toList();
    } catch (e) {
      debugPrint("Error fetching calendar events: $e");
    } finally {
      isLoadingCalendar.value = false;
    }
  }

  Future<bool> createHomeEvent(Map<String, dynamic> requestBody) async {
    try {
      final response = await apiService.post(
        ApiConstants.createHomeEvent,
        body: requestBody,
      );

      if (response != null && response['success'] == true) {
        Fluttertoast.showToast(
          msg: response['message'] ?? "Home event created successfully!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
        return true;
      }
      return false;
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to create event: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }

  Future<bool> createEvent(Map<String, dynamic> requestBody) async {
    try {
      isLoadingDetails.value = true;
      update();

      final response = await apiService.post(
        ApiConstants.createEvent,
        body: requestBody,
      );

      isLoadingDetails.value = false;
      update();

      if (response != null && response['success'] == true) {
        Fluttertoast.showToast(
          msg: response['message'] ?? "Event created successfully!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
        return true;
      }
      return false;
    } catch (e) {
      isLoadingDetails.value = false;
      update();
      Fluttertoast.showToast(
        msg: "Failed to create event: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }
}
