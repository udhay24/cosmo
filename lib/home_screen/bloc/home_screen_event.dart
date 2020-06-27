import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class HomeScreenEvent extends Equatable {
  const HomeScreenEvent();
}

class HomeScreenStarted extends HomeScreenEvent {
  @override
  List<Object> get props => [];
}

class EventSelected extends HomeScreenEvent {
  final int eventID;

  EventSelected({@required this.eventID});

  @override
  List<Object> get props => [eventID];
}

class SlotSelected extends HomeScreenEvent {
  final int eventId;
  final int selectedSlot;

  SlotSelected({@required this.selectedSlot, @required this.eventId});

  @override
  List<Object> get props => [selectedSlot, eventId];
}

class RegistrationCancelled extends HomeScreenEvent {
  final int eventID;

  RegistrationCancelled({@required this.eventID});

  @override
  List<Object> get props => [eventID];
}

class UpdateFcmCode extends HomeScreenEvent {
  final String fcmCode;

  UpdateFcmCode({@required this.fcmCode});

  @override
  List<Object> get props => [fcmCode];
}

class EventNotificationReceived extends HomeScreenEvent {
  final String eventId;
  final String roomId;
  final String roomPassword;

  EventNotificationReceived({
    @required this.roomId,
    @required this.roomPassword,
    @required this.eventId,
  });

  @override
  List<Object> get props => [eventId, roomPassword, roomId];
}

class EventRegistrationDialogOpened extends HomeScreenEvent {
  final int eventID;

  EventRegistrationDialogOpened({@required this.eventID});

  @override
  List<Object> get props => [eventID];
}
