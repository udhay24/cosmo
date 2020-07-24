import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'profile_screen_event.dart';

part 'profile_screen_state.dart';

class ProfileScreenBloc extends Bloc<ProfileScreenEvent, ProfileScreenState> {
  ProfileScreenBloc() : super(ProfileScreenInitial());

  @override
  Stream<ProfileScreenState> mapEventToState(
    ProfileScreenEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
