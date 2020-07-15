import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class HomeScreenEvent extends Equatable {
  const HomeScreenEvent();
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
