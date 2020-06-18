import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:pubg/data_source/event_repository.dart';
import 'package:pubg/data_source/user_repository.dart';

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
    }
  }

  Stream<HomeScreenState> _mapSlotSelectedEvent(SlotSelected event) async* {
    try {
      var selectedEvent = await _userRepository.getEventFromRef(
          await _userRepository.getEventDocFromID(event.eventId));
      _userRepository.registerTeamForEvent(selectedEvent, event.selectedSlot);
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
    try {
      yield AvailableEventsLoading();
      var availableEvents = await _eventRepository.getAvailableEvent();
      yield AvailableEventsSuccess(availableEvents: availableEvents);
    } catch (error) {
      print("available_events_fetch_failed: $error");
      yield AvailableEventsFailure();
    }
  }

  void _mapUpdateFcmCodeEvent(UpdateFcmCode event) async {
    _userRepository.updateUserFcmCode(event.fcmCode);
  }
}
