class UserModel {
  final String? id;
  final String? username;
  final String? email;
  final bool? isEmailVerified;
  final bool? isPhoneVerified;
  final String? role;
  final bool? twoFactorEnabled;
  final bool? isActive;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? birthday;
  final dynamic location;
  final String? phone;
  final String? image;
  final String? bio;
  final String? createdAt;
  final String? updatedAt;
  final bool? isFamilyOwner;
  final int? maxFamilyMembers;

  UserModel({
    this.id,
    this.username,
    this.email,
    this.isEmailVerified,
    this.isPhoneVerified,
    this.role,
    this.twoFactorEnabled,
    this.isActive,
    this.firstName,
    this.lastName,
    this.gender,
    this.birthday,
    this.location,
    this.phone,
    this.image,
    this.bio,
    this.createdAt,
    this.updatedAt,
    this.isFamilyOwner,
    this.maxFamilyMembers,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      isEmailVerified: json['isEmailVerified'],
      isPhoneVerified: json['isPhoneVerified'],
      role: json['role'],
      twoFactorEnabled: json['twoFactorEnabled'],
      isActive: json['isActive'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      gender: json['gender'],
      birthday: json['birthday'],
      location: json['location'],
      phone: json['phone'],
      image: json['image'],
      bio: json['bio'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      isFamilyOwner: json['isFamilyOwner'],
      maxFamilyMembers: json['maxFamilyMembers'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'role': role,
      'twoFactorEnabled': twoFactorEnabled,
      'isActive': isActive,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'birthday': birthday,
      'location': location,
      'phone': phone,
      'image': image,
      'bio': bio,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isFamilyOwner': isFamilyOwner,
      'maxFamilyMembers': maxFamilyMembers,
    };
  }
}
