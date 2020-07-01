import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:pubg/data_source/event_repository.dart';
import 'package:pubg/data_source/model/available_event.dart';
import 'package:pubg/data_source/model/event_notification.dart';
import 'package:pubg/data_source/user_repository.dart';
import 'package:pubg/home_screen/model/event_detail.dart';

import './bloc.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  final UserRepository _userRepository;
  final EventRepository _eventRepository;

  HomeScreenBloc(
      {@required UserRepository userRepository,
      @required EventRepository eventRepository})
      : assert((userRepository != null) && (eventRepository != null)),
        _userRepository = userRepository,
        _eventRepository = eventRepository;

  @override
  HomeScreenState get initialState => InitialHomeScreenState();

  @override
  Stream<HomeScreenState> mapEventToState(
    HomeScreenEvent event,
  ) async* {
    if (event is EventSelected) {
      yield* _mapEventSelectedToState(event);
    } else if (event is HomeScreenStarted) {
      yield* _mapInitialEventState(event);
    } else if (event is SlotSelected) {
      yield* _mapSlotSelectedEvent(event);
    } else if (event is UpdateFcmCode) {
      _mapUpdateFcmCodeEvent(event);
    } else if (event is EventNotificationReceived) {
      _mapNotificationEvent(event);
    } else if (event is EventRegistrationDialogOpened) {
      yield* _mapRegistrationDialogOpened(event);
    } else if (event is RegistrationCancelled) {
      yield* _mapRegistrationCancellation(event);
    }
  }

  Stream<HomeScreenState> _mapSlotSelectedEvent(SlotSelected event) async* {
    try {
      var selectedEvent = await _eventRepository.getEventFromRef(
          await _eventRepository.getEventDocFromID(event.eventId));
      _eventRepository.registerTeamForEvent(selectedEvent, event.selectedSlot,
          (await _userRepository.getCurrentUserDetail()).joinedTeam);
      yield EventRegistrationSuccess();
    } catch (error) {
      yield EventRegistrationFailure();
    }
  }

  Stream<HomeScreenState> _mapEventSelectedToState(EventSelected event) async* {
    yield CheckingUserDetails();
    bool isProfileComplete = await _userRepository.isUserProfileComplete();
    if ((!isProfileComplete)) {
      //check if the user details are available before loading events
      yield MissingUserDetails();
    } else {
      yield ShowSlotDialog(eventID: event.eventID);
    }
  }

  Stream<HomeScreenState> _mapInitialEventState(HomeScreenEvent event) async* {
    Future<CosmoEventUIModel> mapToUIModel(CosmoGameEvent event) async {
      return CosmoEventUIModel(
          event: event,
          isRegistered:
              (await _userRepository.isRegisteredWithEvent(event.eventID))
                  .keys
                  .toList()[0]);
    }

    try {
      yield AvailableEventsLoading();
      var availableEvents = await _eventRepository.getAvailableEvent();
      var events = await Future.wait(availableEvents.map(mapToUIModel));

      yield AvailableEventsSuccess(availableEvents: events);
    } catch (error) {
      print("available_events_fetch_failed: $error");
      yield AvailableEventsFailure();
    }
  }

  void _mapUpdateFcmCodeEvent(UpdateFcmCode event) async {
    _userRepository.updateUserFcmCode(event.fcmCode);
  }

  _mapNotificationEvent(EventNotificationReceived event) async {
    try {
      await _eventRepository.addEventDetailsToDatabase(EventNotification(
          eventId: int.parse(event.eventId) ?? 0,
          roomID: event.roomId,
          roomPassword: event.roomPassword));
    } catch (error) {
      print("notification error $error");
    }
  }

  Stream<HomeScreenState> _mapRegistrationDialogOpened(
      EventRegistrationDialogOpened event) async* {
    yield SelectedEventDetailLoading();
    try {
      var registrationDetail =
          await _userRepository.isRegisteredWithEvent(event.eventID);
      var eventDetail = await _eventRepository.getEventDetailFromId(
          event.eventID,
          registrationDetail.keys.toList()[0],
          registrationDetail.values.toList()[0]);
      yield SelectedEventDetailLoaded(eventDetail: eventDetail);
    } catch (error) {
      print(error);
      yield SelectedEventDetailFailure();
    }
  }

  Stream<HomeScreenState> _mapRegistrationCancellation(
      RegistrationCancelled event) async* {
    yield CancellingRegistration();
    try {
      var user = await _userRepository.getCurrentUserDetail();
      await _eventRepository.removeTeamFromEvent(
          event.eventID, user.joinedTeam);
      yield CancellationSuccess();
    } catch (error) {
      yield CancellationFailure();
    }
  }
}
