class EventModel {
  final String? id;
  final String? eventName;
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
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? sessionId;
  final List<dynamic>? results;
  final int? applicationCount;
  final Program? program;
  final RepeatConfig? repeatConfig;
  final Creator? creator;
  final Schedule? schedule;
  final List<EventApplied>? eventApplieds;

  EventModel({
    this.id,
    this.eventName,
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
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.sessionId,
    this.results,
    this.applicationCount,
    this.program,
    this.repeatConfig,
    this.creator,
    this.schedule,
    this.eventApplieds,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        id: json["id"],
        eventName: json["eventName"],
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
        isDeleted: json["isDeleted"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        sessionId: json["sessionId"],
        results: json["results"] == null ? null : List<dynamic>.from(json["results"].map((x) => x)),
        applicationCount: json["_count"] == null ? null : json["_count"]["applications"],
        program: json["program"] == null ? null : Program.fromJson(json["program"]),
        repeatConfig: json["repeatConfig"] == null ? null : RepeatConfig.fromJson(json["repeatConfig"]),
        creator: json["creator"] == null ? null : Creator.fromJson(json["creator"]),
        schedule: json["schedule"] == null ? null : Schedule.fromJson(json["schedule"]),
        eventApplieds: json["eventApplieds"] == null ? null : List<EventApplied>.from(json["eventApplieds"].map((x) => EventApplied.fromJson(x))),
      );
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
  final List<Group>? groups;
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
    this.groups,
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
        groups: json["groups"] == null ? null : List<Group>.from(json["groups"].map((x) => Group.fromJson(x))),
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
