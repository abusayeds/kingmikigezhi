import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../utils/api_constants.dart';

class ContributionModel {
  final String id;
  final String title;
  final String? imageUrl;
  final String? type;
  final String? location;
  final String? history;
  final num? cost;
  final String? deadline;
  final String? programName;
  final String? categoryGroup;

  ContributionModel({
    required this.id,
    required this.title,
    this.imageUrl,
    this.type,
    this.location,
    this.history,
    this.cost,
    this.deadline,
    this.programName,
    this.categoryGroup,
  });

  factory ContributionModel.fromJson(Map<String, dynamic> json) {
    return ContributionModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'],
      type: json['type'],
      location: json['location'],
      history: json['history'],
      cost: json['cost'],
      deadline: json['deadline'],
      programName: json['program']?['name'],
      categoryGroup: json['categoryGroup'],
    );
  }
}

class FilterOptionItem {
  final String value;
  final String label;

  FilterOptionItem({required this.value, required this.label});
}

class ContributionFilterOptions {
  final List<FilterOptionItem> programs;
  final List<FilterOptionItem> types;
  final List<FilterOptionItem> categoryGroups;
  final List<FilterOptionItem> timeRanges;

  ContributionFilterOptions({
    required this.programs,
    required this.types,
    required this.categoryGroups,
    required this.timeRanges,
  });
}

class ContributionController extends GetxController {
  final SharedPreferences sharedPreferences;
  final ApiService apiService;

  ContributionController(
      {required this.sharedPreferences, required this.apiService});

  // Contributions list
  final RxList<ContributionModel> contributions = <ContributionModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt currentPage = 1.obs;
  final RxInt total = 0.obs;
  final RxInt contributionScore = 0.obs;
  final RxBool hasNext = false.obs;
  final RxString metaLabel = ''.obs;

  // Filter options
  final RxBool isLoadingFilters = false.obs;
  final Rx<ContributionFilterOptions?> filterOptions =
      Rx<ContributionFilterOptions?>(null);

  // Active filters
  final RxString searchQuery = ''.obs;
  final RxString selectedProgramId = ''.obs;
  final RxString selectedType = ''.obs;
  final RxString selectedLocation = ''.obs;
  final RxString selectedCategoryGroup = ''.obs;
  final RxString selectedTimeRange = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  /// Fetch contributions list with optional filters
  Future<void> fetchContributions({
    bool isLoadMore = false,
    String? search,
    String? programId,
    String? type,
    String? location,
    String? categoryGroup,
    String? timeRange,
  }) async {
    if (isLoadMore) {
      if (!hasNext.value) return;
      currentPage.value++;
    } else {
      currentPage.value = 1;
      isLoading.value = true;
    }

    try {
      String url =
          '${ApiConstants.getAllContributions}?page=${currentPage.value}&limit=10';

      final q = search ?? searchQuery.value;
      final pid = programId ?? selectedProgramId.value;
      final t = type ?? selectedType.value;
      final loc = location ?? selectedLocation.value;
      final cg = categoryGroup ?? selectedCategoryGroup.value;
      final tr = timeRange ?? selectedTimeRange.value;

      if (q.isNotEmpty) url += '&search=$q';
      if (pid.isNotEmpty) url += '&programId=$pid';
      if (t.isNotEmpty) url += '&type=$t';
      if (loc.isNotEmpty) url += '&location=$loc';
      if (cg.isNotEmpty) url += '&categoryGroup=$cg';
      if (tr.isNotEmpty) url += '&timeRange=$tr';

      final response = await apiService.get(url);

      if (response != null && response['success'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        final List<ContributionModel> newItems =
            data.map((e) => ContributionModel.fromJson(e)).toList();

        if (isLoadMore) {
          contributions.addAll(newItems);
        } else {
          contributions.value = newItems;
        }

        final meta = response['meta'];
        if (meta != null) {
          total.value = meta['total'] ?? 0;
          contributionScore.value = meta['contributionScore'] ?? 0;
          hasNext.value = meta['hasNext'] ?? false;
          metaLabel.value = meta['label'] ?? '';
        }
      }
    } catch (e) {
      print('fetchContributions error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch filter options from API
  Future<void> fetchFilterOptions() async {
    try {
      isLoadingFilters.value = true;

      final response = await apiService.get(ApiConstants.getFilterContributions);

      if (response != null && response['success'] == true) {
        final data = response['data'];

        // Programs
        final List<FilterOptionItem> programs = (data['programs'] as List? ?? [])
            .map((e) => FilterOptionItem(
                  value: e['id'] ?? '',
                  label: e['name'] ?? '',
                ))
            .toList();

        // Types
        final List<FilterOptionItem> types = (data['types'] as List? ?? [])
            .map((e) => FilterOptionItem(
                  value: e['value'] ?? '',
                  label: e['label'] ?? '',
                ))
            .toList();

        // Category Groups
        final List<FilterOptionItem> categoryGroups =
            (data['categoryGroups'] as List? ?? [])
                .map((e) => FilterOptionItem(
                      value: e['value'] ?? '',
                      label: e['label'] ?? '',
                    ))
                .toList();

        // Time Ranges
        final List<FilterOptionItem> timeRanges =
            (data['timeRanges'] as List? ?? [])
                .map((e) => FilterOptionItem(
                      value: e['value'] ?? '',
                      label: e['label'] ?? '',
                    ))
                .toList();

        filterOptions.value = ContributionFilterOptions(
          programs: programs,
          types: types,
          categoryGroups: categoryGroups,
          timeRanges: timeRanges,
        );
      }
    } catch (e) {
      print('fetchFilterOptions error: $e');
    } finally {
      isLoadingFilters.value = false;
    }
  }

  /// Apply filters and reload contributions
  void applyFilters({
    String? programId,
    String? type,
    String? location,
    String? categoryGroup,
    String? timeRange,
  }) {
    selectedProgramId.value = programId ?? '';
    selectedType.value = type ?? '';
    selectedLocation.value = location ?? '';
    selectedCategoryGroup.value = categoryGroup ?? '';
    selectedTimeRange.value = timeRange ?? '';
    fetchContributions();
  }

  /// Reset all filters
  void resetFilters() {
    selectedProgramId.value = '';
    selectedType.value = '';
    selectedLocation.value = '';
    selectedCategoryGroup.value = '';
    selectedTimeRange.value = '';
    searchQuery.value = '';
    fetchContributions();
  }
}
