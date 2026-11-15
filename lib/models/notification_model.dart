class NotificationModel {
  final String? id;
  final String? recipientId;
  final String? senderId;
  final String? type;
  final List<dynamic>? medium;
  final String? title;
  final String? message;
  final String? image;
  final String? linkId;
  final String? linkType;
  bool? isRead;
  final String? readAt;
  final dynamic data;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  NotificationModel({
    this.id,
    this.recipientId,
    this.senderId,
    this.type,
    this.medium,
    this.title,
    this.message,
    this.image,
    this.linkId,
    this.linkType,
    this.isRead,
    this.readAt,
    this.data,
    this.createdAt,
    this.updatedAt,
  });

  NotificationModel copyWith({
    String? id,
    String? recipientId,
    String? senderId,
    String? type,
    List<dynamic>? medium,
    String? title,
    String? message,
    String? image,
    String? linkId,
    String? linkType,
    bool? isRead,
    String? readAt,
    dynamic data,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      recipientId: recipientId ?? this.recipientId,
      senderId: senderId ?? this.senderId,
      type: type ?? this.type,
      medium: medium ?? this.medium,
      title: title ?? this.title,
      message: message ?? this.message,
      image: image ?? this.image,
      linkId: linkId ?? this.linkId,
      linkType: linkType ?? this.linkType,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    List<dynamic>? medium;
    final rawMedium = json['medium'];
    if (rawMedium is List) {
      medium = List<dynamic>.from(rawMedium);
    } else if (rawMedium != null) {
      medium = [rawMedium];
    }

    bool? isRead;
    final rawIsRead = json['isRead'];
    if (rawIsRead is bool) {
      isRead = rawIsRead;
    } else if (rawIsRead is num) {
      isRead = rawIsRead != 0;
    } else if (rawIsRead is String) {
      isRead = rawIsRead.toLowerCase() == 'true' || rawIsRead == '1';
    }

    return NotificationModel(
      id: json['id']?.toString(),
      recipientId: json['recipientId']?.toString(),
      senderId: json['senderId']?.toString(),
      type: json['type']?.toString(),
      medium: medium,
      title: json['title']?.toString(),
      message: json['message']?.toString(),
      image: json['image']?.toString(),
      linkId: json['linkId']?.toString(),
      linkType: json['linkType']?.toString(),
      isRead: isRead,
      readAt: json['readAt']?.toString(),
      data: json['data'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }
}

class NotificationResponse {
  final List<NotificationModel> items;
  final int? unreadCount;
  final int? page;
  final int? limit;
  final int? total;
  final int? totalPages;
  final bool? hasNext;
  final bool? hasPrev;

  NotificationResponse({
    required this.items,
    this.unreadCount,
    this.page,
    this.limit,
    this.total,
    this.totalPages,
    this.hasNext,
    this.hasPrev,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final meta = json['meta'] is Map
        ? Map<String, dynamic>.from(json['meta'] as Map)
        : null;

    List<NotificationModel> items = [];
    int? unreadCount;

    if (rawData is List) {
      items = rawData
          .whereType<Map>()
          .map((e) => NotificationModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } else if (rawData is Map) {
      final data = Map<String, dynamic>.from(rawData);
      unreadCount = data['unreadCount'] is int ? data['unreadCount'] as int : null;
      final rawItems = data['items'] ?? data['notifications'] ?? data['data'];
      if (rawItems is List) {
        items = rawItems
            .whereType<Map>()
            .map((e) => NotificationModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    }

    return NotificationResponse(
      items: items,
      unreadCount: unreadCount,
      page: meta?['page'],
      limit: meta?['limit'],
      total: meta?['total'],
      totalPages: meta?['totalPages'],
      hasNext: meta?['hasNext'],
      hasPrev: meta?['hasPrev'],
    );
  }
}
