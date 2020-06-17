import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class HomeScreenEvent extends Equatable {
  const HomeScreenEvent();
}

class HomeScreenStarted extends HomeScreenEvent {
  @override
  List<Object> get props => [];
}

class EventSelected extends HomeScreenEvent {
  final String eventID;

  EventSelected({@required this.eventID});

  @override
  List<Object> get props => [eventID];
}

class SlotSelected extends HomeScreenEvent {
  final String eventId;
  final int selectedSlot;
  SlotSelected({@required this.selectedSlot, @required this.eventId});

  @override
  List<Object> get props => [selectedSlot, eventId];
}