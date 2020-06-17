import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pubg/data_source/model/team_model.dart';
import 'package:pubg/team_detail/model/team_detail.dart';

@immutable
abstract class TeamDetailState extends Equatable {
  const TeamDetailState();
}

class TeamDetailEmpty extends TeamDetailState {
  @override
  List<Object> get props => [];
}

class TeamDetailUpdating extends TeamDetailState {
  @override
  List<Object> get props => [];
}

class TeamDetailChangeSuccess extends TeamDetailState {
  @override
  List<Object> get props => [];
}

class TeamDetailChangeFailure extends TeamDetailState {
  @override
  List<Object> get props => [];
}

class SubmitFormVisible extends TeamDetailState {
  @override
  List<Object> get props => [];
}

class SubmitFormInVisible extends TeamDetailState {
  @override
  List<Object> get props => [];
}

class PreFilled extends TeamDetailState {
  final TeamDetail team;

  PreFilled({@required this.team});

  @override
  List<Object> get props => [team];
}
