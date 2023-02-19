// To parse this JSON data, do
//
//     final pdfUploadModel = pdfUploadModelFromJson(jsonString);

import 'dart:convert';

PdfUploadModel? pdfUploadModelFromJson(String str) => PdfUploadModel.fromJson(json.decode(str));

String pdfUploadModelToJson(PdfUploadModel? data) => json.encode(data!.toJson());

class PdfUploadModel {
  PdfUploadModel({
    this.status,
    this.success,
    this.data,
  });

  int? status;
  String? success;
  List<Datum?>? data;

  factory PdfUploadModel.fromJson(Map<String, dynamic> json) => PdfUploadModel(
    status: json["status"],
    success: json["success"],
    data: json["data"] == null ? [] : List<Datum?>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x!.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.bookId,
    this.lesson,
    this.imagePath,
  });

  int? id;
  int? bookId;
  String? lesson;
  String? imagePath;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    bookId: json["book_id"],
    lesson: json["lesson"],
    imagePath: json["image_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "book_id": bookId,
    "lesson": lesson,
    "image_path": imagePath,
  };
}
