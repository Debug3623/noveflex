// To parse this JSON data, do
//
//     final homeModelClass = homeModelClassFromJson(jsonString);

import 'dart:convert';

HomeModelClass? homeModelClassFromJson(String str) => HomeModelClass.fromJson(json.decode(str));

String homeModelClassToJson(HomeModelClass? data) => json.encode(data!.toJson());

class HomeModelClass {
  HomeModelClass({
    this.status,
    this.data,
  });

  int? status;
  List<Datum?>? data;

  factory HomeModelClass.fromJson(Map<String, dynamic> json) => HomeModelClass(
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
    this.titleAr,
    this.isActive,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.books,
  });

  int? id;
  String? title;
  String? titleAr;
  int? isActive;
  String? image;
  DateTime? createdAt;
  String? updatedAt;
  int? createdBy;
  dynamic updatedBy;
  dynamic deletedBy;
  List<Book?>? books;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    titleAr: json["titleAr"],
    isActive: json["is_active"],
    image: json["image"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    deletedBy: json["deleted_by"],
    books: json["books"] == null ? [] : List<Book?>.from(json["books"]!.map((x) => Book.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "titleAr": titleAr,
    "is_active": isActive,
    "image": image,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "deleted_by": deletedBy,
    "books": books == null ? [] : List<dynamic>.from(books!.map((x) => x!.toJson())),
  };
}

class Book {
  Book({
    this.id,
    this.bookTitle,
    this.description,
    this.image,
    this.authorName,
  });

  int? id;
  String? bookTitle;
  String? description;
  String? image;
  String? authorName;

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    id: json["id"],
    bookTitle: json["bookTitle"],
    description: json["description"],
    image: json["image"],
    authorName: json["author_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "bookTitle": bookTitle,
    "description": description,
    "image": image,
    "author_name": authorName,
  };
}
