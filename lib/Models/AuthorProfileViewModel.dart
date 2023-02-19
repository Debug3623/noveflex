// To parse this JSON data, do
//
//     final authorProfileViewModel = authorProfileViewModelFromJson(jsonString);

import 'dart:convert';

AuthorProfileViewModel? authorProfileViewModelFromJson(String str) => AuthorProfileViewModel.fromJson(json.decode(str));

String authorProfileViewModelToJson(AuthorProfileViewModel? data) => json.encode(data!.toJson());

class AuthorProfileViewModel {
  AuthorProfileViewModel({
    this.status,
    this.data,
  });

  int? status;
  Data? data;

  factory AuthorProfileViewModel.fromJson(Map<String, dynamic> json) => AuthorProfileViewModel(
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
    this.description,
    this.profilePhoto,
    this.backgroundImage,
    this.type,
    this.followers,
    this.isSubscription,
    this.userType,
    this.imagePath,
    this.backgroundPath,
    this.book,
  });

  int? id;
  String? username;
  String? description;
  String? profilePhoto;
  String? backgroundImage;
  String? type;
  int? followers;
  bool? isSubscription;
  UserType? userType;
  String? imagePath;
  String? backgroundPath;
  List<Book?>? book;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    username: json["username"],
    description: json["description"],
    profilePhoto: json["profile_photo"],
    backgroundImage: json["background_image"],
    type: json["type"],
    followers: json["followers"],
    isSubscription: json["is_subscription"],
    userType: UserType.fromJson(json["user_type"]),
    imagePath: json["image_path"],
    backgroundPath: json["background_path"],
    book: json["book"] == null ? [] : List<Book?>.from(json["book"]!.map((x) => Book.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "description": description,
    "profile_photo": profilePhoto,
    "background_image": backgroundImage,
    "type": type,
    "followers": followers,
    "is_subscription": isSubscription,
    "user_type": userType!.toJson(),
    "image_path": imagePath,
    "background_path": backgroundPath,
    "book": book == null ? [] : List<dynamic>.from(book!.map((x) => x!.toJson())),
  };
}

class Book {
  Book({
    this.id,
    this.title,
    this.authorName,
    this.description,
    this.categoryId,
    this.subcategoryId,
    this.userId,
    this.lessonId,
    this.paymentStatus,
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
  });

  int? id;
  String? title;
  dynamic authorName;
  String? description;
  int? categoryId;
  int? subcategoryId;
  int? userId;
  dynamic lessonId;
  int? paymentStatus;
  String? image;
  dynamic status;
  int? isActive;
  int? isSeen;
  String? language;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic deletedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? imagePath;

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    id: json["id"],
    title: json["title"],
    authorName: json["author_name"],
    description: json["description"],
    categoryId: json["category_id"],
    subcategoryId: json["subcategory_id"],
    userId: json["user_id"],
    lessonId: json["lesson_id"],
    paymentStatus: json["payment_status"],
    image: json["image"],
    status: json["status"],
    isActive: json["is_active"],
    isSeen: json["is_seen"],
    language: json["language"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    deletedBy: json["deleted_by"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    imagePath: json["image_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "author_name": authorName,
    "description": description,
    "category_id": categoryId,
    "subcategory_id": subcategoryId,
    "user_id": userId,
    "lesson_id": lessonId,
    "payment_status": paymentStatus,
    "image": image,
    "status": status,
    "is_active": isActive,
    "is_seen": isSeen,
    "language": language,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "deleted_by": deletedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "image_path": imagePath,
  };
}

class UserType {
  UserType({
    this.type,
    this.imagePath,
    this.backgroundPath,
  });

  String? type;
  String? imagePath;
  String? backgroundPath;

  factory UserType.fromJson(Map<String, dynamic> json) => UserType(
    type: json["type"],
    imagePath: json["image_path"],
    backgroundPath: json["background_path"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "image_path": imagePath,
    "background_path": backgroundPath,
  };
}
