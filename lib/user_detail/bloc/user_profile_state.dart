import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

class UserProfileUpdateFailure extends UserProfileState {
  @override
  List<Object> get props => [];
}

