import 'dart:convert';
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
  RxBool isLoadingHistory = false.obs;
  RxList<Map<String, dynamic>> historyEvents = <Map<String, dynamic>>[].obs;
  String? selectedHistoryEventId;

  // Reset everything for a fresh create flow
  void resetForm() {
    activeStepIndex.value = 0;
    isEditMode.value = false;
    editingEventId = null;
    existingCoverImageUrl = null;
    programName = null;
    coverImagePath = null;
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
    selectedHistoryEventId = null;
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

      // Step 3: Groups
      if (schedule.groups != null) {
        groups.assignAll(schedule.groups!.map((g) => {
              "name": g.name ?? '',
              "criteria": g.criteria ?? 'Age',
              "condition": g.condition ?? 'UpTo',
              "value": g.value ?? 0,
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
      Fluttertoast.showToast(msg: "Please accept the user agreement");
      return;
    }

    isLoading.value = true;
    try {
      // Prepare Schedule
      Map<String, dynamic> schedule = {
        "competitionLevel": competitionLevel ?? "Preliminary",
        "eventType": eventType ?? "Online",
        "registrationDate": _combineDateTime(registrationDate, registrationTime),
        "deadline": _combineDateTime(deadlineDate, deadlineTime),
        "cost": cost ?? 0,
      };

      if (hasFinalDeadline) {
        schedule["hasFinalDeadline"] = true;
        schedule["finalDeadline"] = _combineDateParts(finalDeadlineYear, finalDeadlineMonth, finalDeadlineDay);
        schedule["lateFee"] = lateFee ?? 0;
      }

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

      if (note != null) fields["note"] = note!;
      if (year != null) fields["year"] = year!;
      if (sessionFrequency != null) fields["session"] = sessionFrequency!;
      if (sessionSubOption != null) fields["sessionValue"] = sessionSubOption!;
      if (sessionNumber != null) fields["sessionLevel"] = sessionNumber!;
      
      if (isRepeated.value && repeatOption != null) {
        // Map UI repeat option to Backend Enum
        String repeatFunction = _mapRepeatOption(repeatOption!);
        fields["repeatConfig"] = jsonEncode({
          "repeatFunction": repeatFunction,
          "startDate": _combineDateTime(registrationDate, registrationTime),
        });
      }

      if (groups.isNotEmpty) {
        fields["groups"] = jsonEncode(groups);
      }

      // Prepare Files
      Map<String, String> files = {};
      if (coverImagePath != null) {
        files["coverImage"] = coverImagePath!;
      }

      final dynamic response;
      if (isEditMode.value && editingEventId != null) {
        // Update existing event (Edit & Verify flow)
        response = await _apiService.multipartRequest(
          ApiConstants.updateEvents.replaceAll(':eventId', editingEventId!),
          method: 'PATCH',
          fields: fields,
          files: files.isNotEmpty ? files : null,
        );
      } else {
        // Create new event (previous logic kept same)
        response = await _apiService.multipartPost(
          ApiConstants.createEvent,
          fields: fields,
          files: files.isNotEmpty ? files : null,
        );
      }

      if (response['success'] == true) {
        Fluttertoast.showToast(
            msg: response['message'] ??
                (isEditMode.value
                    ? "Event updated successfully"
                    : "Event created successfully"));
        Get.back(); // Go back after success
      } else {
        Fluttertoast.showToast(
            msg: response['message'] ??
                (isEditMode.value
                    ? "Failed to update event"
                    : "Failed to create event"));
      }
    } catch (e) {
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

  void addGroup(String name, String criteria, String condition, int value, List<Map<String, dynamic>> rounds) {
    groups.add({
      "name": name,
      "criteria": criteria, // Age or Score
      "condition": condition, // UpTo, DownTo, etc.
      "value": value,
      "rounds": List<Map<String, dynamic>>.from(rounds),
    });
  }

  void removeGroup(int index) {
    if (index >= 0 && index < groups.length) {
      groups.removeAt(index);
    }
  }

  void removeRoundFromGroup(int groupIndex, int roundIndex) {
    if (groupIndex >= 0 && groupIndex < groups.length) {
      final rounds = groups[groupIndex]['rounds'] as List<dynamic>?;
      if (rounds != null && roundIndex >= 0 && roundIndex < rounds.length) {
        rounds.removeAt(roundIndex);
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
