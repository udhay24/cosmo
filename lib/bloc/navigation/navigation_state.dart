import 'package:equatable/equatable.dart';

abstract class NavigationState extends Equatable {
  const NavigationState();
}

class InitialNavigationState extends NavigationState {
  @override
  List<Object> get props => [];
}
