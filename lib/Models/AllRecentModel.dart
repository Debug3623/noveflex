// To parse this JSON data, do
//
//     final allRecentModel = allRecentModelFromJson(jsonString);

import 'dart:convert';

AllRecentModel? allRecentModelFromJson(String str) => AllRecentModel.fromJson(json.decode(str));

String allRecentModelToJson(AllRecentModel? data) => json.encode(data!.toJson());

class AllRecentModel {
  AllRecentModel({
    this.status,
    this.data,
  });

  int? status;
  List<Datum?>? data;

  factory AllRecentModel.fromJson(Map<String, dynamic> json) => AllRecentModel(
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
    this.categories,
  });

  int? id;
  String? title;
  dynamic authorName;
  String? description;
  int? categoryId;
  int? userId;
  dynamic lessonId;
  String? image;
  Status? status;
  int? isActive;
  int? isSeen;
  Language? language;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic deletedBy;
  DateTime? createdAt;
  dynamic updatedAt;
  String? imagePath;
  List<Category?>? categories;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    authorName: json["author_name"],
    description: json["description"],
    categoryId: json["category_id"],
    userId: json["user_id"],
    lessonId: json["lesson_id"],
    image: json["image"],
    status: statusValues!.map[json["status"]],
    isActive: json["is_active"],
    isSeen: json["is_seen"],
    language: languageValues!.map[json["language"]],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    deletedBy: json["deleted_by"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
    imagePath: json["image_path"],
    categories: json["categories"] == null ? [] : List<Category?>.from(json["categories"]!.map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "author_name": authorName,
    "description": description,
    "category_id": categoryId,
    "user_id": userId,
    "lesson_id": lessonId,
    "image": image,
    "status": statusValues.reverse![status],
    "is_active": isActive,
    "is_seen": isSeen,
    "language": languageValues.reverse![language],
    "created_by": createdBy,
    "updated_by": updatedBy,
    "deleted_by": deletedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt,
    "image_path": imagePath,
    "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x!.toJson())),
  };
}

class Category {
  Category({
    this.id,
    this.title,
  });

  int? id;
  Title? title;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    title: titleValues.map[json["title"]],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": titleValues.reverse![title],
  };
}

enum Title { ACTION, ROMANCE, THRILLER, HORROR, COMEDY }

final titleValues = EnumValues({
  "Action": Title.ACTION,
  "Comedy": Title.COMEDY,
  "Horror ": Title.HORROR,
  "Romance": Title.ROMANCE,
  "Thriller": Title.THRILLER
});

enum Language { ARB, ENG }

final languageValues = EnumValues({
  "arb": Language.ARB,
  "eng": Language.ENG
});

enum Status { IN_PROGRESS, DONE }

final statusValues = EnumValues({
  "Done": Status.DONE,
  "InProgress": Status.IN_PROGRESS
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    reverseMap ??= map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
