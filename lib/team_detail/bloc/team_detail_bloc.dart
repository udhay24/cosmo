import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:pubg/data_source/firestore_repository.dart';
import 'package:pubg/data_source/model/team_detail.dart';
import 'package:pubg/util/validators.dart';

import 'bloc.dart';

class TeamDetailBloc extends Bloc<TeamDetailEvent, TeamDetailState> {
  final FireStoreRepository fireStoreRepository;

  TeamDetailBloc({@required FireStoreRepository fireStoreRepository})
      : assert(fireStoreRepository != null),
        this.fireStoreRepository = fireStoreRepository;

  @override
  TeamDetailState get initialState => TeamDetailState.empty();

  @override
  Stream<TeamDetailState> mapEventToState(
    TeamDetailEvent event,
  ) async* {
    if (event is PubgNameChanged) {
      yield* _mapPubgNameChangedToState(event.pubgName);
    } else if (event is TeamNameChanged) {
      yield* _mapTeamNameChangedToState(event.teamName);
    } else if (event is PhoneNumberChanged) {
      yield* _mapPhoneNumberChangedToState(event.phoneNumber);
    } else if (event is MembersChanged) {
      yield* _mapMemberListChangedToState(event.members);
    } else if (event is TeamDetailSubmitPressed) {
      yield* _mapTeamSubmittedChangedToState(event.teamDetail);
    }
  }

  Stream<TeamDetailState> _mapPubgNameChangedToState(String pubgName) async* {
    yield state.update(isPubgNameValid: Validators.isValidName(pubgName));
  }

  Stream<TeamDetailState> _mapTeamNameChangedToState(String teamName) async* {
    yield state.update(isTeamNameValid: Validators.isValidName(teamName));
  }

  Stream<TeamDetailState> _mapPhoneNumberChangedToState(
      String phoneNumber) async* {
    yield state.update(
        isPhoneNumberValid: Validators.isValidPhoneNumber(phoneNumber));
  }

  Stream<TeamDetailState> _mapMemberListChangedToState(
      List<String> members) async* {
    yield state.update(
        isTeamMembersValid: Validators.isMembersListValid(members));
  }

  Stream<TeamDetailState> _mapTeamSubmittedChangedToState(
      TeamDetail teamDetail) async* {
    yield TeamDetailState.loading();
    try {
      await fireStoreRepository.createTeamDetails(teamDetail);
      yield TeamDetailState.success();
    } catch(_) {
      yield TeamDetailState.failure();
    }
  }
}
