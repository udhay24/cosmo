import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pubg/data_source/model/user_detail.dart';

abstract class UserProfileState extends Equatable {
  const UserProfileState();
}

class InitialUserProfileState extends UserProfileState {
  @override
  List<Object> get props => [];
}

class UserProfileLoadedState extends UserProfileState {
  final UserDetail userDetail;

  UserProfileLoadedState({@required this.userDetail});

  @override
  List<Object> get props => [userDetail];
}

class UserProfileFailed extends UserProfileState {
  @override
  List<Object> get props => [];
}


class UserProfileLoading extends UserProfileState {
  @override
  List<Object> get props => [];
}

class UserProfileUpdateSuccess extends UserProfileState {
  @override
  List<Object> get props => [];
}

class UserProfileUpdating extends UserProfileState {
  @override
  List<Object> get props => [];
}

class UserProfileUpdateFailure extends UserProfileState {
  @override
  List<Object> get props => [];
}

class FindTeamSearching extends UserProfileState {
  @override
  List<Object> get props => [];
}

class CannotJoinTeam extends UserProfileState {
  @override
  List<Object> get props => [];
}

class FindTeamSuccess extends UserProfileState {
  final DocumentReference teamReference;

  FindTeamSuccess({@required this.teamReference});

  @override
  List<Object> get props => [teamReference];
}

class FindTeamFailure extends UserProfileState {
  @override
  List<Object> get props => [];
}

class CreatingTeam extends UserProfileState {
  @override
  List<Object> get props => [];
}

class CreateTeamSuccess extends UserProfileState {
  final DocumentReference teamReference;

  CreateTeamSuccess({@required this.teamReference});

  @override
  List<Object> get props => [teamReference];
}

class CreateTeamFailure extends UserProfileState {
  @override
  List<Object> get props => [];
}