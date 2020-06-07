import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  @override
  HomeScreenState get initialState => InitialHomeScreenState();

  @override
  Stream<HomeScreenState> mapEventToState(
    HomeScreenEvent event,
  ) async* {

  }
}
