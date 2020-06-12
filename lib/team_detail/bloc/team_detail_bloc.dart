import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:pubg/data_source/user_repository.dart';
import 'package:pubg/util/validators.dart';

import 'bloc.dart';

class TeamDetailBloc extends Bloc<TeamDetailEvent, TeamDetailState> {
  final UserRepository _userRepository;

  TeamDetailBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        this._userRepository = userRepository;

  @override
  TeamDetailState get initialState => TeamDetailEmpty();

  @override
  Stream<TeamDetailState> mapEventToState(
    TeamDetailEvent event,
  ) async* {
    if (event is TeamDetailScreenInitialized) {
      yield* _mapScreenInitializedToState();
    } else if (event is TeamMemberDetailChanged) {
      yield* _mapDetailChangedToState(event);
    } else if (event is TeamDetailSubmitPressed) {
      yield* _mapTeamSubmittedChangedToState(event);
    }
  }

  Stream<TeamDetailState> _mapDetailChangedToState(
      TeamMemberDetailChanged event) async* {
    if (Validators.isValidName(event.team.teamName) &&
        Validators.isValidName(event.team.teamCode)) {
      yield SubmitFormVisible();
    } else {
      yield SubmitFormInVisible();
    }
  }

  Stream<TeamDetailState> _mapTeamSubmittedChangedToState(
      TeamDetailSubmitPressed event) async* {
    yield TeamDetailUpdating();
    try {
      await _userRepository.updateTeamDetail(event.team);
      yield TeamDetailChangeSuccess();
    } catch (_) {
      yield TeamDetailChangeFailure();
    }
  }

  Stream<TeamDetailState> _mapScreenInitializedToState() async* {
    try {
      var team = await _userRepository.getCurrentUserTeam();
      yield PreFilled(team: team);
    } catch (e) {
      yield TeamDetailEmpty();
    }
  }
}
