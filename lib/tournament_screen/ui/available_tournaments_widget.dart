import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/tournament_screen/bloc/tournaments_screen_bloc.dart';
import 'package:pubg/tournament_screen/tournament_ui_model.dart';
import 'package:pubg/tournament_screen/ui/tournament_registration_dialog.dart';
import 'package:pubg/util/widget_util.dart';

class TournamentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext buildContext) {
    return BlocConsumer<TournamentsScreenBloc, TournamentsScreenState>(
      listener: (context, state) {
        if (state is TournamentShowDialogSuccess) {
          showModalBottomSheet(
              context: context,
              builder: (context) => TournamentRegistrationDialog(
                    tournamentUIModel: state.tournament,
                    tournamentsScreenBloc:
                        BlocProvider.of<TournamentsScreenBloc>(buildContext),
                  ));
        } else if (state is TournamentRegistrationSuccess) {
          Scaffold.of(context)
              .showSnackBar(buildSnackBar("Registration success"));
          BlocProvider.of<TournamentsScreenBloc>(buildContext)
              .add(LoadAvailableTournaments());
        } else if (state is TournamentRegistrationFailure) {
          Scaffold.of(context).showSnackBar(
              buildSnackBar("Registration Failed. Try again later!"));
        }
      },
      buildWhen: (prevState, nextState) {
        if (nextState is LoadingTournaments ||
            nextState is TournamentLoadSuccess ||
            nextState is TournamentLoadFailure) {
          return true;
        } else
          return false;
      },
      builder: (context, state) {
        if (state is LoadingTournaments) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is TournamentLoadSuccess) {
          return ListView.builder(
            itemBuilder: (context, position) {
              return _buildTournamentCard(context, state.tournaments[position]);
            },
            itemCount: state.tournaments.length,
            shrinkWrap: true,
          );
        } else if (state is TournamentLoadFailure) {
          return Center(
            child: Text("Error loading tournaments"),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildTournamentCard(
      BuildContext context, TournamentUIModel tournament) {
    return Card(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Container(
          height: 200,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/pubg_player.jpg"),
                  colorFilter:
                      ColorFilter.mode(Colors.grey, BlendMode.darken))),
          child: Stack(
            children: [
              Positioned(
                bottom: 20,
                left: 20,
                child: Column(
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        tournament.tournamentModel.tournamentName,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 150,
                      child: Text(
                        tournament.tournamentModel.tournamentDescription,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 20,
                bottom: 10,
                child: FlatButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: tournament.isRegistered
                      ? null
                      : () {
                    BlocProvider.of<TournamentsScreenBloc>(context)
                        .add(TournamentSelected(tournament: tournament));
                  },
                  child:
                  tournament.isRegistered ? Text("Joined") : Text("Join"),
                  textColor: Colors.blueAccent,
                  disabledColor: Colors.grey[300],
                ),
              ),
            ],
          ),
        ));
  }
}
