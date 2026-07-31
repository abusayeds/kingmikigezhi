class HomeEventModel {
  final String? id;
  final String? title;
  final String? location;
  final String? member;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final String? repeatFunction;
  final String? url;
  final String? note;
  final String? createdById;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  HomeEventModel({
    this.id,
    this.title,
    this.location,
    this.member,
    this.startsAt,
    this.endsAt,
    this.repeatFunction,
    this.url,
    this.note,
    this.createdById,
    this.createdAt,
    this.updatedAt,
  });

  factory HomeEventModel.fromJson(Map<String, dynamic> json) => HomeEventModel(
    id: json["id"],
    title: json["title"],
    location: json["location"],
    member: json["member"],
    startsAt: _parseDateTime(json["startsAt"]),
    endsAt: _parseDateTime(json["endsAt"]),
    repeatFunction: json["repeatFunction"],
    url: json["url"],
    note: json["note"],
    createdById: json["createdById"],
    createdAt: _parseDateTime(json["createdAt"]),
    updatedAt: _parseDateTime(json["updatedAt"]),
  );

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}
