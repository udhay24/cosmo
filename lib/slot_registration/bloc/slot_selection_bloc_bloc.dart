import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class SlotSelectionBlocBloc extends Bloc<SlotSelectionBlocEvent, SlotSelectionBlocState> {
  @override
  SlotSelectionBlocState get initialState => InitialSlotSelectionBlocState();

  @override
  Stream<SlotSelectionBlocState> mapEventToState(
    SlotSelectionBlocEvent event,
  ) async* {

  }
}
