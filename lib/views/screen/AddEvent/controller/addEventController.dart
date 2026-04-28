import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../services/api_service.dart';
import '../../../../utils/api_constants.dart';

class Addeventcontroller extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  RxInt activeStepIndex = 0.obs;
  RxBool isLoading = false.obs;

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

      final response = await _apiService.multipartPost(
        ApiConstants.createEvent,
        fields: fields,
        files: files.isNotEmpty ? files : null,
      );

      if (response['success'] == true) {
        Fluttertoast.showToast(msg: response['message'] ?? "Event created successfully");
        Get.back(); // Go back after success
      } else {
        Fluttertoast.showToast(msg: response['message'] ?? "Failed to create event");
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
