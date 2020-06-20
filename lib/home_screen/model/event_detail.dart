import 'package:flutter/cupertino.dart';
import 'package:pubg/data_source/model/available_event.dart';

class EventDetail {
  final AvailableEvent event;
  final bool isRegistrationOpen;
  final List<int> availableSlots;

  EventDetail(
      {@required this.event,
      @required this.availableSlots,
      @required this.isRegistrationOpen});
}
