import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pubg/data_source/model/user_detail.dart';
import 'package:pubg/user_detail/bloc/bloc.dart';

abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();
}

class ProfileScreenInitialized extends UserProfileEvent {
  @override
  List<Object> get props => [];
}

class CreateTeamPressed extends UserProfileEvent {
  final String teamName;
  final String teamID;
  final String teamCode;

  CreateTeamPressed({@required this.teamName, @required this.teamID, @required this.teamCode});

  @override
  List<Object> get props => [teamName, teamCode, teamID];
}

class JoinTeamPressed extends UserProfileEvent {
  final String teamCode;
  final String teamID;

  JoinTeamPressed({@required this.teamID, this.teamCode});

  @override
  List<Object> get props => [teamCode, teamID];
}

class UpdateProfile extends UserProfileEvent {
  final UserDetail userDetail;

  UpdateProfile({@required this.userDetail});

  @override
  List<Object> get props => [];
}

class SaveProfilePressed extends UserProfileEvent {
  @override
  List<Object> get props => [];
}
