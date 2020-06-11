import 'package:equatable/equatable.dart';

abstract class HomeScreenEvent extends Equatable {
  const HomeScreenEvent();
}


class HomeScreenStarted extends HomeScreenEvent {
  @override
  List<Object> get props => [];
}


class EventSelected extends HomeScreenEvent {
  @override
  List<Object> get props => [];
}
