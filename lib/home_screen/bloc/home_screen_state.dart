import 'package:equatable/equatable.dart';

abstract class HomeScreenState extends Equatable {
  const HomeScreenState();
}

class InitialHomeScreenState extends HomeScreenState {
  @override
  List<Object> get props => [];
}
