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
  TeamDetailState get initialState => TeamDetailEmpty();

  @override
  Stream<TeamDetailState> mapEventToState(
    TeamDetailEvent event,
  ) async* {
    if (event is TeamDetailScreenInitialized) {
      yield* _mapScreenInitializedToState();
    } else if (event is TeamMemberDetailChanged) {
      yield* _mapDetailChangedToState(event.teamDetailModel);
    } else if (event is TeamDetailSubmitPressed) {
      yield* _mapTeamSubmittedChangedToState(event.teamDetail);
    }
  }

  Stream<TeamDetailState> _mapDetailChangedToState(TeamDetailModel model) async* {
    if(model.areFieldsValid()) {
      yield SubmitFormVisible();
    } else {
      yield SubmitFormInVisible();
    }
  }

  Stream<TeamDetailState> _mapTeamSubmittedChangedToState(
      TeamDetailModel teamDetail) async* {
    yield TeamDetailSubmitting();
    try {
      await fireStoreRepository.createTeamDetails(teamDetail);
      yield TeamDetailSubmittedSuccess();
    } catch(_) {
      yield TeamDetailSubmittedFailure();
    }
  }

  Stream<TeamDetailState> _mapScreenInitializedToState() async* {
    yield await fireStoreRepository.containsTeamDetails().then((value) async {
      if (value) {
        var detail = await fireStoreRepository.fetchTeamDetails();
        return PreFilled(teamDetailModel: detail);
      } else {
        return TeamDetailEmpty();
      }
    });
  }
}
