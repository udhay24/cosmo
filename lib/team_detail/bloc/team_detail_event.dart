import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pubg/data_source/model/team_detail.dart';

abstract class TeamDetailEvent extends Equatable {
  const TeamDetailEvent();
}

class TeamMemberDetailChanged extends TeamDetailEvent {
  final TeamDetailModel teamDetailModel;

  TeamMemberDetailChanged({@required this.teamDetailModel});

  @override
  List<Object> get props => [teamDetailModel];
}

class TeamDetailScreenInitialized extends TeamDetailEvent {
  TeamDetailScreenInitialized();

  @override
  List<Object> get props => [];
}

class TeamDetailSubmitPressed extends TeamDetailEvent {
  final TeamDetailModel teamDetail;

  TeamDetailSubmitPressed({this.teamDetail});

  @override
  List<Object> get props => [teamDetail];
}
