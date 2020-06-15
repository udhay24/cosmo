import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/util/routes_const.dart';

import './bloc.dart';

class NavigationBloc extends Bloc<NavigationEvent, dynamic> {
  final GlobalKey<NavigatorState> navigatorKey;

  NavigationBloc({this.navigatorKey});

  @override
  dynamic get initialState => 0;

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
          .pushNamed(ScreenRoutes.TEAM_DETAIL_SCREEN_ROUTE);
    } else if (event is TeamDetailViewNavigationEvent) {
      navigatorKey.currentState
          .pushNamed(ScreenRoutes.TEAM_DETAIL_VIEW_SCREEN_ROUTE);
    }
  }
}
