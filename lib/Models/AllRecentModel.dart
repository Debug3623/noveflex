// To parse this JSON data, do
//
//     final allRecentModel = allRecentModelFromJson(jsonString);

import 'dart:convert';

AllRecentModel allRecentModelFromJson(String str) => AllRecentModel.fromJson(json.decode(str));

String allRecentModelToJson(AllRecentModel data) => json.encode(data.toJson());

class AllRecentModel {
  AllRecentModel({
    required this.status,
    required this.data,
  });

  int status;
  List<Datum> data;

  factory AllRecentModel.fromJson(Map<String, dynamic> json) => AllRecentModel(
    status: json["status"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.subcategoryId,
    required this.userId,
    this.lessonId,
    required this.paymentStatus,
    required this.image,
    this.status,
    required this.isActive,
    required this.isSeen,
    required this.language,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.imagePath,
    required this.categories,
    required this.user,
  });

  int id;
  String title;
  String description;
  int categoryId;
  int subcategoryId;
  int userId;
  dynamic lessonId;
  int paymentStatus;
  String image;
  dynamic status;
  int isActive;
  int isSeen;
  String language;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic deletedBy;
  DateTime createdAt;
  DateTime updatedAt;
  String imagePath;
  List<Category> categories;
  List<User> user;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    categoryId: json["category_id"],
    subcategoryId: json["subcategory_id"],
    userId: json["user_id"],
    lessonId: json["lesson_id"],
    paymentStatus: json["payment_status"],
    image: json["image"],
    status: json["status"],
    isActive: json["is_active"],
    isSeen: json["is_seen"],
    language: json["language"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    deletedBy: json["deleted_by"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    imagePath: json["image_path"],
    categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
    user: List<User>.from(json["user"].map((x) => User.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "category_id": categoryId,
    "subcategory_id": subcategoryId,
    "user_id": userId,
    "lesson_id": lessonId,
    "payment_status": paymentStatus,
    "image": image,
    "status": status,
    "is_active": isActive,
    "is_seen": isSeen,
    "language": language,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "deleted_by": deletedBy,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "image_path": imagePath,
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
    "user": List<dynamic>.from(user.map((x) => x.toJson())),
  };
}

class Category {
  Category({
    required this.id,
    required this.title,
    required this.imagePath,
  });

  int id;
  String title;
  String imagePath;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    title: json["title"],
    imagePath: json["image_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image_path": imagePath,
  };
}

class User {
  User({
    required this.id,
    required this.username,
    required this.profilePath,
    required this.backgroundPath,
  });

  int id;
  String username;
  String profilePath;
  String backgroundPath;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    username: json["username"],
    profilePath: json["profile_path"],
    backgroundPath: json["background_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "profile_path": profilePath,
    "background_path": backgroundPath,
  };
}
