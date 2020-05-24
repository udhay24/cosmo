import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:pubg/data_source/firestore_repository.dart';
import 'package:pubg/data_source/repository_di.dart';

import 'bloc.dart';

class SlotSelectionBloc extends Bloc<SlotSelectionEvent, SlotSelectionState> {
  final FireStoreRepository _fireStoreRepository =
      RepositoryInjector.fireStoreRepository;

  @override
  SlotSelectionState get initialState => InitialSlotSelectionState();

  @override
  Stream<SlotSelectionState> mapEventToState(
    SlotSelectionEvent event,
  ) async* {
    if (event is TimingSelected) {
      yield* _mapTimingSelectedEvent(event);
    } else if (event is SlotSelected) {
      yield* _mapSlotSelectedEvent(event);
    }
  }

  Stream<SlotSelectionState> _mapTimingSelectedEvent(
      TimingSelected event) async* {
    var isUserDetailsAvailable = await _fireStoreRepository.containsTeamDetails();
    if (isUserDetailsAvailable) {
      var availableSlots =
          await _fireStoreRepository.getAvailableSlots(event.selectedTiming);
      yield ShowSlotDialog(availableSlots: availableSlots);
    } else {
      yield TeamDetailsMissing();
    }
  }

  Stream<SlotSelectionState> _mapSlotSelectedEvent(SlotSelected event) async* {
    yield SelectedSlotSubmitting();
    try {
      yield await _fireStoreRepository
          .selectSlot(event.selectedSlot, event.selectedTiming)
          .then((value) {
        return SelectedSlotSuccess();
      }, onError: () {
        return SelectedSlotFailure();
      });
    } catch (_) {
      yield SelectedSlotFailure();
    }
  }
}
