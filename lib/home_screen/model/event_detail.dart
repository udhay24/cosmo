import 'package:flutter/cupertino.dart';
import 'package:pubg/data_source/model/available_event.dart';

class SelectedEventDetail {
  final CosmoGameEvent event;
  final Stream<List<int>> availableSlots;

  SelectedEventDetail({
    @required this.event,
    @required this.availableSlots,
  });
}

class CosmoEventUIModel {
  final CosmoGameEvent event;
  final bool isRegistered;

  CosmoEventUIModel({@required this.event, @required this.isRegistered});
}
