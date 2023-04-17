import 'dart:convert';

class UserFields {
  static const id = "_id";
  static const login = "login";
  static const password = "password";

  static const allFieldsNames = [
    id, login, password,
  ];
}

// https://app.quicktype.io/#l=dart
User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.id,
    required this.login,
    required this.password,
  });

  int? id;
  String login;
  String password;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json[UserFields.id] as int?,
    login: json[UserFields.login] as String,
    password: json[UserFields.password] as String,
  );

  Map<String, dynamic> toJson() => {
    UserFields.id: id,
    UserFields.login: login,
    UserFields.password: password,
  };
}
