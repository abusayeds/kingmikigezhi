class EventModel {
  final String? id;
  final String? eventName;
  final String? coverImage;
  final String? programId;
  final String? organizer;
  final String? location;
  final bool? isPublished;
  final bool? isActive;
  final bool? isVerified;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? sessionId;
  final Program? program;
  final Schedule? schedule;

  EventModel({
    this.id,
    this.eventName,
    this.coverImage,
    this.programId,
    this.organizer,
    this.location,
    this.isPublished,
    this.isActive,
    this.isVerified,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.sessionId,
    this.program,
    this.schedule,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        id: json["id"],
        eventName: json["eventName"],
        coverImage: json["coverImage"],
        programId: json["programId"],
        organizer: json["organizer"],
        location: json["location"],
        isPublished: json["isPublished"],
        isActive: json["isActive"],
        isVerified: json["isVerified"],
        isDeleted: json["isDeleted"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        sessionId: json["sessionId"],
        program:
            json["program"] == null ? null : Program.fromJson(json["program"]),
        schedule: json["schedule"] == null
            ? null
            : Schedule.fromJson(json["schedule"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "eventName": eventName,
        "coverImage": coverImage,
        "programId": programId,
        "organizer": organizer,
        "location": location,
        "isPublished": isPublished,
        "isActive": isActive,
        "isVerified": isVerified,
        "isDeleted": isDeleted,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "sessionId": sessionId,
        "program": program?.toJson(),
        "schedule": schedule?.toJson(),
      };
}

class Program {
  final String? id;
  final String? name;
  final dynamic imageUrl;

  Program({
    this.id,
    this.name,
    this.imageUrl,
  });

  factory Program.fromJson(Map<String, dynamic> json) => Program(
        id: json["id"],
        name: json["name"],
        imageUrl: json["imageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "imageUrl": imageUrl,
      };
}

class Schedule {
  final String? eventId;
  final String? id;
  final DateTime? registrationDate;
  final DateTime? deadline;
  final String? cost;
  final String? eventType;
  final String? competitionLevel;

  Schedule({
    this.eventId,
    this.id,
    this.registrationDate,
    this.deadline,
    this.cost,
    this.eventType,
    this.competitionLevel,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        eventId: json["eventId"],
        id: json["id"],
        registrationDate: json["registrationDate"] == null
            ? null
            : DateTime.parse(json["registrationDate"]),
        deadline: json["deadline"] == null
            ? null
            : DateTime.parse(json["deadline"]),
        cost: json["cost"],
        eventType: json["eventType"],
        competitionLevel: json["competitionLevel"],
      );

  Map<String, dynamic> toJson() => {
        "eventId": eventId,
        "id": id,
        "registrationDate": registrationDate?.toIso8601String(),
        "deadline": deadline?.toIso8601String(),
        "cost": cost,
        "eventType": eventType,
        "competitionLevel": competitionLevel,
      };
}
