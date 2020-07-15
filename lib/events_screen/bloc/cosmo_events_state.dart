part of 'cosmo_events_bloc.dart';

abstract class CosmoEventsState extends Equatable {
  const CosmoEventsState();
}

class CosmoEventsInitial extends CosmoEventsState {
  @override
  List<Object> get props => [];
}

class AvailableEventsLoading extends CosmoEventsState {
  @override
  List<Object> get props => [];
}

class AvailableEventsFailure extends CosmoEventsState {
  @override
  List<Object> get props => [];
}

class AvailableEventsSuccess extends CosmoEventsState {
  final List<CosmoEventUIModel> availableEvents;

  AvailableEventsSuccess({@required this.availableEvents});

  @override
  List<Object> get props => [availableEvents];
}

class CheckingUserDetails extends CosmoEventsState {
  @override
  List<Object> get props => [];
}

class MissingUserDetails extends CosmoEventsState {
  @override
  List<Object> get props => [];
}

class EventRegistrationSuccess extends CosmoEventsState {
  @override
  List<Object> get props => [];
}

class EventRegistrationFailure extends CosmoEventsState {
  @override
  List<Object> get props => [];
}

class ShowSlotDialog extends CosmoEventsState {
  final eventID;

  ShowSlotDialog({
    @required this.eventID,
  });

  @override
  List<Object> get props => [
        eventID,
      ];
}

class SelectedEventDetailLoaded extends CosmoEventsState {
  final SelectedEventDetail eventDetail;

  SelectedEventDetailLoaded({@required this.eventDetail});

  @override
  List<Object> get props => [eventDetail];
}

class SelectedEventDetailLoading extends CosmoEventsState {
  @override
  List<Object> get props => [];
}

class SelectedEventDetailFailure extends CosmoEventsState {
  @override
  List<Object> get props => [];
}

class CancellingRegistration extends CosmoEventsState {
  @override
  List<Object> get props => [];
}

class CancellationSuccess extends CosmoEventsState {
  @override
  List<Object> get props => [];
}

class CancellationFailure extends CosmoEventsState {
  @override
  List<Object> get props => [];
}

class RoomDetailsAvailable extends CosmoEventsState {
  final RoomDetail roomDetail;

  RoomDetailsAvailable({@required this.roomDetail});

  @override
  List<Object> get props => [roomDetail];
}

class RoomDetailsNotAvailable extends CosmoEventsState {
  @override
  List<Object> get props => [];
}
