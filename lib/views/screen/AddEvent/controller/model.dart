// ─── Models ─────────────────────────────────────────────────────────────────

class CategoryModel {
  final String id;
  final String name;
  CategoryModel({required this.id, required this.name});
  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      CategoryModel(id: json['id'], name: json['name']);
}

class SubCategoryModel {
  final String id;
  final String name;
  SubCategoryModel({required this.id, required this.name});
  factory SubCategoryModel.fromJson(Map<String, dynamic> json) =>
      SubCategoryModel(id: json['id'], name: json['name']);
}

class ProgramModel {
  final String id;
  final String name;
  ProgramModel({required this.id, required this.name});
  factory ProgramModel.fromJson(Map<String, dynamic> json) =>
      ProgramModel(id: json['id'], name: json['name']);
}
