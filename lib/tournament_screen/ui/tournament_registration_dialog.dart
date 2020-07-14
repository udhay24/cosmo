import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pubg/tournament_screen/bloc/tournaments_screen_bloc.dart';
import 'package:pubg/tournament_screen/model/registrations_models.dart';
import 'package:pubg/tournament_screen/tournament_ui_model.dart';
import 'package:pubg/util/network_util.dart';

class TournamentRegistrationDialog extends StatefulWidget {
  final TournamentUIModel tournamentUIModel;
  final TournamentsScreenBloc tournamentsScreenBloc;

  TournamentRegistrationDialog(
      {@required this.tournamentUIModel, @required this.tournamentsScreenBloc});

  @override
  _TournamentRegistrationDialogState createState() =>
      _TournamentRegistrationDialogState();
}

class _TournamentRegistrationDialogState
    extends State<TournamentRegistrationDialog> {
  RequiredRegistrationsModel youtube = RequiredRegistrationsModel(
      platformName: "Youtube",
      platformUrl: "https://www.youtube.com/channel/UCVJWGqiu1NYP0yG7-bkCSog");

  RequiredRegistrationsModel instagram = RequiredRegistrationsModel(
      platformName: "Instagram",
      platformUrl: "https://instagram.com/cosmogamingz?igshid=7o93qh2op04u");

  RequiredRegistrationsModel twitch = RequiredRegistrationsModel(
      platformName: "Twitch",
      platformUrl: "https://www.twitch.tv/cosmo_gamingz");

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildEventHeading(context, widget.tournamentUIModel),
        Divider(
          thickness: 2,
        ),
        Text(
          "Complete the following steps to register for the tournament",
          style: Theme.of(context).textTheme.headline6,
        ),
        ListView.builder(
          itemBuilder: (context, position) {
            if (position == 0) {
              return _buildRegistrationItemTile(youtube);
            } else if (position == 1) {
              return _buildRegistrationItemTile(instagram);
            } else if (position == 2) {
              return _buildRegistrationItemTile(twitch);
            } else {
              return Container();
            }
          },
          itemCount: 3,
          shrinkWrap: true,
        ),
        FlatButton(
          child: Text("Register"),
          onPressed: (youtube.isSubscribed &&
                      instagram.isSubscribed &&
                      twitch.isSubscribed ||
                  true)
              ? () {
                  widget.tournamentsScreenBloc.add(TournamentRegistration(
                      tournamentId: widget
                          .tournamentUIModel.tournamentModel.tournamentID));
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildEventHeading(
      BuildContext context, TournamentUIModel tournamentUIModel) {
    return ListTile(
      leading: SizedBox(
          height: 32,
          width: 32,
          child: Image.asset(
            "assets/icons/pubg-helmet-64.png",
          )),
      title: Text(
        tournamentUIModel.tournamentModel.tournamentName,
        style: Theme.of(context).textTheme.headline4,
      ),
      subtitle: Text(
        tournamentUIModel.tournamentModel.tournamentDescription,
        style: Theme.of(context).textTheme.subtitle2,
      ),
    );
  }

  Widget _buildRegistrationItemTile(
      RequiredRegistrationsModel registrationsModel) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          registrationsModel.isSubscribed
              ? Icon(FontAwesomeIcons.ticketAlt)
              : SizedBox(
                  height: 12,
                  width: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  )),
          Text(
            "subscribe to ${registrationsModel.platformName}",
            style: Theme.of(context).textTheme.headline4,
          ),
          GestureDetector(
            child: Icon(FontAwesomeIcons.arrowRight),
            onTap: () {
              launchURL(url: registrationsModel.platformUrl);
              Timer(Duration(seconds: 5), () {
                setState(() {
                  registrationsModel.isSubscribed = true;
                });
              });
            },
          )
        ],
      ),
    );
  }
}
