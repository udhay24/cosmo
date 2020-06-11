import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:pubg/data_source/user_repository.dart';

import './bloc.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final UserRepository _userRepository;

  UserProfileBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  UserProfileState get initialState => InitialUserProfileState();

  @override
  Stream<UserProfileState> mapEventToState(
    UserProfileEvent event,
  ) async* {
    if (event is ProfileScreenInitialized) {
      yield* _mapInitializedEventToState(event);
    } else if (event is CreateTeamPressed) {
      yield* _mapTeamCreatedEvent(event);
    } else if (event is JoinTeamPressed) {
      yield* _mapJoinTeamEvent(event);
    } else if (event is SaveProfilePressed) {
      yield* _mapSaveProfileEvent(event);
    }
  }

  Stream<UserProfileState> _mapInitializedEventToState(
      ProfileScreenInitialized event) async* {
    try {
      var userDetails = await _userRepository.getUserDetail();
      yield UserProfileLoadedState(userDetail: userDetails);
    } catch (error) {
      print("error in loading user detail $error");
      yield UserProfileFailed();
    }
  }

  Stream<UserProfileState> _mapTeamCreatedEvent(CreateTeamPressed event) {}

  Stream<UserProfileState> _mapJoinTeamEvent(JoinTeamPressed event) {}

  Stream<UserProfileState> _mapSaveProfileEvent(SaveProfilePressed event) async* {
    try {
      _userRepository.updateUserDetail(event.userDetail);
      yield UserProfileUpdateSuccess();
    } catch(e) {
      yield UserProfileUpdateFailure();
    }
  }
}
