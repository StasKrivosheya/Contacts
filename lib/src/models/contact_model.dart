import 'dart:convert';

import 'package:contacts/src/models/i_entity.dart';
import 'package:equatable/equatable.dart';

class ContactFields {
  static const id = "_id";
  static const userId = "userId";
  static const name = "name";
  static const nickname = "nickname";
  static const description = "description";
  static const profileImagePath = "profileImagePath";
  static const createdDateTime = "createdDateTime";

  static const allFieldsNames = [
    id,
    userId,
    name,
    nickname,
    description,
    profileImagePath,
    createdDateTime
  ];

  static const databaseTableName = 'Contacts';
}

// https://app.quicktype.io/#l=dart
ContactModel contactModelFromJson(String str) => ContactModel.fromJson(json.decode(str));

String contactModelToJson(ContactModel data) => json.encode(data.toJson());

class ContactModel extends Equatable implements IEntityBase {
  const ContactModel(
      {this.id,
      required this.userId,
      required this.name,
      required this.nickname,
      required this.description,
      required this.profileImagePath,
      required this.createdDateTime});

  @override
  final int? id;
  final int userId;
  final String name;
  final String nickname;
  final String description;
  final String profileImagePath;
  final DateTime createdDateTime;

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
        id: json[ContactFields.id],
        userId: json[ContactFields.userId],
        name: json[ContactFields.name],
        nickname: json[ContactFields.nickname],
        description: json[ContactFields.description],
        profileImagePath: json[ContactFields.profileImagePath],
        createdDateTime: DateTime.parse(json[ContactFields.createdDateTime]),
      );

  Map<String, dynamic> toJson() => {
        ContactFields.id: id,
        ContactFields.userId: userId,
        ContactFields.name: name,
        ContactFields.nickname: nickname,
        ContactFields.description: description,
        ContactFields.profileImagePath: profileImagePath,
        ContactFields.createdDateTime: createdDateTime.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        nickname,
        description,
        profileImagePath,
        createdDateTime,
      ];
}
