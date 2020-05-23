import 'package:equatable/equatable.dart';
import 'package:pubg/data_source/model/team_detail.dart';
import 'package:pubg/team_detail/bloc.dart';

abstract class TeamDetailEvent extends Equatable {
  const TeamDetailEvent();
}

class PubgNameChanged extends TeamDetailEvent {
  final String pubgName;

  PubgNameChanged({this.pubgName});

  @override
  List<Object> get props => [pubgName];
}

class PhoneNumberChanged extends TeamDetailEvent {
  final String phoneNumber;

  PhoneNumberChanged({this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}

class TeamNameChanged extends TeamDetailEvent {
  final String teamName;

  TeamNameChanged({this.teamName});

  @override
  List<Object> get props => [teamName];
}

class MembersChanged extends TeamDetailEvent {
  final List<String> members;

  MembersChanged({this.members});

  @override
  List<Object> get props => [members];
}

class TeamDetailSubmitPressed extends TeamDetailEvent {
  final TeamDetail teamDetail;

  TeamDetailSubmitPressed({this.teamDetail});

  @override
  List<Object> get props => [teamDetail];
}
