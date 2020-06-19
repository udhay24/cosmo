import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:pubg/data_source/event_repository.dart';
import 'package:pubg/data_source/model/event_notification.dart';
import 'package:pubg/event_notification/model/notification_model.dart';

import './bloc.dart';

class EventNotificationBloc
    extends Bloc<EventNotificationEvent, EventNotificationState> {
  @override
  EventNotificationState get initialState => InitialEventNotificationState();

  final EventRepository _eventRepository;

  EventNotificationBloc({@required EventRepository repository})
      : assert(repository != null),
        _eventRepository = repository;

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
      var eventNotifications = await _eventRepository.getAllNotificationEvent();
      var notifications = List<NotificationModel>();
      await Future.forEach(eventNotifications, (e) async {
        var event = await _eventRepository.getEventInfoFromID(e.eventId);
        notifications.add(NotificationModel(
            eventName: event.eventName,
            roomID: e.roomID,
            roomPassword: e.roomPassword,
            eventDescription: event.eventDescription));
      });

      yield EventNotificationLoadedState(eventNotifications: notifications);
    } catch (error) {
      print("notify - $error}");
      yield EventNotificationFailureState();
    }
  }
}
