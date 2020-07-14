import 'package:flutter/cupertino.dart';
import 'package:pubg/data_source/model/available_event.dart';

class SelectedEventDetail {
  final CosmoGameEvent event;
  final Stream<List<int>> availableSlots;
  final bool isRegistered;
  final int previousSelectedSlot;

  SelectedEventDetail(
      {@required this.event,
      @required this.availableSlots,
      @required this.isRegistered,
      @required this.previousSelectedSlot});
}

class CosmoEventUIModel {
  final CosmoGameEvent event;
  final bool isRegistered;

  CosmoEventUIModel({@required this.event, @required this.isRegistered});
}
