import 'package:flutter/material.dart';
import 'package:pubg/data_source/model/tournament_model.dart';

class TournamentUIModel {
  final TournamentModel tournamentModel;
  final bool isRegistered;

  TournamentUIModel(
      {@required this.tournamentModel, @required this.isRegistered});
}
