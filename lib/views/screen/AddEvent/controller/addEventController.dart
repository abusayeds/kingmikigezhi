import 'dart:convert';
import 'dart:typed_data';
import 'package:event_sharing/controllers/home_controller.dart';
import 'package:event_sharing/helpers/app_feedback.dart';
import 'package:event_sharing/helpers/route.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../models/event_model.dart';
import '../../../../services/api_service.dart';
import '../../../../utils/api_constants.dart';

class Addeventcontroller extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  static const List<String> allowedCompetitionLevels = [
    'Local-Easy',
    'Local-Medium',
    'Local-Difficult',
    'Regional-Easy',
    'Regional-Medium',
    'Regional-Difficult',
    'State-Easy',
    'State-Medium',
    'State-Difficult',
    'National-Easy',
    'National-Medium',
    'National-Difficult',
    'International-Easy',
    'International-Medium',
    'International-Difficult',
  ];

  RxInt activeStepIndex = 0.obs;
  RxBool isLoading = false.obs;

  // Edit mode (update existing event)
  RxBool isEditMode = false.obs;
  String? editingEventId;
  String? existingCoverImageUrl;
  String? programName;

  // Step 1: Basic
  String? coverImagePath;
  /// Used on web where MultipartFile.fromPath is unreliable.
  Uint8List? coverImageBytes;
  String? coverImageFileName;
  RxBool isRepeated = false.obs;
  String? repeatOption;
  String? sessionNumber;
  String? year;
  String? sessionFrequency;
  String? sessionSubOption;
  String? programId;
  String? organizer;
  String? eventName;
  String? eventPortal;
  String? registrationPortal;
  String? description;
  String? note;

  // Step 2: Details
  String? competitionLevel;
  String? eventType;
  String? registrationDate;
  String? registrationTime;
  String? deadlineDate;
  String? deadlineTime;
  double? cost;
  bool hasFinalDeadline = false;
  String? finalDeadlineYear;
  String? finalDeadlineMonth;
  String? finalDeadlineDay;
  double? lateFee;

  // Step 3: Group
  RxList<Map<String, dynamic>> groups = <Map<String, dynamic>>[].obs;
  
  // Temporary state for adding a group
  RxList<Map<String, dynamic>> tempRounds = <Map<String, dynamic>>[].obs;

  // Step 5: History & Agreements
  RxBool isSharedToCommunity = true.obs;
  RxBool isUserAgreementAccepted = false.obs;
  RxBool showUserAgreementError = false.obs;
  RxBool isLoadingHistory = false.obs;
  RxList<Map<String, dynamic>> historyEvents = <Map<String, dynamic>>[].obs;
  String? selectedHistoryEventId;

  // Own history records added by user (shown in History box, sent as previousEvents)
  RxList<Map<String, dynamic>> ownHistories = <Map<String, dynamic>>[].obs;

  void addOwnHistory({
    required String eventId,
    required String eventName,
    required String year,
    required String placement,
  }) {
    // placement is unique per event on backend (@@unique([eventId, placement]))
    final exists = ownHistories.any((h) => h['placement'] == placement);
    if (exists) {
      AppFeedback.validation('This history record is already added.');
      return;
    }
    ownHistories.add({
      "eventId": eventId,
      "eventName": eventName,
      "year": year,
      "placement": placement,
    });
  }

  void removeOwnHistory(int index) {
    if (index >= 0 && index < ownHistories.length) {
      ownHistories.removeAt(index);
    }
  }

  // Map UI placement label to backend PlacementType enum
  String _mapPlacement(String placement) {
    switch (placement) {
      case "1st":
      case "1 Prize":
        return "First";
      case "2nd":
      case "2 Prize":
        return "Second";
      case "3rd":
      case "3 Prize":
        return "Third";
      case "4th":
      case "4 Prize":
        return "Fourth";
      case "5th":
      case "5 Prize":
        return "Fifth";
      case "6th":
      case "6 Prize":
        return "Sixth";
      case "Silver":
        return "Silver";
      case "Gold":
        return "Gold";
      case "Grand Prize":
      case "Honorable Mention":
      case "Audience Awards":
      case "Special Prize":
        return placement;
      default:
        return placement;
    }
  }

  // Reset everything for a fresh create flow
  void resetForm() {
    activeStepIndex.value = 0;
    isEditMode.value = false;
    editingEventId = null;
    existingCoverImageUrl = null;
    programName = null;
    coverImagePath = null;
    coverImageBytes = null;
    coverImageFileName = null;
    isRepeated.value = false;
    repeatOption = null;
    sessionNumber = null;
    year = null;
    sessionFrequency = null;
    sessionSubOption = null;
    programId = null;
    organizer = null;
    eventName = null;
    eventPortal = null;
    registrationPortal = null;
    description = null;
    note = null;
    competitionLevel = null;
    eventType = null;
    registrationDate = null;
    registrationTime = null;
    deadlineDate = null;
    deadlineTime = null;
    cost = null;
    hasFinalDeadline = false;
    finalDeadlineYear = null;
    finalDeadlineMonth = null;
    finalDeadlineDay = null;
    lateFee = null;
    groups.isNotEmpty ? groups.clear() : null;
    tempRounds.isNotEmpty ? tempRounds.clear() : null;
    isSharedToCommunity.value = true;
    isUserAgreementAccepted.value = false;
    showUserAgreementError.value = false;
    selectedHistoryEventId = null;
    ownHistories.isNotEmpty ? ownHistories.clear() : null;
  }

  // Prefill all steps from an existing event (Edit & Verify flow)
  void loadFromEvent(EventModel event) {
    resetForm();
    isEditMode.value = true;
    editingEventId = event.id;

    // Step 1: Basic
    existingCoverImageUrl = event.coverImage;
    programId = event.programId ?? event.program?.id;
    programName = event.program?.name;
    organizer = event.organizer;
    eventName = event.eventName;
    eventPortal = event.eventPortal;
    registrationPortal = event.registrationPortal;
    description = event.description;
    note = event.note;

    // Session fields from top-level event
    year = event.year;
    sessionFrequency = event.session;       // "Daily", "Weekly", etc.
    sessionSubOption = event.sessionValue;  // "Tuesday", "Week 1", etc.
    sessionNumber = event.sessionLevel;     // "2026-Tuesday"

    final frequency = event.repeatConfig?.frequency;
    if (frequency != null && frequency.isNotEmpty && frequency != 'DontRepeat') {
      isRepeated.value = true;
      repeatOption = _mapRepeatOptionToUI(frequency);
    }

    // Step 2: Details
    final schedule = event.schedule;
    if (schedule != null) {
      // Older events may still store round types (Preliminary/SemiFinal/Final).
      // Clear invalid values so the user re-selects a valid competition level.
      competitionLevel = _normalizeCompetitionLevel(schedule.competitionLevel);
      eventType = schedule.eventType;
      if (schedule.registrationDate != null) {
        registrationDate = DateFormat('yyyy-MM-dd').format(schedule.registrationDate!);
        registrationTime = DateFormat('hh:mm a').format(schedule.registrationDate!);
      }
      if (schedule.deadline != null) {
        deadlineDate = DateFormat('yyyy-MM-dd').format(schedule.deadline!);
        deadlineTime = DateFormat('hh:mm a').format(schedule.deadline!);
      }
      cost = double.tryParse(schedule.cost ?? '');
      hasFinalDeadline = schedule.hasFinalDeadline ?? false;
      if (schedule.finalDeadline != null) {
        finalDeadlineYear = schedule.finalDeadline!.year.toString();
        finalDeadlineMonth = schedule.finalDeadline!.month.toString();
        finalDeadlineDay = schedule.finalDeadline!.day.toString();
      }
      lateFee = double.tryParse(schedule.lateFee ?? '');
    }

    // Step 3: Groups — API returns groups at the TOP LEVEL of the event,
    // not inside schedule.
    if (event.groups != null) {
      groups.assignAll(event.groups!.map((g) => {
            "name": g.name ?? '',
            "criteria": _mapGroupCriteria(g.criteria),
            "condition": _mapGroupCondition(g.condition),
            "value": _parseGroupValue(g.value),
            "valueLabel": g.valueLabel,
            "rounds": (g.rounds ?? [])
                .map((r) => {
                      "roundType": r.roundType ?? 'Preliminary',
                      "deadline": r.deadline?.toUtc().toIso8601String(),
                      "cost": double.tryParse(r.cost ?? '') ?? 0,
                      "hasFinalDeadline": r.hasFinalDeadline ?? false,
                      "finalDeadline": r.finalDeadline?.toUtc().toIso8601String(),
                      "lateFee": double.tryParse(r.lateFee ?? '') ?? 0,
                      "description": r.description,
                    })
                .toList(),
          }));
    }
  }

  String _mapRepeatOptionToUI(String frequency) {
    switch (frequency) {
      case "DontRepeat": return "Don't Repeat";
      case "Daily": return "Daily";
      case "Weekly": return "Weekly";
      case "Monthly": return "Monthly";
      case "Quarterly": return "Quarterly";
      case "Yearly": return "Yearly";
      default: return "Don't Repeat";
    }
  }

  /// [silent] keeps existing items visible and skips the field spinner.
  Future<void> fetchHistoryEvents({bool silent = false}) async {
    final showLoader = !silent && historyEvents.isEmpty;
    if (showLoader) isLoadingHistory.value = true;
    try {
      final response = await _apiService.get(
        "${ApiConstants.getHistoryEvents}?page=1&limit=100",
      );
      if (response['success'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        historyEvents.assignAll(
          data.map((e) => Map<String, dynamic>.from(e as Map)),
        );
      } else if (!silent) {
        AppFeedback.error(
          response['message']?.toString() ??
              'Could not load history events right now.',
        );
      }
    } catch (e) {
      if (!silent) AppFeedback.error(e.toString());
    } finally {
      if (showLoader) isLoadingHistory.value = false;
    }
  }

  Future<void> createEvent() async {
    if (!isUserAgreementAccepted.value) {
      showUserAgreementError.value = true;
      activeStepIndex.value = 3;
      AppFeedback.validation('Please accept the user agreement to continue.');
      return;
    }
    showUserAgreementError.value = false;

    // The cover photo is optional — the backend falls back to the app logo.
    if (programId == null || programId!.trim().isEmpty) {
      _goToStepWithValidation(0, 'Select a program for this event.');
      return;
    }
    if (eventName == null || eventName!.trim().isEmpty) {
      _goToStepWithValidation(0, 'Enter an event name.');
      return;
    }
    if (organizer == null || organizer!.trim().isEmpty) {
      _goToStepWithValidation(0, 'Enter the organizer name.');
      return;
    }
    if (eventPortal == null || eventPortal!.trim().isEmpty) {
      _goToStepWithValidation(0, 'Add an event portal / website link.');
      return;
    }
    if (registrationPortal == null || registrationPortal!.trim().isEmpty) {
      _goToStepWithValidation(0, 'Add a registration portal link.');
      return;
    }
    if (description == null || description!.trim().isEmpty) {
      _goToStepWithValidation(0, 'Write a short description for your event.');
      return;
    }
    if (registrationDate == null ||
        registrationDate!.trim().isEmpty ||
        registrationTime == null ||
        registrationTime!.trim().isEmpty ||
        deadlineDate == null ||
        deadlineDate!.trim().isEmpty ||
        deadlineTime == null ||
        deadlineTime!.trim().isEmpty) {
      _goToStepWithValidation(
        1,
        'Complete registration open date/time and deadline date/time.',
      );
      return;
    }

    final normalizedCompetitionLevel =
        _normalizeCompetitionLevel(competitionLevel);
    if (normalizedCompetitionLevel == null) {
      _goToStepWithValidation(
        1,
        'Select a competition level (for example Local-Easy or National-Medium).',
      );
      return;
    }
    competitionLevel = normalizedCompetitionLevel;

    if (eventType == null || eventType!.trim().isEmpty) {
      _goToStepWithValidation(1, 'Select an event type (Onsite, Online, or Hybrid).');
      return;
    }

    isLoading.value = true;
    try {
      // Prepare Schedule — cost/lateFee as decimal strings (backend Decimal fields)
      Map<String, dynamic> schedule = {
        "competitionLevel": competitionLevel,
        "eventType": eventType ?? "Online",
        "registrationDate": _combineDateTime(registrationDate, registrationTime),
        "deadline": _combineDateTime(deadlineDate, deadlineTime),
        "cost": _formatDecimalString(cost ?? 0),
        "hasFinalDeadline": hasFinalDeadline,
        "finalDeadline": hasFinalDeadline
            ? _combineDateParts(
                finalDeadlineYear, finalDeadlineMonth, finalDeadlineDay)
            : null,
        "lateFee": _formatDecimalString(hasFinalDeadline ? (lateFee ?? 0) : 0),
      };

      // Prepare Fields for Multipart
      Map<String, String> fields = {
        "eventName": eventName ?? "",
        "programId": programId ?? "",
        "organizer": organizer ?? "",
        "eventPortal": eventPortal ?? "",
        "registrationPortal": registrationPortal ?? "",
        "description": description ?? "",
        "schedule": jsonEncode(schedule),
        "isSharedToCommunity": isSharedToCommunity.value.toString(),
        "isUserAgreementAccepted": isUserAgreementAccepted.value.toString(),
      };

      if (note != null && note!.isNotEmpty) fields["note"] = note!;

      // Session fields — must match backend field names exactly:
      // year → "year", sessionFrequency → "session",
      // sessionSubOption → "sessionValue", sessionNumber → "sessionLevel"
      if (year != null && year!.isNotEmpty) fields["year"] = year!;
      if (sessionFrequency != null && sessionFrequency!.isNotEmpty) fields["session"] = sessionFrequency!;
      if (sessionSubOption != null && sessionSubOption!.isNotEmpty) fields["sessionValue"] = sessionSubOption!;
      if (sessionNumber != null && sessionNumber!.isNotEmpty) fields["sessionLevel"] = sessionNumber!;
      
      if (isRepeated.value && repeatOption != null) {
        // Map UI repeat option to Backend Enum
        String repeatFunction = _mapRepeatOption(repeatOption!);
        fields["repeatConfig"] = jsonEncode({
          "repeatFunction": repeatFunction,
          "startDate": _combineDateTime(registrationDate, registrationTime),
        });
      }

      // Groups are sent at the TOP LEVEL (not inside schedule).
      // criteria: Age|Score, condition: API enums, value: number.
      // Round cost/lateFee must be strings (backend Decimal).
      if (groups.isNotEmpty) {
        final plainGroups = groups.map((g) {
          final rawRounds =
              (g['rounds'] as List?)?.cast<Map<String, dynamic>>() ?? [];
          final label = g['valueLabel']?.toString().trim();
          return {
            "name": g['name']?.toString() ?? '',
            "criteria": _mapGroupCriteria(g['criteria']?.toString()),
            "condition": _mapGroupCondition(g['condition']?.toString()),
            // Omit nulls — the backend treats absent as "not set".
            if (_parseGroupValue(g['value']) != null)
              "value": _parseGroupValue(g['value']),
            if (label != null && label.isNotEmpty) "valueLabel": label,
            "rounds": rawRounds.map((r) {
              final rawCost = r['cost'];
              final rawLateFee = r['lateFee'];
              final costNum = rawCost is num
                  ? rawCost.toDouble()
                  : double.tryParse(rawCost?.toString() ?? '') ?? 0.0;
              final lateFeeNum = rawLateFee is num
                  ? rawLateFee.toDouble()
                  : double.tryParse(rawLateFee?.toString() ?? '') ?? 0.0;

              final Map<String, dynamic> round = {
                "roundType": r['roundType']?.toString() ?? 'Preliminary',
                "deadline": r['deadline']?.toString() ?? '',
                "cost": _formatDecimalString(costNum),
              };

              if (r['hasFinalDeadline'] == true) {
                round["hasFinalDeadline"] = true;
                if (r['finalDeadline'] != null) {
                  round["finalDeadline"] = r['finalDeadline'].toString();
                }
                round["lateFee"] = _formatDecimalString(lateFeeNum);
              }
              if (r['description'] != null &&
                  r['description'].toString().isNotEmpty) {
                round["description"] = r['description'].toString();
              }

              return round;
            }).toList(),
          };
        }).toList();
        fields["groups"] = jsonEncode(plainGroups);
      }

      // Own history → previousEvents { id, recordName } (backend contract).
      if (ownHistories.isNotEmpty) {
        fields["previousEvents"] = jsonEncode(ownHistories
            .map((h) => {
                  "id": h['eventId']?.toString() ?? '',
                  "recordName":
                      "${h['year']} - ${h['placement']} place winner",
                })
            .where((h) => (h['id'] as String).isNotEmpty)
            .toList());
      } else {
        debugPrint("=== CREATE EVENT: no own history — omitting previousEvents ===");
      }

      // Prepare Files (path for mobile; bytes for web)
      Map<String, String> files = {};
      Map<String, List<int>>? fileBytes;
      if (coverImageBytes != null && coverImageBytes!.isNotEmpty) {
        fileBytes = {
          'coverImage': coverImageBytes!,
        };
      } else if (coverImagePath != null && coverImagePath!.isNotEmpty) {
        files["coverImage"] = coverImagePath!;
      } else if (isEditMode.value &&
          existingCoverImageUrl != null &&
          existingCoverImageUrl!.isNotEmpty) {
        fields['coverImage'] = existingCoverImageUrl!;
      }

      debugPrint("=== CREATE EVENT REQUEST ===");
      fields.forEach((k, v) => debugPrint("$k: $v"));
      debugPrint("files: $files, hasBytes: ${fileBytes != null}");

      final fileNames = coverImageFileName != null
          ? {'coverImage': coverImageFileName!}
          : null;

      final dynamic response;
      if (isEditMode.value && editingEventId != null) {
        response = await _apiService.multipartRequest(
          ApiConstants.updateEvents.replaceAll(':eventId', editingEventId!),
          method: 'PATCH',
          fields: fields,
          files: files.isNotEmpty ? files : null,
          fileBytes: fileBytes,
          fileNames: fileNames,
        );
      } else {
        response = await _apiService.multipartRequest(
          ApiConstants.createEvent,
          method: 'POST',
          fields: fields,
          files: files.isNotEmpty ? files : null,
          fileBytes: fileBytes,
          fileNames: fileNames,
        );
      }

      if (response['success'] == true) {
        final wasEdit = isEditMode.value;

        // Parse the updated event from the response so the caller screen
        // can refresh itself without an extra API call.
        EventModel? updatedEvent;
        try {
          final rawData = response['data'];
          if (rawData != null) {
            final Map<String, dynamic> data = rawData is Map<String, dynamic>
                ? rawData
                : Map<String, dynamic>.from(rawData as Map);
            updatedEvent = EventModel.fromJson(data);
          }
        } catch (_) {}

        // Refresh feeds so the new/updated event shows in lists.
        _refreshEventFeeds();

        if (wasEdit) {
          // Toast survives Get.back(); snackbar would be dismissed with the route.
          AppFeedback.toast(
            response['message']?.toString() ?? 'Event updated successfully.',
          );
          Get.back(result: updatedEvent ?? true);
        } else {
          AppFeedback.success(
            response['message']?.toString() ?? 'Event created successfully.',
          );
          if (updatedEvent?.id != null) {
            // Replace create form with the new event details page.
            Get.offNamed(
              AppRoutes.eventDetailsScreen,
              arguments: updatedEvent,
            );
          } else {
            // Fallback if response had no event payload.
            Get.offNamed(AppRoutes.myEventScreen);
          }
        }
      } else {
        debugPrint("=== CREATE EVENT FAILED: $response");
        AppFeedback.error(
          response['message']?.toString() ??
              (isEditMode.value
                  ? 'Could not update the event. Please try again.'
                  : 'Could not create the event. Please try again.'),
        );
      }
    } catch (e) {
      debugPrint("=== CREATE EVENT ERROR: $e");
      AppFeedback.error(
        e.toString(),
        title: isEditMode.value
            ? 'Could not update event'
            : 'Could not create event',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _refreshEventFeeds() {
    if (!Get.isRegistered<HomeController>()) return;
    final home = Get.find<HomeController>();
    home.fetchTodayEvents();
    home.fetchUpcomingEvents();
    home.fetchHistoryEvents();
    home.fetchCreatedEvents();
  }

  /// Returns a valid schedule competition level, or null if the user must pick one.
  String? _normalizeCompetitionLevel(String? raw) {
    if (raw == null) return null;
    final value = raw.trim();
    if (value.isEmpty) return null;
    if (allowedCompetitionLevels.contains(value)) return value;

    // Legacy enum values previously stored on schedule.competitionLevel.
    switch (value) {
      case 'Preliminary':
      case 'SemiFinal':
      case 'Final':
        return null;
      default:
        return null;
    }
  }

  void _goToStepWithValidation(int step, String message) {
    activeStepIndex.value = step;
    AppFeedback.validation(message);
  }

  String _mapRepeatOption(String option) {
    switch (option) {
      case "Don't Repeat": return "DontRepeat";
      case "Daily": return "Daily";
      case "Weekly": return "Weekly";
      case "Monthly": return "Monthly";
      case "Quarterly": return "Quarterly";
      case "Yearly": return "Yearly";
      default: return "DontRepeat";
    }
  }

  /// Backend GroupCriteria: Age | Score
  /// Backend `GroupCriteria`: Default | Age | Score | UTR | Level | Class.
  String _mapGroupCriteria(String? criteria) {
    switch (criteria) {
      case 'Default':
      case 'Score':
      case 'UTR':
      case 'Level':
      case 'Class':
      case 'Age':
        return criteria!;
      default:
        return 'Age';
    }
  }

  /// Map UI / legacy condition labels to backend GroupCondition enums.
  String _mapGroupCondition(String? condition) {
    switch (condition) {
      case 'UpTo':
        return 'UpTo';
      case 'DownTo':
        return 'DownTo';
      case 'Greater Than':
      case 'Greater':
        return 'Greater';
      case 'Greater And Equal':
      case 'GreaterAndEqual':
        return 'GreaterAndEqual';
      case 'Less Than':
      case 'Lower':
        return 'Lower';
      case 'Less And Equal':
      case 'LowerAndEqual':
        return 'LowerAndEqual';
      case 'Default':
        return 'Default';
      case 'Equal':
        return 'Equal';
      default:
        return 'UpTo';
    }
  }

  /// Numeric group bound, or null when the group is label-based
  /// (UTR / Level / Class) or Default.
  num? _parseGroupValue(dynamic raw) {
    if (raw is num) return raw;
    final text = raw?.toString().trim() ?? '';
    if (text.isEmpty) return null;
    final direct = num.tryParse(text);
    if (direct != null) return direct;
    // Extract a leading number from labels like "20+" or "6-12".
    final match = RegExp(r'^\d+(\.\d+)?').firstMatch(text);
    if (match != null) {
      return num.tryParse(match.group(0)!);
    }
    return null;
  }

  String _formatDecimalString(num v) {
    final d = v.toDouble();
    return d == d.roundToDouble() ? d.toInt().toString() : d.toString();
  }

  String _combineDateTime(String? date, String? time) {
    if (date == null || date.isEmpty) return DateTime.now().toUtc().toIso8601String();
    if (time == null || time.isEmpty) return "${date}T00:00:00.000Z";
    
    try {
      // time format is "hh:mm a" (e.g., "10:30 AM")
      DateTime parsedTime = DateFormat("hh:mm a").parse(time);
      String time24 = DateFormat("HH:mm:ss").format(parsedTime);
      return "${date}T$time24.000Z";
    } catch (e) {
      return "${date}T00:00:00.000Z";
    }
  }

  String _combineDateParts(String? y, String? m, String? d) {
    if (y == null || m == null || d == null || y.isEmpty || m.isEmpty || d.isEmpty) {
      return DateTime.now().toUtc().toIso8601String();
    }
    try {
      int year = int.parse(y);
      int month = int.parse(m);
      int day = int.parse(d);
      return DateTime.utc(year, month, day).toIso8601String();
    } catch (e) {
      return DateTime.now().toUtc().toIso8601String();
    }
  }

  void addGroup(
    String name,
    String criteria,
    String condition,
    dynamic value,
    List<Map<String, dynamic>> rounds, {
    String? valueLabel,
  }) {
    // Deep-copy each round map so clearing tempRounds has zero effect on what
    // is stored inside the group.
    final copiedRounds = rounds
        .map((r) => Map<String, dynamic>.from(r))
        .toList();
    groups.add({
      "name": name,
      "criteria": _mapGroupCriteria(criteria),
      "condition": _mapGroupCondition(condition),
      "value": _parseGroupValue(value),
      "valueLabel": valueLabel?.trim().isNotEmpty == true
          ? valueLabel!.trim()
          : null,
      "rounds": copiedRounds,
    });
    // Reassign so GetX triggers a reactive rebuild on all Obx listeners.
    groups.refresh();
  }

  void removeGroup(int index) {
    if (index >= 0 && index < groups.length) {
      groups.removeAt(index);
    }
  }

  void removeRoundFromGroup(int groupIndex, int roundIndex) {
    if (groupIndex >= 0 && groupIndex < groups.length) {
      final group = groups[groupIndex];
      final rounds = (group['rounds'] as List?)?.cast<Map<String, dynamic>>();
      if (rounds != null && roundIndex >= 0 && roundIndex < rounds.length) {
        rounds.removeAt(roundIndex);
        // Reassign the whole entry so GetX sees the change and redraws.
        groups[groupIndex] = Map<String, dynamic>.from(group);
        groups.refresh();
      }
    }
  }

  void addTempRound({
    required String roundType,
    required String? date,
    required String? time,
    required double cost,
    required bool hasFinalDeadline,
    String? fYear,
    String? fMonth,
    String? fDay,
    required double lateFee,
    String? description,
  }) {
    Map<String, dynamic> round = {
      "roundType": roundType, // Preliminary, SemiFinal, Final
      "deadline": _combineDateTime(date, time),
      "cost": cost,
      "hasFinalDeadline": hasFinalDeadline,
      "lateFee": lateFee,
      "description": description,
    };
    if (hasFinalDeadline) {
      round["finalDeadline"] = _combineDateParts(fYear, fMonth, fDay);
    } else {
      round["finalDeadline"] = null;
    }
    tempRounds.add(round);
  }

  void clearTempRounds() {
    tempRounds.clear();
  }
}
