import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pubg/data_source/model/available_event.dart';
import 'package:pubg/home_screen/model/event_detail.dart';

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
  final List<CosmoEventUIModel> availableEvents;

  AvailableEventsSuccess({@required this.availableEvents});

  @override
  List<Object> get props => [availableEvents];
}

class CheckingUserDetails extends HomeScreenState {
  @override
  List<Object> get props => [];
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
  final eventID;

  ShowSlotDialog({
    @required this.eventID,
  });

  @override
  List<Object> get props => [
        eventID,
      ];
}

class SelectedEventDetailLoaded extends HomeScreenState {
  final SelectedEventDetail eventDetail;

  SelectedEventDetailLoaded({@required this.eventDetail});

  @override
  List<Object> get props => [eventDetail];
}

class SelectedEventDetailLoading extends HomeScreenState {
  @override
  List<Object> get props => [];
}

class SelectedEventDetailFailure extends HomeScreenState {
  @override
  List<Object> get props => [];
}

class CancellingRegistration extends HomeScreenState {
  @override
  List<Object> get props => [];
}

class CancellationSuccess extends HomeScreenState {
  @override
  List<Object> get props => [];
}

class CancellationFailure extends HomeScreenState {
  @override
  List<Object> get props => [];
}

class RoomDetailsAvailable extends HomeScreenState {
  final RoomDetail roomDetail;

  RoomDetailsAvailable({@required this.roomDetail});

  @override
  List<Object> get props => [roomDetail];
}

class RoomDetailsNotAvailable extends HomeScreenState {
  @override
  List<Object> get props => [];
}