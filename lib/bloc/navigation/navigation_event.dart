import 'package:equatable/equatable.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();
}

class NavigatorActionPop extends NavigationEvent{
  @override
  List<Object> get props => [];
}

class LoginNavigateEvent extends NavigationEvent{
  @override
  List<Object> get props => [];
}

class RegistrationNavigateEvent extends NavigationEvent{
  @override
  List<Object> get props => [];
}

class UserProfileNavigateEvent extends NavigationEvent {
  @override
  List<Object> get props => [];
}

class HomeScreenNavigateEvent extends NavigationEvent {
  @override
  List<Object> get props => [];
}

class CreateTeamNavigationEvent extends NavigationEvent {
  @override
  List<Object> get props => [];
}

class JoinTeamNavigationEvent extends NavigationEvent {
  @override
  List<Object> get props => [];
}

class TeamDetailNavigationEvent extends NavigationEvent {
  @override
  List<Object> get props => [];
}

class TeamDetailViewNavigationEvent extends NavigationEvent {
  @override
  List<Object> get props => [];
}

class SlotSelectionNavigationEvent extends NavigationEvent {
  @override
  List<Object> get props => [];
}