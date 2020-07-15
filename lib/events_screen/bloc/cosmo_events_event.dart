part of 'cosmo_events_bloc.dart';

abstract class CosmoEventsEvent extends Equatable {
  const CosmoEventsEvent();
}

class LoadAvailableEvents extends CosmoEventsEvent {
  @override
  List<Object> get props => [];
}

class EventSelected extends CosmoEventsEvent {
  final int eventID;

  EventSelected({@required this.eventID});

  @override
  List<Object> get props => [eventID];
}

class SlotSelected extends CosmoEventsEvent {
  final int eventId;
  final int selectedSlot;

  SlotSelected({@required this.selectedSlot, @required this.eventId});

  @override
  List<Object> get props => [selectedSlot, eventId];
}

class RegistrationCancelled extends CosmoEventsEvent {
  final int eventID;

  RegistrationCancelled({@required this.eventID});

  @override
  List<Object> get props => [eventID];
}

class EventRegistrationDialogOpened extends CosmoEventsEvent {
  final int eventID;

  EventRegistrationDialogOpened({@required this.eventID});

  @override
  List<Object> get props => [eventID];
}

class ShowRoomDetails extends CosmoEventsEvent {
  final int eventId;

  ShowRoomDetails({@required this.eventId});

  @override
  List<Object> get props => [eventId];
}
