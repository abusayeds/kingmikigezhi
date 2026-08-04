class EventModel {
  final String? id;
  final String? eventName;
  final String? baseEventName;
  final String? coverImage;
  final String? programId;
  final String? organizer;
  final String? location;
  final String? eventPortal;
  final String? registrationPortal;
  final String? description;
  final String? note;
  final bool? isPublished;
  final bool? isActive;
  final bool? isVerified;
  final bool? isDisabled;
  final bool? isDeleted;
  final bool? isSharedToCommunity;
  final bool? isUserAgreementAccepted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? sessionId;
  // Session fields returned at the top level of the event
  final String? year;
  final String? session;        // e.g. "Daily"
  final String? sessionValue;   // e.g. "Tuesday"
  final String? sessionLevel;   // e.g. "2026-Tuesday"
  final List<dynamic>? results;
  final int? applicationCount;
  final Program? program;
  final RepeatConfig? repeatConfig;
  final Creator? creator;
  final Schedule? schedule;
  // Groups are returned at the top level of the event (not inside schedule)
  final List<Group>? groups;
  // Previous events (history records linked to this event)
  final List<PreviousEvent>? previousEvents;
  final List<EventApplied>? eventApplieds;

  EventModel({
    this.id,
    this.eventName,
    this.baseEventName,
    this.coverImage,
    this.programId,
    this.organizer,
    this.location,
    this.eventPortal,
    this.registrationPortal,
    this.description,
    this.note,
    this.isPublished,
    this.isActive,
    this.isVerified,
    this.isDisabled,
    this.isDeleted,
    this.isSharedToCommunity,
    this.isUserAgreementAccepted,
    this.createdAt,
    this.updatedAt,
    this.sessionId,
    this.year,
    this.session,
    this.sessionValue,
    this.sessionLevel,
    this.results,
    this.applicationCount,
    this.program,
    this.repeatConfig,
    this.creator,
    this.schedule,
    this.groups,
    this.previousEvents,
    this.eventApplieds,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        id: json["id"],
        eventName: json["eventName"],
        baseEventName: json["baseEventName"],
        coverImage: json["coverImage"],
        programId: json["programId"],
        organizer: json["organizer"],
        location: json["location"],
        eventPortal: json["eventPortal"],
        registrationPortal: json["registrationPortal"],
        description: json["description"],
        note: json["note"],
        isPublished: json["isPublished"],
        isActive: json["isActive"],
        isVerified: json["isVerified"],
        isDisabled: json["isDisabled"],
        isDeleted: json["isDeleted"],
        isSharedToCommunity: json["isSharedToCommunity"],
        isUserAgreementAccepted: json["isUserAgreementAccepted"],
        createdAt: _parseDateTime(json["createdAt"] ?? json["created_at"]),
        updatedAt: _parseDateTime(json["updatedAt"] ?? json["updated_at"]),
        sessionId: json["sessionId"],
        year: json["year"],
        session: json["session"],
        sessionValue: json["sessionValue"],
        sessionLevel: json["sessionLevel"],
        results: json["results"] == null ? null : List<dynamic>.from(json["results"].map((x) => x)),
        applicationCount: json["_count"] == null ? null : json["_count"]["eventApplieds"] ?? json["_count"]["applications"],
        program: json["program"] == null ? null : Program.fromJson(json["program"]),
        repeatConfig: json["repeatConfig"] == null ? null : RepeatConfig.fromJson(json["repeatConfig"]),
        creator: json["creator"] == null ? null : Creator.fromJson(json["creator"]),
        schedule: json["schedule"] == null ? null : Schedule.fromJson(json["schedule"]),
        // Groups live at the event top level
        groups: json["groups"] == null
            ? null
            : List<Group>.from((json["groups"] as List).map((x) => Group.fromJson(x))),
        previousEvents: json["previousEvents"] == null
            ? null
            : List<PreviousEvent>.from((json["previousEvents"] as List).map((x) => PreviousEvent.fromJson(x))),
        eventApplieds: json["eventApplieds"] == null ? null : List<EventApplied>.from(json["eventApplieds"].map((x) => EventApplied.fromJson(x))),
      );

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return DateTime.tryParse(value.toString());
  }
}

class EventApplied {
  final String? id;
  final String? userId;
  final String? note;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Creator? user;

  EventApplied({
    this.id,
    this.userId,
    this.note,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory EventApplied.fromJson(Map<String, dynamic> json) => EventApplied(
        id: json["id"],
        userId: json["userId"],
        note: json["note"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        user: json["user"] == null ? null : Creator.fromJson(json["user"]),
      );
}

class Creator {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? profilePicture;
  final int? contributionScore;

  Creator({this.id, this.firstName, this.lastName, this.username, this.profilePicture, this.contributionScore});

  factory Creator.fromJson(Map<String, dynamic> json) => Creator(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        username: json["username"],
        profilePicture: json["profilePicture"],
        contributionScore: json["contributionScore"],
      );
}

class RepeatConfig {
  final String? id;
  final String? frequency;
  final DateTime? startDate;

  RepeatConfig({this.id, this.frequency, this.startDate});

  factory RepeatConfig.fromJson(Map<String, dynamic> json) => RepeatConfig(
        id: json["id"],
        frequency: json["frequency"],
        startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
      );
}

class Program {
  final String? id;
  final String? name;
  final String? description;
  final String? imageUrl;

  Program({this.id, this.name, this.description, this.imageUrl});

  factory Program.fromJson(Map<String, dynamic> json) => Program(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        imageUrl: json["imageUrl"],
      );
}

class Schedule {
  final String? id;
  final String? competitionLevel;
  final String? eventType;
  final DateTime? registrationDate;
  final DateTime? deadline;
  final String? cost;
  final bool? hasFinalDeadline;
  final DateTime? finalDeadline;
  final String? lateFee;
  final EstimatedCost? estimatedCost;

  Schedule({
    this.id,
    this.competitionLevel,
    this.eventType,
    this.registrationDate,
    this.deadline,
    this.cost,
    this.hasFinalDeadline,
    this.finalDeadline,
    this.lateFee,
    this.estimatedCost,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        id: json["id"],
        competitionLevel: json["competitionLevel"],
        eventType: json["eventType"],
        registrationDate: json["registrationDate"] == null ? null : DateTime.parse(json["registrationDate"]),
        deadline: json["deadline"] == null ? null : DateTime.parse(json["deadline"]),
        cost: json["cost"],
        hasFinalDeadline: json["hasFinalDeadline"],
        finalDeadline: json["finalDeadline"] == null ? null : DateTime.parse(json["finalDeadline"]),
        lateFee: json["lateFee"],
        estimatedCost: json["estimatedCost"] == null ? null : EstimatedCost.fromJson(json["estimatedCost"]),
      );
}

class Group {
  final String? id;
  final String? name;
  final String? criteria;
  final String? condition;
  final int? value;
  final List<Round>? rounds;
  final int? totalRoundCost;

  Group({this.id, this.name, this.criteria, this.condition, this.value, this.rounds, this.totalRoundCost});

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        id: json["id"],
        name: json["name"],
        criteria: json["criteria"],
        condition: json["condition"],
        value: json["value"],
        rounds: json["rounds"] == null ? null : List<Round>.from(json["rounds"].map((x) => Round.fromJson(x))),
        totalRoundCost: json["totalRoundCost"],
      );
}

class Round {
  final String? id;
  final String? roundType;
  final DateTime? deadline;
  final String? cost;
  final bool? hasFinalDeadline;
  final DateTime? finalDeadline;
  final String? lateFee;
  final String? description;

  Round({this.id, this.roundType, this.deadline, this.cost, this.hasFinalDeadline, this.finalDeadline, this.lateFee, this.description});

  factory Round.fromJson(Map<String, dynamic> json) => Round(
        id: json["id"],
        roundType: json["roundType"],
        deadline: json["deadline"] == null ? null : DateTime.parse(json["deadline"]),
        cost: json["cost"],
        hasFinalDeadline: json["hasFinalDeadline"],
        finalDeadline: json["finalDeadline"] == null ? null : DateTime.parse(json["finalDeadline"]),
        lateFee: json["lateFee"],
        description: json["description"],
      );
}

class EstimatedCost {
  final int? competitionLevelCost;
  final int? roundsTotalCost;
  final int? groupsTotalCost;
  final int? totalEstimatedCost;

  EstimatedCost({this.competitionLevelCost, this.roundsTotalCost, this.groupsTotalCost, this.totalEstimatedCost});

  factory EstimatedCost.fromJson(Map<String, dynamic> json) => EstimatedCost(
        competitionLevelCost: json["competitionLevelCost"],
        roundsTotalCost: json["roundsTotalCost"],
        groupsTotalCost: json["groupsTotalCost"],
        totalEstimatedCost: json["totalEstimatedCost"],
      );
}

class PreviousEvent {
  final String? id;
  final String? recordName;
  final String? eventName;
  final DateTime? date;

  PreviousEvent({this.id, this.recordName, this.eventName, this.date});

  factory PreviousEvent.fromJson(Map<String, dynamic> json) => PreviousEvent(
        id: json["id"],
        recordName: json["recordName"],
        eventName: json["eventName"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
      );
}
