import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pubg/data_source/model/team_detail.dart';

@immutable
abstract class TeamDetailState extends Equatable {
  const TeamDetailState();
}

class TeamDetailEmpty extends TeamDetailState {
  @override
  List<Object> get props => [];
}

class TeamDetailSubmitting extends TeamDetailState {
  @override
  List<Object> get props => [];
}

class TeamDetailSubmittedSuccess extends TeamDetailState {
  @override
  List<Object> get props => [];
}

class TeamDetailSubmittedFailure extends TeamDetailState {
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

  final TeamDetailModel teamDetailModel;

  PreFilled({@required this.teamDetailModel});
  @override
  List<Object> get props => [];
}