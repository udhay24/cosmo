import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
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
