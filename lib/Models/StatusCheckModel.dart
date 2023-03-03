// To parse this JSON data, do
//
//     final statusCheckModel = statusCheckModelFromJson(jsonString);

import 'dart:convert';

StatusCheckModel statusCheckModelFromJson(String str) => StatusCheckModel.fromJson(json.decode(str));

String statusCheckModelToJson(StatusCheckModel data) => json.encode(data.toJson());

class StatusCheckModel {
  StatusCheckModel({
    required this.status,
    required this.data,
  });

  int status;
  List<Datum> data;

  factory StatusCheckModel.fromJson(Map<String, dynamic> json) => StatusCheckModel(
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
    required this.type,
    required this.profilePath,
    required this.backgroundPath,
  });

  int id;
  String type;
  String profilePath;
  String backgroundPath;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    type: json["type"],
    profilePath: json["profile_path"],
    backgroundPath: json["background_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "profile_path": profilePath,
    "background_path": backgroundPath,
  };
}
