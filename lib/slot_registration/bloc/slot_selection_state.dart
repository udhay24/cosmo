import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pubg/util/available_slot.dart';

abstract class SlotSelectionState extends Equatable {
  const SlotSelectionState();
}

class InitialSlotSelectionState extends SlotSelectionState {
  final List<String> availableTimings = [AvailableSlots.SLOT_AT_6, AvailableSlots.SLOT_AT_10];
  @override
  List<Object> get props => [availableTimings];
}

class ShowSlotDialog extends SlotSelectionState {
  final List<int> availableSlots;

  ShowSlotDialog({@required this.availableSlots});

  @override
  List<Object> get props => [availableSlots];
}

class TeamDetailsMissing extends SlotSelectionState {
  @override
  List<Object> get props => [];
}

class SelectedSlotSubmitting extends SlotSelectionState {
  @override
  List<Object> get props => [];
}

class SelectedSlotSuccess extends SlotSelectionState {
  @override
  List<Object> get props => [];
}

class SelectedSlotFailure extends SlotSelectionState {
  @override
  List<Object> get props => [];
}

