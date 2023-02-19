// To parse this JSON data, do
//
//     final statusCheckModel = statusCheckModelFromJson(jsonString);

import 'dart:convert';

StatusCheckModel? statusCheckModelFromJson(String str) => StatusCheckModel.fromJson(json.decode(str));

String statusCheckModelToJson(StatusCheckModel? data) => json.encode(data!.toJson());

class StatusCheckModel {
  StatusCheckModel({
    this.status,
    this.data,
  });

  int? status;
  List<Datum?>? data;

  factory StatusCheckModel.fromJson(Map<String, dynamic> json) => StatusCheckModel(
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
    this.type,
    this.imagePath,
    this.backgroundPath,
  });

  int? id;
  String? type;
  String? imagePath;
  String? backgroundPath;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    type: json["type"],
    imagePath: json["image_path"],
    backgroundPath: json["background_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "image_path": imagePath,
    "background_path": backgroundPath,
  };
}
