//import 'dart:async';
//
//import 'package:bloc/bloc.dart';
//import 'package:pubg/data_source/firestore_repository.dart';
//import 'package:pubg/data_source/repository_di.dart';
//import 'package:pubg/data_source/user_repository.dart';
//
//import 'bloc.dart';
//
//class SlotSelectionBloc extends Bloc<SlotSelectionEvent, SlotSelectionState> {
// UserRepository _userRepository;
//
//
//  @override
//  SlotSelectionState get initialState => InitialSlotSelectionState();
//
//  @override
//  Stream<SlotSelectionState> mapEventToState(
//    SlotSelectionEvent event,
//  ) async* {
// if (event is SlotSelected) {
//      yield* _mapSlotSelectedEvent(event);
//    }
//  }
//
//  Stream<SlotSelectionState> _mapSlotSelectedEvent(SlotSelected event) async* {
//    yield SelectedSlotSubmitting();
//    try {
//      yield await _fireStoreRepository
//          .selectSlot(event.selectedSlot, event.selectedTiming)
//          .then((value) {
//        return SelectedSlotSuccess();
//      }, onError: (_) {
//        return SelectedSlotFailure();
//      });
//    } catch (_) {
//      yield SelectedSlotFailure();
//    }
//  }
//}
