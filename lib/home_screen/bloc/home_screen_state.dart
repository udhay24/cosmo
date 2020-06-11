import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pubg/data_source/model/available_event.dart';
import 'package:pubg/home_screen/bloc/bloc.dart';

abstract class HomeScreenState extends Equatable {
  const HomeScreenState();
}

class InitialHomeScreenState extends HomeScreenState {
  @override
  List<Object> get props => [];
}


class AvailableEventsLoading extends HomeScreenState {
  @override
  List<Object> get props => [];
}


class AvailableEventsFailure extends HomeScreenState {
  @override
  List<Object> get props => [];
}


class AvailableEventsSuccess extends HomeScreenState {
  final List<AvailableEvent> availableEvents;
  
  AvailableEventsSuccess({@required this.availableEvents});
  
  @override
  List<Object> get props => [availableEvents];
}


class MissingUserDetails extends HomeScreenState {
  @override
  List<Object> get props => [];
}

