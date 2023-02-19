// To parse this JSON data, do
//
//     final readerProfileModel = readerProfileModelFromJson(jsonString);

import 'dart:convert';

ReaderProfileModel? readerProfileModelFromJson(String str) => ReaderProfileModel.fromJson(json.decode(str));

String readerProfileModelToJson(ReaderProfileModel? data) => json.encode(data!.toJson());

class ReaderProfileModel {
  ReaderProfileModel({
    this.status,
    this.data,
  });

  int? status;
  Data? data;

  factory ReaderProfileModel.fromJson(Map<String, dynamic> json) => ReaderProfileModel(
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.username,
    this.email,
    this.phone,
    this.type,
    this.image,
    this.description,
    this.registerdDate,
    this.following,
    this.books,
    this.imagePath,
    this.backgroundPath,
  });

  int? id;
  String? username;
  String? email;
  String? phone;
  String? type;
  dynamic image;
  dynamic description;
  DateTime? registerdDate;
  List<Following?>? following;
  List<Book?>? books;
  String? imagePath;
  String? backgroundPath;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    username: json["username"],
    email: json["email"],
    phone: json["phone"],
    type: json["type"],
    image: json["image"],
    description: json["description"],
    registerdDate: DateTime.parse(json["registerd_date"]),
    following: json["following"] == null ? [] : List<Following?>.from(json["following"]!.map((x) => Following.fromJson(x))),
    books: json["books"] == null ? [] : List<Book?>.from(json["books"]!.map((x) => Book.fromJson(x))),
    imagePath: json["image_path"],
    backgroundPath: json["background_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
    "phone": phone,
    "type": type,
    "image": image,
    "description": description,
    "registerd_date": registerdDate?.toIso8601String(),
    "following": following == null ? [] : List<dynamic>.from(following!.map((x) => x!.toJson())),
    "books": books == null ? [] : List<dynamic>.from(books!.map((x) => x!.toJson())),
    "image_path": imagePath,
    "background_path": backgroundPath,
  };
}

class Book {
  Book({
    this.id,
    this.title,
    this.image,
    this.imagePath,
    this.backgroundPath,
  });

  int? id;
  String? title;
  String? image;
  String? imagePath;
  String? backgroundPath;

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    id: json["id"],
    title: json["title"],
    image: json["image"],
    imagePath: json["image_path"],
    backgroundPath: json["background_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image": image,
    "image_path": imagePath,
    "background_path": backgroundPath,
  };
}

class Following {
  Following({
    this.id,
    this.username,
    this.profilePhoto,
    this.imagePath,
    this.backgroundPath,
  });

  int? id;
  String? username;
  String? profilePhoto;
  String? imagePath;
  String? backgroundPath;

  factory Following.fromJson(Map<String, dynamic> json) => Following(
    id: json["id"],
    username: json["username"],
    profilePhoto: json["profile_photo"],
    imagePath: json["image_path"],
    backgroundPath: json["background_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "profile_photo": profilePhoto,
    "image_path": imagePath,
    "background_path": backgroundPath,
  };
}
