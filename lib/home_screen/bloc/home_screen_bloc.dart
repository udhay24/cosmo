import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:pubg/data_source/event_repository.dart';
import 'package:pubg/data_source/model/event_notification.dart';
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
        _eventRepository = eventRepository,
        super(InitialHomeScreenState());

  @override
  Stream<HomeScreenState> mapEventToState(
    HomeScreenEvent event,
  ) async* {
    if (event is UpdateFcmCode) {
      _mapUpdateFcmCodeEvent(event);
    } else if (event is EventNotificationReceived) {
      _mapNotificationEvent(event);
    }
  }

  Stream<HomeScreenState> _mapInitialEventState(HomeScreenEvent event) async* {

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
}
