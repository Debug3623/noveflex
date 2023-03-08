// To parse this JSON data, do
//
//     final authorProfileViewModel = authorProfileViewModelFromJson(jsonString);

import 'dart:convert';

AuthorProfileViewModel authorProfileViewModelFromJson(String str) => AuthorProfileViewModel.fromJson(json.decode(str));

String authorProfileViewModelToJson(AuthorProfileViewModel data) => json.encode(data.toJson());

class AuthorProfileViewModel {
  AuthorProfileViewModel({
    required this.status,
    required this.data,
  });

  int status;
  Data data;

  factory AuthorProfileViewModel.fromJson(Map<String, dynamic> json) => AuthorProfileViewModel(
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required this.id,
    required this.username,
    required this.description,
    required this.profilePhoto,
    this.backgroundImage,
    required this.type,
    required this.followers,
    required this.isSubscription,
    required this.userType,
    required this.profilePath,
    required this.backgroundPath,
    required this.book,
  });

  int id;
  String username;
  String description;
  dynamic profilePhoto;
  dynamic backgroundImage;
  String type;
  int followers;
  bool isSubscription;
  UserType userType;
  String profilePath;
  String backgroundPath;
  List<Book> book;

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
    profilePath: json["profile_path"],
    backgroundPath: json["background_path"],
    book: List<Book>.from(json["book"].map((x) => Book.fromJson(x))),
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
    "user_type": userType.toJson(),
    "profile_path": profilePath,
    "background_path": backgroundPath,
    "book": List<dynamic>.from(book.map((x) => x.toJson())),
  };
}

class Book {
  Book({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.subcategoryId,
    required this.paymentStatus,
    required this.userId,
    required this.lessonId,
    required this.image,
    required this.status,
    required this.isActive,
    required this.isSeen,
    required this.language,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    required this.createdAt,
    this.updatedAt,
    required this.imagePath,
  });

  int id;
  String title;
  String description;
  int categoryId;
  int subcategoryId;
  int paymentStatus;
  int userId;
  dynamic lessonId;
  String image;
  dynamic status;
  int isActive;
  int isSeen;
  String language;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic deletedBy;
  DateTime createdAt;
  dynamic updatedAt;
  String imagePath;

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    categoryId: json["category_id"],
    subcategoryId: json["subcategory_id"],
    paymentStatus: json["payment_status"],
    userId: json["user_id"],
    lessonId: json["lesson_id"],
    image: json["image"],
    status: json["status"],
    isActive: json["is_active"],
    isSeen: json["is_seen"],
    language: json["language"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    deletedBy: json["deleted_by"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
    imagePath: json["image_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "category_id": categoryId,
    "subcategory_id": subcategoryId,
    "payment_status": paymentStatus,
    "user_id": userId,
    "lesson_id": lessonId,
    "image": image,
    "status": status,
    "is_active": isActive,
    "is_seen": isSeen,
    "language": language,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "deleted_by": deletedBy,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt,
    "image_path": imagePath,
  };
}

class UserType {
  UserType({
    required this.type,
    required this.profilePath,
    required this.backgroundPath,
  });

  String type;
  String profilePath;
  String backgroundPath;

  factory UserType.fromJson(Map<String, dynamic> json) => UserType(
    type: json["type"],
    profilePath: json["profile_path"],
    backgroundPath: json["background_path"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "profile_path": profilePath,
    "background_path": backgroundPath,
  };
}
