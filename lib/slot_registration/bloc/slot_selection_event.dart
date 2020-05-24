import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class SlotSelectionEvent extends Equatable {
  const SlotSelectionEvent();
}

class TimingSelected extends SlotSelectionEvent{
  final String selectedTiming;

  TimingSelected({@required this.selectedTiming});

  @override
  List<Object> get props => [selectedTiming];
}

class SlotSelected extends SlotSelectionEvent {
  final String selectedTiming;
  final int selectedSlot;

  SlotSelected({@required this.selectedSlot, @required this.selectedTiming});

  @override
  List<Object> get props => [selectedSlot, selectedTiming];
}
