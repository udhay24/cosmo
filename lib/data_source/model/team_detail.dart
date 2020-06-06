import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pubg/util/validators.dart';

class TeamDetailModel extends Equatable {
  final String pubgName;
  final String phoneNumber;
  final String teamName;
  final List<String> teamMembers;

  const TeamDetailModel(
      {@required this.pubgName,
      @required this.phoneNumber,
      @required this.teamName,
      @required this.teamMembers});

  bool areFieldsValid({pubgName, phoneNumber, teamName, teamMembers}) {
    var validPubgName = Validators.isValidName(pubgName ?? this.pubgName);
    var validPhoneNumber =
        Validators.isValidPhoneNumber(phoneNumber ?? this.phoneNumber);
    var validTeamName = Validators.isValidName(teamName ?? this.teamName);
    var validMembers =
        Validators.isMembersListValid(teamMembers ?? this.teamMembers);
    print('''
      {
      Pubg name is valid: $validPubgName,
      phone number is valid:$validPhoneNumber,
      team name is valid: $validTeamName,
      team members are valid: $validMembers
      ''');
    return (validPubgName) &&
        (validTeamName) &&
        (validMembers) &&
        (validPhoneNumber);
  }

  @override
  List<Object> get props => [
        pubgName,
        phoneNumber,
        teamName,
        teamMembers,
      ];

  @override
  String toString() {
    return '''
    {
    pubg_name: $pubgName,
    'phone_number: $phoneNumber,
    team_name: $teamName,
    team_members: ${teamMembers.join(",")}
  }''';
  }
}

class Team {
  String teamName;
  String teamCode;
  List<DocumentReference> teamMembers;
  String teamId;

  Team({this.teamName, this.teamCode, this.teamMembers, this.teamId});

  Team.fromJson(Map<String, dynamic> json) {
    teamName = json['team_name'];
    teamCode = json['team_code'];
    teamMembers = json['team_members'].cast<String>();
    teamId = json['team_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['team_name'] = this.teamName;
    data['team_code'] = this.teamCode;
    data['team_members'] = this.teamMembers;
    data['team_id'] = this.teamId;
    return data;
  }
}
