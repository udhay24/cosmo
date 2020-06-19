import 'package:flutter/material.dart';

class NotificationModel {
  final String eventName;
  final String eventDescription;
  final String roomID;
  final String roomPassword;

  NotificationModel({
    @required this.eventName,
    @required this.roomID,
    @required this.roomPassword,
    @required this.eventDescription,
  });
}
