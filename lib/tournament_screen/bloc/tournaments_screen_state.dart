part of 'tournaments_screen_bloc.dart';

abstract class TournamentsScreenState extends Equatable {
  const TournamentsScreenState();
}

class TournamentsScreenStarted extends TournamentsScreenState {
  @override
  List<Object> get props => [];
}

class LoadingTournaments extends TournamentsScreenState {
  @override
  List<Object> get props => [];
}

class TournamentLoadSuccess extends TournamentsScreenState {
  final List<TournamentUIModel> tournaments;

  TournamentLoadSuccess({@required this.tournaments});

  @override
  List<Object> get props => [tournaments];
}

class TournamentLoadFailure extends TournamentsScreenState {
  @override
  List<Object> get props => [];
}

class TournamentShowDialogSuccess extends TournamentsScreenState {
  final TournamentUIModel tournament;

  TournamentShowDialogSuccess({@required this.tournament});

  @override
  List<Object> get props => [tournament];
}

class TournamentRegistrationSuccess extends TournamentsScreenState {
  @override
  List<Object> get props => [];
}

class TournamentRegistrationFailure extends TournamentsScreenState {
  @override
  List<Object> get props => [];
}

class CheckingUserDetails extends TournamentsScreenState {
  @override
  List<Object> get props => [];
}

class InCompletedUserDetail extends TournamentsScreenState {
  @override
  List<Object> get props => [];
}

class CompletedUserDetail extends TournamentsScreenState {
  @override
  List<Object> get props => [];
}