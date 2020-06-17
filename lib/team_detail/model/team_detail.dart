import 'package:flutter/cupertino.dart';
import 'package:pubg/data_source/model/user_model.dart';

class TeamDetail {
  final String teamName;
  final String teamCode;
  final List<User> teamMembers;
  final String teamId;

  TeamDetail(
      {@required this.teamId,
      @required this.teamName,
      @required this.teamCode,
      @required this.teamMembers});
}
