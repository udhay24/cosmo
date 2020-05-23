import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pubg/util/validators.dart';

class TeamDetail extends Equatable {
  final String pubgName;
  final String phoneNumber;
  final String teamName;
  final List<String> teamMembers;

  const TeamDetail(
      {@required this.pubgName,
      @required this.phoneNumber,
      @required this.teamName,
      @required this.teamMembers});

  bool areFieldsValid({pubgName, phoneNumber, teamName, teamMembers}) {
    return ((Validators.isValidName(pubgName ?? this.pubgName)) &&
        (Validators.isValidPhoneNumber(phoneNumber ?? this.phoneNumber)) &&
        (Validators.isValidName(teamName ?? this.teamName)) &&
        (Validators.isMembersListValid(teamMembers ?? this.teamMembers)));
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
