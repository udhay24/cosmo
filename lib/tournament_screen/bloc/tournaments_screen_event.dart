part of 'tournaments_screen_bloc.dart';

abstract class TournamentsScreenEvent extends Equatable {
  const TournamentsScreenEvent();
}

class LoadAvailableTournaments extends TournamentsScreenEvent {
  @override
  List<Object> get props => [];
}

class TournamentSelected extends TournamentsScreenEvent {
  final TournamentUIModel tournament;

  TournamentSelected({@required this.tournament});

  @override
  List<Object> get props => [tournament];
}

class TournamentRegistration extends TournamentsScreenEvent {
  final int tournamentId;

  TournamentRegistration({@required this.tournamentId});

  @override
  List<Object> get props => [tournamentId];
}
