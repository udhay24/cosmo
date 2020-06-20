import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:pubg/data_source/model/team_model.dart';
import 'package:pubg/data_source/model/user_model.dart';
import 'package:pubg/data_source/user_repository.dart';
import 'package:pubg/team_detail/model/team_detail.dart';

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
    }  else if (event is TeamDetailSubmitPressed) {
      yield* _mapTeamSubmittedChangedToState(event);
    }
  }

  Stream<TeamDetailState> _mapTeamSubmittedChangedToState(
      TeamDetailSubmitPressed event) async* {
    yield TeamDetailUpdating();
    try {
      List<DocumentReference> teamMembers = List();
      for (var member in event.team.teamMembers) {
        teamMembers.add(await _userRepository.getUserRefFromUuid(member.userUuid));
      }
      await _userRepository.updateTeamDetail(
        Team(
            teamName: event.team.teamName,
            teamCode: event.team.teamCode,
            teamId: event.team.teamId,
            teamMembers: teamMembers,
            teamOwner: await _userRepository.getCurrentUserReference()),
      );
      await Future.forEach(event.removedUsers, (User user) async {
        var updatedUser = User(userName: user.userName, phoneNumber: user.phoneNumber, userUuid: user.userUuid, joinedTeam: null);
        await _userRepository.updateUserDetail(updatedUser);
      });
      yield TeamDetailChangeSuccess();
    } catch (_) {
      yield TeamDetailChangeFailure();
    }
  }

  Stream<TeamDetailState> _mapScreenInitializedToState() async* {
    try {
      var team = await _userRepository.getCurrentUserTeam();
      List<User> members = List();
      for (var member in team.teamMembers) {
        members.add( await _userRepository.getUserFromRef(member));
      }
      if (team != null) {
        yield PreFilled(
            team: TeamDetail(
                teamId: team.teamId,
                teamName: team.teamName,
                teamCode: team.teamCode,
                teamMembers: members));
      } else {
        yield TeamDetailEmpty();
      }
    } catch (e) {
      yield TeamDetailEmpty();
    }
  }
}
