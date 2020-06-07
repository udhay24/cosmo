import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/SplashScreen.dart';
import 'package:pubg/data_source/login_repository.dart';
import 'package:pubg/home_screen/bloc/home_screen_bloc.dart';
import 'package:pubg/home_screen/ui/home_screen.dart';
import 'package:pubg/login/bloc/bloc.dart';
import 'package:pubg/login/ui/login_screen.dart';
import 'package:pubg/register/bloc/bloc.dart';
import 'package:pubg/register/ui/register_screen.dart';

class ScreenRoutes {
  static const String SPLASH_SCREEN_ROUTE = "/splash";
  static const String LOGIN_SCREEN_ROUTE = "/login";
  static const String REGISTER_SCREEN_ROUTE = "/register";
  static const String USER_PROFILE_SCREEN_ROUTE = "/user_profile";
  static const String TEAM_CREATION_SCREEN_ROUTE = "/create_team";
  static const String JOIN_TEAM_ROUTE = "/join_team";
  static const String HOME_SCREEN_ROUTE = "/home_Screen";
}

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case ScreenRoutes.SPLASH_SCREEN_ROUTE:
      return MaterialPageRoute(builder: (context) => SplashScreen());

    case ScreenRoutes.LOGIN_SCREEN_ROUTE:
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
              create: (context) => LoginBloc(
                  loginRepository:
                      RepositoryProvider.of<LoginRepository>(context)),
              child: LoginScreen()));

    case ScreenRoutes.REGISTER_SCREEN_ROUTE:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => RegisterBloc(
              loginRepository: RepositoryProvider.of<LoginRepository>(context)),
          child: RegisterScreen(),
        ),
      );

    case ScreenRoutes.HOME_SCREEN_ROUTE:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => HomeScreenBloc(),
          child: HomeScreen(),
        ),
      );


    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
  }
}
