// To parse this JSON data, do
//
//     final bookDetailsModel = bookDetailsModelFromJson(jsonString);

import 'dart:convert';

BookDetailsModel? bookDetailsModelFromJson(String str) => BookDetailsModel.fromJson(json.decode(str));

String bookDetailsModelToJson(BookDetailsModel? data) => json.encode(data!.toJson());

class BookDetailsModel {
  BookDetailsModel({
    this.status,
    this.data,
  });

  int? status;
  Data? data;

  factory BookDetailsModel.fromJson(Map<String, dynamic> json) => BookDetailsModel(
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
    this.bookId,
    this.bookTitle,
    this.image,
    this.bookDescription,
    this.userId,
    this.authorName,
    this.userimage,
    this.categoryId,
    this.catgoryTitle,
    this.paymentStatus,
    this.publication,
    this.subscription,
    this.bookView,
    this.bookLike,
    this.bookDisLike,
    this.status,
    this.bookSaved,
    this.bookSubscription,
    this.imagePath,
  });

  int? bookId;
  String? bookTitle;
  String? image;
  String? bookDescription;
  int? userId;
  String? authorName;
  dynamic userimage;
  int? categoryId;
  String? catgoryTitle;
  int? paymentStatus;
  int? publication;
  int? subscription;
  int? bookView;
  int? bookLike;
  int? bookDisLike;
  Status? status;
  bool? bookSaved;
  bool? bookSubscription;
  String? imagePath;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    bookId: json["bookId"],
    bookTitle: json["bookTitle"],
    image: json["image"],
    bookDescription: json["bookDescription"],
    userId: json["user_id"],
    authorName: json["author_name"],
    userimage: json["userimage"],
    categoryId: json["category_id"],
    catgoryTitle: json["catgoryTitle"],
    paymentStatus: json["payment_status"],
    publication: json["publication"],
    subscription: json["subscription"],
    bookView: json["BookView"],
    bookLike: json["BookLike"],
    bookDisLike: json["BookDisLike"],
    status: Status.fromJson(json["status"]),
    bookSaved: json["book_saved"],
    bookSubscription: json["book_subscription"],
    imagePath: json["image_path"],
  );

  Map<String, dynamic> toJson() => {
    "bookId": bookId,
    "bookTitle": bookTitle,
    "image": image,
    "bookDescription": bookDescription,
    "user_id": userId,
    "author_name": authorName,
    "userimage": userimage,
    "category_id": categoryId,
    "catgoryTitle": catgoryTitle,
    "payment_status": paymentStatus,
    "publication": publication,
    "subscription": subscription,
    "BookView": bookView,
    "BookLike": bookLike,
    "BookDisLike": bookDisLike,
    "status": status!.toJson(),
    "book_saved": bookSaved,
    "book_subscription": bookSubscription,
    "image_path": imagePath,
  };
}

class Status {
  Status({
    this.status,
  });

  int? status;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
  };
}
