import 'package:cloud_firestore/cloud_firestore.dart';
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

class EventRegistrationSuccess extends HomeScreenState {
  @override
  List<Object> get props => [];
}

class EventRegistrationFailure extends HomeScreenState {
  @override
  List<Object> get props => [];
}

class ShowSlotDialog extends HomeScreenState {
  final DocumentReference selectedEvent;
  final List<int> availableSlots;

  ShowSlotDialog({@required this.selectedEvent, @required this.availableSlots});

  @override
  List<Object> get props => [selectedEvent, availableSlots];
}