import 'package:cloud_firestore/cloud_firestore.dart';

class Team {
  String teamName;
  String teamCode;
  List<DocumentReference> teamMembers;
  String teamId;
  DocumentReference teamOwner;

  Team(
      {this.teamName,
      this.teamCode,
      this.teamMembers,
      this.teamId,
      this.teamOwner});

  Team.fromJson(Map<String, dynamic> json) {
    teamName = json['team_name'];
    teamCode = json['team_code'];
    teamMembers =
        json['team_members'].cast<DocumentReference>().toList() ?? List();
    teamId = json['team_id'];
    teamOwner = json['team_manager'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['team_name'] = this.teamName;
    data['team_code'] = this.teamCode;
    data['team_members'] = this.teamMembers;
    data['team_id'] = this.teamId;
    data['team_manager'] = this.teamOwner;
    return data;
  }
}
