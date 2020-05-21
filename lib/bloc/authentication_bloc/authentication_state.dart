import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];

}

class Uninitialized extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final String userName;

  const Authenticated(this.userName);

  @override
  List<Object> get props => [userName];

  @override
  String toString() {
    return "Authenticated: welcome $userName}";
  }
}

class UnAuthenticated extends AuthenticationState { }