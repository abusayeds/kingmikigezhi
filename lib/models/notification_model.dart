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
    return NotificationModel(
      id: json['id'],
      recipientId: json['recipientId'],
      senderId: json['senderId'],
      type: json['type'],
      medium: json['medium'] != null ? List<dynamic>.from(json['medium']) : null,
      title: json['title'],
      message: json['message'],
      image: json['image'],
      linkId: json['linkId'],
      linkType: json['linkType'],
      isRead: json['isRead'],
      readAt: json['readAt'],
      data: json['data'],
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
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
    final data = json['data'] as Map<String, dynamic>?;
    final meta = json['meta'] as Map<String, dynamic>?;

    return NotificationResponse(
      items: data != null && data['items'] != null
          ? (data['items'] as List).map((e) => NotificationModel.fromJson(e)).toList()
          : [],
      unreadCount: data?['unreadCount'],
      page: meta?['page'],
      limit: meta?['limit'],
      total: meta?['total'],
      totalPages: meta?['totalPages'],
      hasNext: meta?['hasNext'],
      hasPrev: meta?['hasPrev'],
    );
  }
}
