// To parse this JSON data, do
//
//     final uploadBooksModel = uploadBooksModelFromJson(jsonString);

import 'dart:convert';

UploadBooksModel? uploadBooksModelFromJson(String str) => UploadBooksModel.fromJson(json.decode(str));

String uploadBooksModelToJson(UploadBooksModel? data) => json.encode(data!.toJson());

class UploadBooksModel {
  UploadBooksModel({
    this.status,
    this.data,
  });

  int? status;
  List<Datum?>? data;

  factory UploadBooksModel.fromJson(Map<String, dynamic> json) => UploadBooksModel(
    status: json["status"],
    data: json["data"] == null ? [] : List<Datum?>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x!.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.title,
    this.authorName,
    this.description,
    this.categoryId,
    this.subcategoryId,
    this.userId,
    this.lessonId,
    this.image,
    this.status,
    this.isActive,
    this.isSeen,
    this.language,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.createdAt,
    this.updatedAt,
    this.imagePath,
    this.user,
  });

  int? id;
  String? title;
  dynamic authorName;
  String? description;
  int? categoryId;
  int? subcategoryId;
  int? userId;
  dynamic lessonId;
  String? image;
  dynamic status;
  int? isActive;
  int? isSeen;
  String? language;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic deletedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? imagePath;
  List<User?>? user;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    authorName: json["author_name"],
    description: json["description"],
    categoryId: json["category_id"],
    subcategoryId: json["subcategory_id"],
    userId: json["user_id"],
    lessonId: json["lesson_id"],
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
    user: json["user"] == null ? [] : List<User?>.from(json["user"]!.map((x) => User.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "author_name": authorName,
    "description": description,
    "category_id": categoryId,
    "subcategory_id": subcategoryId,
    "user_id": userId,
    "lesson_id": lessonId,
    "image": image,
    "status": status,
    "is_active": isActive,
    "is_seen": isSeen,
    "language": language,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "deleted_by": deletedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "image_path": imagePath,
    "user": user == null ? [] : List<dynamic>.from(user!.map((x) => x!.toJson())),
  };
}

class User {
  User({
    this.id,
    this.username,
    this.imagePath,
    this.backgroundPath,
  });

  int? id;
  String? username;
  String? imagePath;
  String? backgroundPath;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    username: json["username"],
    imagePath: json["image_path"],
    backgroundPath: json["background_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "image_path": imagePath,
    "background_path": backgroundPath,
  };
}
