import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CosmoGameEvent {
  String eventName;
  String eventDescription;
  int eventID;

  CosmoGameEvent({this.eventName, this.eventDescription});

  CosmoGameEvent.fromJson(Map<String, dynamic> json) {
    eventName = json['event_name'];
    eventDescription = json['event_description'];
    eventID = json['event_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_name'] = this.eventName;
    data['event_description'] = this.eventDescription;
    data['event_id'] = this.eventID;
    return data;
  }
}

class RoomDetail {
  int eventID;
  String roomID;
  String roomPassword;
  Timestamp time;

  RoomDetail(
      {this.roomID,
      this.roomPassword,
      @required this.time,
      @required this.eventID});

  RoomDetail.fromJson(Map<String, dynamic> json) {
    roomID = json['room_id'];
    roomPassword = json['room_password'];
    time = json['time'];
    eventID = json['event_id'];
  }
}