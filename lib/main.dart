import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:pubg/bloc/authentication_bloc/authentication_state.dart';
import 'package:pubg/bloc/navigation/bloc.dart';
import 'package:pubg/data_source/login_repository.dart';
import 'package:pubg/data_source/user_repository.dart';
import 'package:pubg/bloc/navigation/routes_const.dart';

import 'bloc/authentication_bloc/authentication_event.dart';
import 'bloc/bloc_delegate.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final LoginRepository loginRepository = LoginRepository();

  final GlobalKey<NavigatorState> _navigationKey = GlobalKey();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<LoginRepository>(
          create: (context) => loginRepository,
        ),
        RepositoryProvider<UserRepository>(
          create: (context) => UserRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (context) =>
                AuthenticationBloc(userRepository: loginRepository)
          ),
          BlocProvider<NavigationBloc>(
            create: (context) => NavigationBloc(navigatorKey: _navigationKey),
          )
        ],
        child: App(),
      ),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return MaterialApp(
          title: "Cosmo",
          navigatorKey: BlocProvider.of<NavigationBloc>(context).navigatorKey,
          onGenerateRoute: generateRoute,
          initialRoute: ScreenRoutes.SPLASH_SCREEN_ROUTE,
        );
      },
      listener: (context, state) {
        if (state is Authenticated) {
          BlocProvider.of<NavigationBloc>(context).add(HomeScreenNavigateEvent());
        } else if (state is UnAuthenticated) {
          BlocProvider.of<NavigationBloc>(context).add(LoginNavigateEvent());
        }
      },
    );
  }
}
