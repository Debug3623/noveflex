// To parse this JSON data, do
//
//     final authorProfileEditModel = authorProfileEditModelFromJson(jsonString);

import 'dart:convert';

AuthorProfileEditModel? authorProfileEditModelFromJson(String str) => AuthorProfileEditModel.fromJson(json.decode(str));

String authorProfileEditModelToJson(AuthorProfileEditModel? data) => json.encode(data!.toJson());

class AuthorProfileEditModel {
  AuthorProfileEditModel({
    this.status,
    this.data,
  });

  int? status;
  List<Datum?>? data;

  factory AuthorProfileEditModel.fromJson(Map<String, dynamic> json) => AuthorProfileEditModel(
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
    this.username,
    this.email,
    this.phone,
    this.type,
    this.image,
    this.description,
    this.registerdDate,
    this.imagePath,
  });

  int? id;
  String? username;
  String? email;
  String? phone;
  String? type;
  dynamic image;
  dynamic description;
  DateTime? registerdDate;
  String? imagePath;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    username: json["username"],
    email: json["email"],
    phone: json["phone"],
    type: json["type"],
    image: json["image"],
    description: json["description"],
    registerdDate: DateTime.parse(json["registerd_date"]),
    imagePath: json["image_path"],
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
    "image_path": imagePath,
  };
}
