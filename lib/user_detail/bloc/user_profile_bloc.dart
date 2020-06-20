import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:pubg/data_source/model/team_model.dart';
import 'package:pubg/data_source/user_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/streams.dart';

import './bloc.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final UserRepository _userRepository;

  UserProfileBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  UserProfileState get initialState => InitialUserProfileState();

  @override
  Stream<Transition<UserProfileEvent, UserProfileState>> transformEvents(
      Stream<UserProfileEvent> events,
      TransitionFunction<UserProfileEvent, UserProfileState> transitionFn,
      ) {
    final nonDebounceStream = events.where((event) {
      return (event is! NewTeamIdEntered);
    });
    final debounceStream = events.where((event) {
      return (event is NewTeamIdEntered);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }


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
    } else if (event is UpdateProfile) {
      yield* _mapUpdateProfileEvent(event);
    } else if (event is SaveProfilePressed) {
      yield* _mapSaveProfileEvent(event);
    } else if (event is NewTeamIdEntered) {
      yield* _mapNewTeamIdEvent(event);
    }
  }

  Stream<UserProfileState> _mapInitializedEventToState(
      ProfileScreenInitialized event) async* {
    try {
      var userDetails = await _userRepository.getCurrentUserDetail();
      yield UserProfileLoadedState(userDetail: userDetails);
    } catch (error) {
      print("error in loading user detail $error");
      yield UserProfileFailed();
    }
  }

  Stream<UserProfileState> _mapTeamCreatedEvent(
      CreateTeamPressed event) async* {
    yield CreatingTeam();
    try {
      var currentUser = await _userRepository.getCurrentUserReference();
      var _teamRef = await _userRepository.createTeam(Team(
          teamName: event.teamName,
          teamCode: event.teamCode,
          teamId: event.teamID,
          teamMembers: [],
          teamOwner: currentUser));
      yield CreateTeamSuccess(teamReference: _teamRef);
    } catch (e) {
      print(e);
      yield CreateTeamFailure();
    }
  }

  Stream<UserProfileState> _mapJoinTeamEvent(JoinTeamPressed event) async* {
    yield FindTeamSearching();
    try {
      var teamReference = await _userRepository.fetchTeamReference(
          event.teamID, event.teamCode);
      var team = await _userRepository.getTeamDetails(teamReference);
      if (team.teamMembers.length > 3) {
        yield CannotJoinTeam();
      } else {
        yield FindTeamSuccess(
            teamReference:
                Firestore.instance.collection("teams").document(teamReference));
      }
    } catch (e) {
      print(e);
      yield FindTeamFailure();
    }
  }

  Stream<UserProfileState> _mapUpdateProfileEvent(
      UpdateProfile event) async* {
    yield UserProfileUpdating();
    try {
      await _userRepository.removeCurrentUserFromTeam();
      await _userRepository.updateCurrentUserDetail(event.userDetail);
      await _userRepository
          .addCurrentUserToTeamWithRef(event.userDetail.joinedTeam);
      yield UserProfileUpdateSuccess();
    } catch (e) {
      yield UserProfileUpdateFailure();
    }
  }

  Stream<UserProfileState> _mapSaveProfileEvent(SaveProfilePressed event) async* {
    yield UserProfileStartUpdate();
  }

  Stream<UserProfileState> _mapNewTeamIdEvent(NewTeamIdEntered event) async* {
    try {
      yield ValidatingTeamId();
      var results = await _userRepository.getMatchingTeams(event.teamID);
      if (results.length > 0) {
        yield InValidTeamId();
      } else {
        yield ValidTeamId();
      }
    } catch (e) {
      yield InValidTeamId();
    }
  }
}
