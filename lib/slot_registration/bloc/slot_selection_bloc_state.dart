import 'package:equatable/equatable.dart';

abstract class SlotSelectionBlocState extends Equatable {
  const SlotSelectionBlocState();
}

class InitialSlotSelectionBlocState extends SlotSelectionBlocState {
  @override
  List<Object> get props => [];
}

