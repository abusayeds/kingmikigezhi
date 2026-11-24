import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/feed_search_query.dart';
import '../models/event_model.dart';
import '../services/api_service.dart';
import '../services/content_cache.dart';
import '../utils/api_constants.dart';

class HomeController extends GetxController implements GetxService {
  final ApiService apiService;
  final SharedPreferences sharedPreferences;

  HomeController({required this.apiService, required this.sharedPreferences});

  final RxList<EventModel> todayEvents = <EventModel>[].obs;
  final RxList<EventModel> familyEvents = <EventModel>[].obs;
  final RxList<EventModel> upcomingEvents = <EventModel>[].obs;
  final RxList<EventModel> historyEvents = <EventModel>[].obs;
  final RxList<EventModel> createdEvents = <EventModel>[].obs;

  final RxBool isLoadingToday = false.obs;
  final RxBool isLoadingFamily = false.obs;
  final RxBool isLoadingUpcoming = false.obs;
  final RxBool isLoadingHistory = false.obs;
  final RxBool isLoadingCreated = false.obs;

  // Pagination
  final RxInt todayPage = 1.obs;
  final RxBool todayHasNext = false.obs;
  final RxInt upcomingPage = 1.obs;
  final RxBool upcomingHasNext = false.obs;
  final RxInt historyPage = 1.obs;
  final RxBool historyHasNext = false.obs;
  final RxInt createdPage = 1.obs;
  final RxBool createdHasNext = false.obs;

  // Search Results
  final RxList<EventModel> searchedEvents = <EventModel>[].obs;
  final RxBool isLoadingSearch = false.obs;
  final RxInt searchPage = 1.obs;
  final RxBool searchHasNext = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> searchEvents({
    bool isLoadMore = false,
    String? searchTerm,
    String? programId,
    String? type,
    String? location,
    String? categoryGroup,
    double? priceMin,
    double? priceMax,
  }) async {
    if (isLoadMore) {
      if (!searchHasNext.value) return;
      searchPage.value++;
    } else {
      searchPage.value = 1;
      isLoadingSearch.value = true;
      if (!isLoadMore) searchedEvents.clear();
    }

    try {
      final params = FeedSearchQuery.build(
        page: searchPage.value,
        searchTerm: searchTerm,
        programId: programId,
        type: type,
        location: location,
        categoryGroup: categoryGroup,
        priceMin: priceMin,
        priceMax: priceMax,
      );

      final hasTerm = (searchTerm?.trim().isNotEmpty ?? false);
      final hasFilters = (programId?.trim().isNotEmpty ?? false) ||
          (type?.trim().isNotEmpty ?? false) ||
          (location?.trim().isNotEmpty ?? false) ||
          (categoryGroup?.trim().isNotEmpty ?? false) ||
          priceMin != null ||
          priceMax != null;
      if (!hasTerm && !hasFilters) {
        if (!isLoadMore) searchedEvents.clear();
        Fluttertoast.showToast(msg: 'Enter a search term or apply filters');
        return;
      }

      final uri = Uri.parse(ApiConstants.searchEvents).replace(
        queryParameters: params,
      );

      final response = await apiService.get(uri.toString());
      if (response['success'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        final List<EventModel> newEvents =
            data.map((json) => EventModel.fromJson(json)).toList();

        if (isLoadMore) {
          searchedEvents.addAll(newEvents);
        } else {
          searchedEvents.value = newEvents;
        }

        final meta = response['meta'];
        searchHasNext.value =
            meta is Map ? (meta['hasNext'] == true) : false;
      } else {
        if (!isLoadMore) searchedEvents.clear();
        Fluttertoast.showToast(
          msg: response['message']?.toString() ?? 'Search failed',
        );
      }
    } catch (e) {
      if (!isLoadMore) searchedEvents.clear();
      Fluttertoast.showToast(msg: 'Error searching events: $e');
      debugPrint("Error searching events: $e");
    } finally {
      isLoadingSearch.value = false;
    }
  }

  /// [force] shows the first-load loading flag only when the list is empty.
  /// When data already exists, refresh is silent (no spinner).
  Future<void> fetchTodayEvents({bool isLoadMore = false, bool force = false}) async {
    if (isLoadMore) {
      if (!todayHasNext.value) return;
      todayPage.value++;
    } else {
      todayPage.value = 1;
      if (force || todayEvents.isEmpty) {
        isLoadingToday.value = todayEvents.isEmpty;
      }
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
        if (Get.isRegistered<ContentCache>()) {
          ContentCache.to.putEvents(newEvents);
        }
        
        todayHasNext.value = response['meta']['hasNext'] ?? false;
      }
    } catch (e) {
      debugPrint("Error fetching today events: $e");
    } finally {
      isLoadingToday.value = false;
    }
  }

  Future<void> fetchFamilyEvents(String relationShip, {bool force = false}) async {
    // Only show a loader when we have nothing to show yet.
    if (force || familyEvents.isEmpty) {
      isLoadingFamily.value = familyEvents.isEmpty;
    }
    try {
      // Normalize legacy display labels to API relationShip values.
      String apiRelation = relationShip;
      switch (relationShip) {
        case 'Spouse':
          apiRelation = 'Spous';
          break;
        case 'Child Stephanie':
          apiRelation = 'ChildStephanie';
          break;
        case 'Child Sophia':
          apiRelation = 'ChildSophia';
          break;
        default:
          apiRelation = relationShip.isEmpty ? 'Self' : relationShip;
      }

      final response =
          await apiService.get(ApiConstants.familyEventsByRelation(apiRelation));
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        familyEvents.value =
            data.map((json) => EventModel.fromJson(json)).toList();
        if (Get.isRegistered<ContentCache>()) {
          ContentCache.to.putEvents(familyEvents);
        }
      }
    } catch (e) {
      debugPrint("Error fetching family events: $e");
    } finally {
      isLoadingFamily.value = false;
    }
  }

  Future<void> fetchUpcomingEvents({bool isLoadMore = false, bool force = false}) async {
    if (isLoadMore) {
      if (!upcomingHasNext.value) return;
      upcomingPage.value++;
    } else {
      upcomingPage.value = 1;
      if (force || upcomingEvents.isEmpty) {
        isLoadingUpcoming.value = upcomingEvents.isEmpty;
      }
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
        if (Get.isRegistered<ContentCache>()) {
          ContentCache.to.putEvents(newEvents);
        }

        upcomingHasNext.value = response['meta']['hasNext'] ?? false;
      }
    } catch (e) {
      debugPrint("Error fetching upcoming events: $e");
    } finally {
      isLoadingUpcoming.value = false;
    }
  }

  Future<void> fetchHistoryEvents({bool isLoadMore = false, bool force = false}) async {
    if (isLoadMore) {
      if (!historyHasNext.value) return;
      historyPage.value++;
    } else {
      historyPage.value = 1;
      if (force || historyEvents.isEmpty) {
        isLoadingHistory.value = historyEvents.isEmpty;
      }
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
        if (Get.isRegistered<ContentCache>()) {
          ContentCache.to.putEvents(newEvents);
        }

        historyHasNext.value = response['meta']['hasNext'] ?? false;
      }
    } catch (e) {
      debugPrint("Error fetching history events: $e");
    } finally {
      isLoadingHistory.value = false;
    }
  }

  /// Events created by the signed-in user (`GET /events/feed/mine`).
  Future<void> fetchCreatedEvents({bool isLoadMore = false, bool force = false}) async {
    if (isLoadMore) {
      if (!createdHasNext.value) return;
      createdPage.value++;
    } else {
      createdPage.value = 1;
      if (force || createdEvents.isEmpty) {
        isLoadingCreated.value = createdEvents.isEmpty;
      }
    }

    try {
      final response = await apiService.get(
        "${ApiConstants.getMyCreatedEvents}?page=${createdPage.value}&limit=10",
      );
      if (response['success'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        final List<EventModel> newEvents =
            data.map((json) => EventModel.fromJson(json)).toList();

        if (isLoadMore) {
          createdEvents.addAll(newEvents);
        } else {
          createdEvents.value = newEvents;
        }
        if (Get.isRegistered<ContentCache>()) {
          ContentCache.to.putEvents(newEvents);
        }

        createdHasNext.value = response['meta']?['hasNext'] ?? false;
      }
    } catch (e) {
      debugPrint("Error fetching created events: $e");
    } finally {
      isLoadingCreated.value = false;
    }
  }
}
