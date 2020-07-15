import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pubg/data_source/event_repository.dart';
import 'package:pubg/data_source/model/available_event.dart';
import 'package:pubg/data_source/user_repository.dart';
import 'package:pubg/events_screen/model/event_detail.dart';

part 'cosmo_events_event.dart';
part 'cosmo_events_state.dart';

class CosmoEventsBloc extends Bloc<CosmoEventsEvent, CosmoEventsState> {
  final UserRepository _userRepository;
  final EventRepository _eventRepository;

  CosmoEventsBloc(
      {@required EventRepository eventRepository,
      @required UserRepository userRepository})
      : assert(eventRepository != null && userRepository != null),
        _eventRepository = eventRepository,
        _userRepository = userRepository,
        super(CosmoEventsInitial());

  @override
  Stream<CosmoEventsState> mapEventToState(
    CosmoEventsEvent event,
  ) async* {
    if (event is LoadAvailableEvents) {
      yield* _mapAvailableEventState(event);
    } else if (event is EventSelected) {
      yield* _mapEventSelectedToState(event);
    } else if (event is SlotSelected) {
      yield* _mapSlotSelectedEvent(event);
    } else if (event is EventRegistrationDialogOpened) {
      yield* _mapRegistrationDialogOpened(event);
    } else if (event is RegistrationCancelled) {
      yield* _mapRegistrationCancellation(event);
    }
  }

  Stream<CosmoEventsState> _mapAvailableEventState(
      CosmoEventsEvent event) async* {
    Future<CosmoEventUIModel> mapToUIModel(CosmoGameEvent event) async {
      var eventRegistration =
          await _userRepository.isRegisteredWithEvent(event.eventID);
      return CosmoEventUIModel(
          event: event,
          isRegistered: eventRegistration.keys.toList()[0],
          previousSelectedSlot: eventRegistration.values.toList()[0]);
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

  Stream<CosmoEventsState> _mapSlotSelectedEvent(SlotSelected event) async* {
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

  Stream<CosmoEventsState> _mapEventSelectedToState(
      EventSelected event) async* {
    yield CheckingUserDetails();
    bool isProfileComplete = await _userRepository.isUserProfileComplete();
    if ((!isProfileComplete)) {
      //check if the user details are available before loading events
      yield MissingUserDetails();
    } else {
      yield ShowSlotDialog(eventID: event.eventID);
    }
  }

  Stream<CosmoEventsState> _mapRegistrationDialogOpened(
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

  Stream<CosmoEventsState> _mapRegistrationCancellation(
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
