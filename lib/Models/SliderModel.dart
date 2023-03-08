// To parse this JSON data, do
//
//     final sliderModel = sliderModelFromJson(jsonString);

import 'dart:convert';

SliderModel sliderModelFromJson(String str) => SliderModel.fromJson(json.decode(str));

String sliderModelToJson(SliderModel data) => json.encode(data.toJson());

class SliderModel {
  SliderModel({
    required this.status,
    required this.data,
  });

  int status;
  List<Datum> data;

  factory SliderModel.fromJson(Map<String, dynamic> json) => SliderModel(
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
    required this.paymentStatus,
    required this.userId,
    required this.lessonId,
    required this.image,
    required this.status,
    required this.isActive,
    required this.isSeen,
    required this.language,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    required this.createdAt,
    this.updatedAt,
    required this.imagePath,
    required this.categories,
  });

  int id;
  String title;
  String description;
  int categoryId;
  int subcategoryId;
  int paymentStatus;
  int userId;
  dynamic lessonId;
  String image;
  dynamic status;
  int isActive;
  int isSeen;
  String language;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic deletedBy;
  DateTime createdAt;
  dynamic updatedAt;
  String imagePath;
  List<Category> categories;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    categoryId: json["category_id"],
    subcategoryId: json["subcategory_id"],
    paymentStatus: json["payment_status"],
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
    updatedAt: json["updated_at"],
    imagePath: json["image_path"],
    categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "category_id": categoryId,
    "subcategory_id": subcategoryId,
    "payment_status": paymentStatus,
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
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt,
    "image_path": imagePath,
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
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
