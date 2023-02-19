// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel? userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel? data) => json.encode(data!.toJson());

class UserModel {
  UserModel({
    this.status,
    this.user,
  });

  int? status;
  User? user;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    status: json["status"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "user": user!.toJson(),
  };
}

class User {
  User({
    this.id,
    this.username,
    this.email,
    this.accessToken,
    this.expiredDays,
    this.googleLogin,
  });

  int? id;
  String? username;
  String? email;
  String? accessToken;
  int? expiredDays;
  bool? googleLogin;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    username: json["username"],
    email: json["email"],
    accessToken: json["access_token"],
    expiredDays: json["expired_days"],
    googleLogin: json["google_login"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
    "access_token": accessToken,
    "expired_days": expiredDays,
    "google_login": googleLogin,
  };
}
