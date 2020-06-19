import 'package:flutter/cupertino.dart';

class EventNotification {
  final int eventId;
  final String roomID;
  final String roomPassword;

  EventNotification(
      {@required this.eventId,
      @required this.roomID,
      @required this.roomPassword});

  Map<String, dynamic> toMap() {
    return {
      'event_id': eventId,
      'room_id': roomID,
      'room_password': roomPassword
    };
  }

  factory EventNotification.fromJson(Map<String, dynamic> map) {
    return EventNotification(
        eventId: map['event_id'],
        roomID: map['room_id'],
        roomPassword: map['room_password']);
  }
}
