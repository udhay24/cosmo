import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserDetail {
  String userName;
  int phoneNumber;
  DocumentReference joinedTeam;
  String userUuid;

  UserDetail({@required this.userName, @required this.phoneNumber, this.joinedTeam, @required this.userUuid,});

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      userName: json['user_name'],
      phoneNumber: json['phone_number'],
      joinedTeam: json['team'],
      userUuid: json['user_id']
    );
  }

  Map<String, dynamic> toJson() => {
   'user_name': userName,
    'phone_number': phoneNumber,
    'team': joinedTeam,
    'user_id': userUuid
  };
}
