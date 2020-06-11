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
  @override
  List<Object> get props => [];
}

class JoinTeamPressed extends UserProfileEvent {
  @override
  List<Object> get props => [];
}

class SaveProfilePressed extends UserProfileEvent {
  final UserDetail userDetail;

  SaveProfilePressed({@required this.userDetail});

  @override
  List<Object> get props => [];
}
