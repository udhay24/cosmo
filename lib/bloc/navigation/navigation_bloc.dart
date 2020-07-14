import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/bloc/navigation/routes_const.dart';

import './bloc.dart';

class NavigationBloc extends Bloc<NavigationEvent, dynamic> {
  final GlobalKey<NavigatorState> navigatorKey;

  NavigationBloc({this.navigatorKey}) : super(0);

  @override
  Stream<dynamic> mapEventToState(NavigationEvent event) async* {
    if (event is NavigatorActionPop) {
      navigatorKey.currentState.pop();
    } else if (event is HomeScreenNavigateEvent) {
      navigatorKey.currentState.pushNamedAndRemoveUntil(ScreenRoutes.HOME_SCREEN_ROUTE, (predicate) => false);
    } else if (event is LoginNavigateEvent) {
      navigatorKey.currentState.pushNamedAndRemoveUntil(
          ScreenRoutes.LOGIN_SCREEN_ROUTE, (predicate) => false);
    } else if (event is RegistrationNavigateEvent) {
      navigatorKey.currentState.pushNamed(ScreenRoutes.REGISTER_SCREEN_ROUTE);
    } else if (event is UserProfileNavigateEvent) {
      navigatorKey.currentState
          .pushNamed(ScreenRoutes.USER_PROFILE_SCREEN_ROUTE);
    } else if (event is SlotSelectionNavigationEvent) {
      navigatorKey.currentState
          .pushNamed(ScreenRoutes.SLOT_SELECTION_SCREEN_ROUTE);
    } else if (event is TeamDetailNavigationEvent) {
      navigatorKey.currentState
          .pushNamed(ScreenRoutes.TEAM_DETAIL_SCREEN_ROUTE, arguments: event.isFormEditable);
    } else if (event is AboutScreenNavigationEvent) {
      navigatorKey.currentState.pushNamed(ScreenRoutes.ABOUT_SCREEN_ROUTE);
    } else if (event is EventNotificationsNavigationEvent) {
      navigatorKey.currentState
          .pushNamed(ScreenRoutes.EVENT_NOTIFICATION_SCREEN_ROUTE);
    } else if (event is ThirdPartyScreenNavigationEvent) {
      navigatorKey.currentState
          .pushNamed(ScreenRoutes.THIRD_PARTY_SCREEN_ROUTE);
    }
  }
}
