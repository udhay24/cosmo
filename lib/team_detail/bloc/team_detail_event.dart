import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pubg/data_source/model/team_detail.dart';

abstract class TeamDetailEvent extends Equatable {
  const TeamDetailEvent();
}

class TeamMemberDetailChanged extends TeamDetailEvent {
  final Team team;

  TeamMemberDetailChanged({@required this.team});

  @override
  List<Object> get props => [team];
}

class TeamDetailScreenInitialized extends TeamDetailEvent {
  @override
  List<Object> get props => [];
}

class TeamDetailSubmitPressed extends TeamDetailEvent {
  final Team team;

  TeamDetailSubmitPressed({this.team});

  @override
  List<Object> get props => [team];
}
