import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  String userName;
  String pubgID;
  int phoneNumber;
  DocumentReference joinedTeam;
  String userUuid;

  User(
      {@required this.userName,
      @required this.phoneNumber,
      this.joinedTeam,
      @required this.userUuid,
      @required this.pubgID});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        userName: json['user_name'],
        pubgID: json['pubg_id'],
        phoneNumber: json['phone_number'],
        joinedTeam: json['team'],
        userUuid: json['user_id']);
  }

  Map<String, dynamic> toJson() =>
      {
        'user_name': userName,
        'phone_number': phoneNumber,
        'team': joinedTeam,
        'pubg_id': pubgID,
        'user_id': userUuid
      };
}
