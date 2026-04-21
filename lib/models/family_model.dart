class FamilyModel {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final String createdBy;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CreatorInfo? creator;

  FamilyModel({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.createdBy,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    this.creator,
  });

  factory FamilyModel.fromJson(Map<String, dynamic> json) {
    return FamilyModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      imageUrl: json['imageUrl'],
      createdBy: json['createdBy'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      creator: json['creator'] != null
          ? CreatorInfo.fromJson(json['creator'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'createdBy': createdBy,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class CreatorInfo {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? profilePicture;

  CreatorInfo({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.profilePicture,
  });

  factory CreatorInfo.fromJson(Map<String, dynamic> json) {
    return CreatorInfo(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      profilePicture: json['profilePicture'],
    );
  }
}

class FamilyPaginationResponse {
  final List<FamilyModel> families;
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;

  FamilyPaginationResponse({
    required this.families,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrev,
  });

  factory FamilyPaginationResponse.fromJson(Map<String, dynamic> json) {
    List<FamilyModel> familiesList = [];
    if (json['data'] != null) {
      familiesList = (json['data'] as List)
          .map((family) => FamilyModel.fromJson(family))
          .toList();
    }

    return FamilyPaginationResponse(
      families: familiesList,
      page: json['meta']?['page'] ?? 1,
      limit: json['meta']?['limit'] ?? 10,
      total: json['meta']?['total'] ?? 0,
      totalPages: json['meta']?['totalPages'] ?? 1,
      hasNext: json['meta']?['hasNext'] ?? false,
      hasPrev: json['meta']?['hasPrev'] ?? false,
    );
  }
}

class FamilyMemberModel {
  final String id;
  final String familyId;
  final String userId;
  final String role;
  final String? relationShip;
  final DateTime createdAt;
  final DateTime updatedAt;
  final FamilyMemberUser? user;

  FamilyMemberModel({
    required this.id,
    required this.familyId,
    required this.userId,
    required this.role,
    this.relationShip,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });

  factory FamilyMemberModel.fromJson(Map<String, dynamic> json) {
    return FamilyMemberModel(
      id: json['id'] ?? '',
      familyId: json['familyId'] ?? '',
      userId: json['userId'] ?? '',
      role: json['role'] ?? '',
      relationShip: json['relationShip'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      user:
          json['user'] != null ? FamilyMemberUser.fromJson(json['user']) : null,
    );
  }
}

class FamilyMemberUser {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? profilePicture;

  FamilyMemberUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.profilePicture,
  });

  factory FamilyMemberUser.fromJson(Map<String, dynamic> json) {
    return FamilyMemberUser(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      profilePicture: json['profilePicture'],
    );
  }
}
