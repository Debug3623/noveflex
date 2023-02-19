// To parse this JSON data, do
//
//     final likesBooksModel = likesBooksModelFromJson(jsonString);

import 'dart:convert';

LikesBooksModel? likesBooksModelFromJson(String str) => LikesBooksModel.fromJson(json.decode(str));

String likesBooksModelToJson(LikesBooksModel? data) => json.encode(data!.toJson());

class LikesBooksModel {
  LikesBooksModel({
    this.status,
    this.data,
  });

  int? status;
  List<Datum?>? data;

  factory LikesBooksModel.fromJson(Map<String, dynamic> json) => LikesBooksModel(
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
    this.image,
    this.username,
    this.imagePath,
  });

  int? id;
  String? title;
  String? image;
  String? username;
  String? imagePath;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    image: json["image"],
    username: json["username"],
    imagePath: json["image_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image": image,
    "username": username,
    "image_path": imagePath,
  };
}
