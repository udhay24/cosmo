import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:pubg/data_source/event_repository.dart';
import 'package:pubg/data_source/model/available_event.dart';
import 'package:pubg/data_source/user_repository.dart';
import 'package:pubg/event_notification/model/notification_model.dart';

import './bloc.dart';

class EventNotificationBloc
    extends Bloc<EventNotificationEvent, EventNotificationState> {
  final EventRepository _eventRepository;
  final UserRepository _userRepository;

  EventNotificationBloc(
      {@required EventRepository repository,
      @required UserRepository userRepository})
      : assert(repository != null),
        _eventRepository = repository,
        _userRepository = userRepository,
        super(InitialEventNotificationState());

  @override
  Stream<EventNotificationState> mapEventToState(
    EventNotificationEvent event,
  ) async* {
    if (event is LoadEventNotifications) {
      yield* _mapLoadNotificationsEvent(event);
    }
  }

  Stream<EventNotificationState> _mapLoadNotificationsEvent(
      LoadEventNotifications event) async* {
    yield LoadingEventNotifications();
    try {
      var user = await _userRepository.getCurrentUserDetail();
      var eventDetails = await _eventRepository.getRoomDetails(user.joinedTeam);

      var eventNotifications =
      await Future.wait(eventDetails.map((e) => convertToNotification(e)));

      if (eventDetails != null) {
        yield EventNotificationLoadedState(
            eventNotifications: eventNotifications);
      } else {
        yield EventNotificationFailureState();
      }
    } catch (error) {
      print("notify - $error}");
      yield EventNotificationFailureState();
    }
  }

  Future<NotificationModel> convertToNotification(RoomDetail roomDetail) async {
    var event = await _eventRepository.getEventInfoFromID(roomDetail.eventID);
    var date = roomDetail.time.toDate();
    return NotificationModel(
        eventName: event.eventName,
        roomID: roomDetail.roomID,
        roomPassword: roomDetail.roomPassword,
        eventDescription: event.eventDescription,
        time: "${date.day}/${date.month}/${date.year}");
  }
}
