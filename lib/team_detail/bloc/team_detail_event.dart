import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pubg/data_source/model/team_model.dart';
import 'package:pubg/team_detail/model/team_detail.dart';

abstract class TeamDetailEvent extends Equatable {
  const TeamDetailEvent();
}

class TeamDetailScreenInitialized extends TeamDetailEvent {
  @override
  List<Object> get props => [];
}

class TeamDetailSubmitPressed extends TeamDetailEvent {
  final TeamDetail team;

  TeamDetailSubmitPressed({this.team});

  @override
  List<Object> get props => [team];
}
