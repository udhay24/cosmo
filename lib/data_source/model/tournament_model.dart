import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TournamentModel {
  Timestamp registrationStartDate;
  Timestamp registrationClosedDate;
  String tournamentName;
  String tournamentDescription;
  int tournamentID;
  TournamentType tournamentType;

  TournamentModel({
    @required this.registrationClosedDate,
    @required this.registrationStartDate,
    @required this.tournamentDescription,
    @required this.tournamentID,
    @required this.tournamentName,
    @required this.tournamentType,
  });

  TournamentModel.fromJson(Map<String, dynamic> json) {
    TournamentType type;
    if (json['tournament_type'] == 0) {
      type = TournamentType.PUBLICITY_TOURNAMENT;
    } else {
      throw Exception("Unknown tournament");
    }
    TournamentModel(
        registrationClosedDate: json['registration_close_date'],
        registrationStartDate: json['registration_open_date'],
        tournamentDescription: json['tournament_description'],
        tournamentID: json['tournament_id'],
        tournamentName: json['tournament_name'],
        tournamentType: type);
  }
}

class TournamentRegistrationModel {
  List<DocumentReference> registeredMembers;
  List<DocumentReference> registeredTeams;

  TournamentRegistrationModel(
      {@required this.registeredTeams, @required this.registeredMembers});

  TournamentRegistrationModel.fromJson(Map<String, dynamic> json) {
    TournamentRegistrationModel(
      registeredTeams: json['registered_teams'],
      registeredMembers: json['registered_members'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'registered_teams': registeredTeams,
      'registered_members': registeredMembers
    };
  }
}

enum TournamentType { PUBLICITY_TOURNAMENT }
