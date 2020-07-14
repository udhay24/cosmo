import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pubg/data_source/model/tournament_model.dart';
import 'package:pubg/data_source/tournament_repository.dart';
import 'package:pubg/data_source/user_repository.dart';
import 'package:pubg/tournament_screen/model/tournament_ui_model.dart';

part 'tournaments_screen_event.dart';

part 'tournaments_screen_state.dart';

class TournamentsScreenBloc
    extends Bloc<TournamentsScreenEvent, TournamentsScreenState> {
  final TournamentRepository _tournamentRepository;
  final UserRepository _userRepository;

  TournamentsScreenBloc(
      {@required TournamentRepository repository,
      @required UserRepository userRepository})
      : assert(repository != null && userRepository != null),
        _tournamentRepository = repository,
        _userRepository = userRepository,
        super(TournamentsScreenStarted());

  @override
  Stream<TournamentsScreenState> mapEventToState(
    TournamentsScreenEvent event,
  ) async* {
    if (event is TournamentsScreenStarted) {
      add(LoadAvailableTournaments());
    } else if (event is LoadAvailableTournaments) {
      yield* _mapTournamentLoading(event);
    } else if (event is TournamentSelected) {
      yield* _mapTournamentSelected(event);
    } else if (event is TournamentRegistration) {
      yield* _mapTournamentRegistration(event);
    }
  }

  Stream<TournamentsScreenState> _mapTournamentLoading(
      LoadAvailableTournaments event) async* {
    yield LoadingTournaments();
    try {
      var tournaments = await _tournamentRepository.fetchAllTournaments();
      var tournamentModels = await Future.wait(tournaments.map((e) async {
        if (e.tournamentType == TournamentType.PUBLICITY_TOURNAMENT) {
          var isRegistered = await _tournamentRepository
              .isUserRegisteredToTournament(e.tournamentID);
          return TournamentUIModel(
              tournamentModel: e, isRegistered: isRegistered);
        } else {
          var isRegistered = await _tournamentRepository
              .isUserTeamRegisteredToTournament(e.tournamentID);
          return TournamentUIModel(
              tournamentModel: e, isRegistered: isRegistered);
        }
      }).toList());
      yield TournamentLoadSuccess(tournaments: tournamentModels);
    } catch (error) {
      print("Tournament error $error");
      yield TournamentLoadFailure();
    }
  }

  Stream<TournamentsScreenState> _mapTournamentSelected(
      TournamentSelected event) async* {
    yield CheckingUserDetails();
    if (await _userRepository.isUserProfileComplete()) {
      yield TournamentShowDialogSuccess(tournament: event.tournament);
    } else {
      yield InCompletedUserDetail();
    }
  }

  Stream<TournamentsScreenState> _mapTournamentRegistration(
      TournamentRegistration event) async* {
    try {
      await _tournamentRepository.registerUserToTournament(event.tournamentId);
      yield TournamentRegistrationSuccess();
    } catch (error) {
      print("Tournament bloc $error");
      yield TournamentRegistrationFailure();
    }
  }
}
