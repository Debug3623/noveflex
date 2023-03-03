// To parse this JSON data, do
//
//     final homeModelClass = homeModelClassFromJson(jsonString);

import 'dart:convert';

HomeModelClass homeModelClassFromJson(String str) => HomeModelClass.fromJson(json.decode(str));

String homeModelClassToJson(HomeModelClass data) => json.encode(data.toJson());

class HomeModelClass {
  HomeModelClass({
    required this.status,
    required this.data,
  });

  int status;
  List<Datum> data;

  factory HomeModelClass.fromJson(Map<String, dynamic> json) => HomeModelClass(
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
    required this.titleAr,
    required this.isActive,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    this.updatedBy,
    this.deletedBy,
    required this.books,
  });

  int id;
  String title;
  String titleAr;
  int isActive;
  String image;
  DateTime createdAt;
  String updatedAt;
  int createdBy;
  dynamic updatedBy;
  dynamic deletedBy;
  List<Book> books;

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
    books: List<Book>.from(json["books"].map((x) => Book.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "titleAr": titleAr,
    "is_active": isActive,
    "image": image,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "deleted_by": deletedBy,
    "books": List<dynamic>.from(books.map((x) => x.toJson())),
  };
}

class Book {
  Book({
    required this.id,
    required this.bookTitle,
    required this.description,
    required this.paymentStatus,
    required this.image,
    required this.authorName,
  });

  int id;
  String bookTitle;
  String description;
  int paymentStatus;
  String image;
  String authorName;

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    id: json["id"],
    bookTitle: json["bookTitle"],
    description: json["description"],
    paymentStatus: json["payment_status"],
    image: json["image"],
    authorName: json["author_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "bookTitle": bookTitle,
    "description": description,
    "payment_status": paymentStatus,
    "image": image,
    "author_name": authorName,
  };
}
