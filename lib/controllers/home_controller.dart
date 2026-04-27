import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event_model.dart';
import '../services/api_service.dart';
import '../utils/api_constants.dart';

class HomeController extends GetxController implements GetxService {
  final ApiService apiService;
  final SharedPreferences sharedPreferences;

  HomeController({required this.apiService, required this.sharedPreferences});

  final RxList<EventModel> todayEvents = <EventModel>[].obs;
  final RxList<EventModel> familyEvents = <EventModel>[].obs;
  final RxList<EventModel> upcomingEvents = <EventModel>[].obs;
  final RxList<EventModel> historyEvents = <EventModel>[].obs;

  final RxBool isLoadingToday = false.obs;
  final RxBool isLoadingFamily = false.obs;
  final RxBool isLoadingUpcoming = false.obs;
  final RxBool isLoadingHistory = false.obs;

  // Pagination
  final RxInt todayPage = 1.obs;
  final RxBool todayHasNext = false.obs;
  final RxInt upcomingPage = 1.obs;
  final RxBool upcomingHasNext = false.obs;
  final RxInt historyPage = 1.obs;
  final RxBool historyHasNext = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTodayEvents();
    fetchFamilyEvents('Self');
    fetchUpcomingEvents();
    fetchHistoryEvents();
  }

  Future<void> fetchTodayEvents({bool isLoadMore = false}) async {
    if (isLoadMore) {
      if (!todayHasNext.value) return;
      todayPage.value++;
    } else {
      todayPage.value = 1;
      isLoadingToday.value = true;
    }

    try {
      final response = await apiService.get("${ApiConstants.todayEvents}?page=${todayPage.value}&limit=10");
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        final List<EventModel> newEvents = data.map((json) => EventModel.fromJson(json)).toList();
        
        if (isLoadMore) {
          todayEvents.addAll(newEvents);
        } else {
          todayEvents.value = newEvents;
        }
        
        todayHasNext.value = response['meta']['hasNext'] ?? false;
      }
    } catch (e) {
      debugPrint("Error fetching today events: $e");
    } finally {
      isLoadingToday.value = false;
    }
  }

  Future<void> fetchFamilyEvents(String relationShip) async {
    isLoadingFamily.value = true;
    try {
      String url;
      switch (relationShip) {
        case 'Self':
          url = ApiConstants.familySelfUsersEvents;
          break;
        case 'Spouse':
          url = ApiConstants.familySpousUsersEvents;
          break;
        case 'Child Stephanie':
          url = ApiConstants.familyChildStephanieUsersEvents;
          break;
        case 'Child Sophia':
          url = ApiConstants.familyChildSophiaUsersEvents;
          break;
        default:
          url = ApiConstants.familySelfUsersEvents;
      }

      final response = await apiService.get(url);
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        familyEvents.value =
            data.map((json) => EventModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint("Error fetching family events: $e");
    } finally {
      isLoadingFamily.value = false;
    }
  }

  Future<void> fetchUpcomingEvents({bool isLoadMore = false}) async {
    if (isLoadMore) {
      if (!upcomingHasNext.value) return;
      upcomingPage.value++;
    } else {
      upcomingPage.value = 1;
      isLoadingUpcoming.value = true;
    }

    try {
      final response = await apiService.get("${ApiConstants.getUpcomingEvents}?page=${upcomingPage.value}&limit=10");
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        final List<EventModel> newEvents = data.map((json) => EventModel.fromJson(json)).toList();

        if (isLoadMore) {
          upcomingEvents.addAll(newEvents);
        } else {
          upcomingEvents.value = newEvents;
        }

        upcomingHasNext.value = response['meta']['hasNext'] ?? false;
      }
    } catch (e) {
      debugPrint("Error fetching upcoming events: $e");
    } finally {
      isLoadingUpcoming.value = false;
    }
  }

  Future<void> fetchHistoryEvents({bool isLoadMore = false}) async {
    if (isLoadMore) {
      if (!historyHasNext.value) return;
      historyPage.value++;
    } else {
      historyPage.value = 1;
      isLoadingHistory.value = true;
    }

    try {
      final response = await apiService.get("${ApiConstants.getHistoryEvents}?page=${historyPage.value}&limit=10");
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        final List<EventModel> newEvents = data.map((json) => EventModel.fromJson(json)).toList();

        if (isLoadMore) {
          historyEvents.addAll(newEvents);
        } else {
          historyEvents.value = newEvents;
        }

        historyHasNext.value = response['meta']['hasNext'] ?? false;
      }
    } catch (e) {
      debugPrint("Error fetching history events: $e");
    } finally {
      isLoadingHistory.value = false;
    }
  }
}
