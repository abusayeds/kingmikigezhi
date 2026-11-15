import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../models/event_model.dart';
import '../../../../services/api_service.dart';
import '../../../../utils/api_constants.dart';

class Addeventcontroller extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

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
      Fluttertoast.showToast(msg: "This record is already added");
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
      competitionLevel = schedule.competitionLevel;
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

  Future<void> fetchHistoryEvents() async {
    isLoadingHistory.value = true;
    try {
      final response = await _apiService.get(
        "${ApiConstants.getHistoryEvents}?page=1&limit=100",
      );
      if (response['success'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        historyEvents.assignAll(
          data.map((e) => Map<String, dynamic>.from(e as Map)),
        );
      } else {
        Fluttertoast.showToast(
          msg: response['message'] ?? "Failed to fetch history events",
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      isLoadingHistory.value = false;
    }
  }

  Future<void> createEvent() async {
    if (!isUserAgreementAccepted.value) {
      showUserAgreementError.value = true;
      return;
    }
    showUserAgreementError.value = false;

    final hasCover = (coverImageBytes != null && coverImageBytes!.isNotEmpty) ||
        (coverImagePath != null && coverImagePath!.isNotEmpty) ||
        (isEditMode.value &&
            existingCoverImageUrl != null &&
            existingCoverImageUrl!.isNotEmpty);

    if (!hasCover) {
      Fluttertoast.showToast(msg: 'Please add a cover image');
      return;
    }
    if (programId == null || programId!.trim().isEmpty) {
      Fluttertoast.showToast(msg: 'Please select a program');
      return;
    }
    if (eventName == null || eventName!.trim().isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter an event name');
      return;
    }
    if (organizer == null || organizer!.trim().isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter an organizer');
      return;
    }
    if (eventPortal == null || eventPortal!.trim().isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter an event portal URL');
      return;
    }
    if (registrationPortal == null || registrationPortal!.trim().isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter a registration portal URL');
      return;
    }
    if (description == null || description!.trim().isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter a description');
      return;
    }
    if (registrationDate == null ||
        registrationTime == null ||
        deadlineDate == null ||
        deadlineTime == null) {
      Fluttertoast.showToast(msg: 'Please complete schedule dates and times');
      return;
    }

    isLoading.value = true;
    try {
      // Prepare Schedule — cost/lateFee as decimal strings (backend Decimal fields)
      Map<String, dynamic> schedule = {
        "competitionLevel": competitionLevel ?? "Local-Easy",
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
          return {
            "name": g['name']?.toString() ?? '',
            "criteria": _mapGroupCriteria(g['criteria']?.toString()),
            "condition": _mapGroupCondition(g['condition']?.toString()),
            "value": _parseGroupValue(g['value']),
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
        Fluttertoast.showToast(
            msg: response['message'] ??
                (isEditMode.value
                    ? "Event updated successfully"
                    : "Event created successfully"));

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

        // Pass the updated model back so EventDetailsScreen can update itself
        Get.back(result: updatedEvent);
      } else {
        debugPrint("=== CREATE EVENT FAILED: $response");
        Fluttertoast.showToast(
            msg: response['message'] ??
                (isEditMode.value
                    ? "Failed to update event"
                    : "Failed to create event"));
      }
    } catch (e) {
      debugPrint("=== CREATE EVENT ERROR: $e");
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      isLoading.value = false;
    }
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
  String _mapGroupCriteria(String? criteria) {
    switch (criteria) {
      case 'Score':
        return 'Score';
      case 'Age':
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
      default:
        return 'UpTo';
    }
  }

  /// Backend expects a number for group value (not "20+" / "Class A").
  num _parseGroupValue(dynamic raw) {
    if (raw is num) return raw;
    final text = raw?.toString().trim() ?? '';
    if (text.isEmpty) return 0;
    final direct = num.tryParse(text);
    if (direct != null) return direct;
    // Extract leading number from legacy labels like "20+" or "6-12"
    final match = RegExp(r'^\d+(\.\d+)?').firstMatch(text);
    if (match != null) {
      return num.tryParse(match.group(0)!) ?? 0;
    }
    return 0;
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
    List<Map<String, dynamic>> rounds,
  ) {
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
