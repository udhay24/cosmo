import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:pubg/bloc/authentication_bloc/authentication_state.dart';
import 'package:pubg/data_source/repository_di.dart';
import 'package:pubg/data_source/user_repository.dart';
import 'package:pubg/slot_registration/ui/slot_selection_screen.dart';
import 'package:pubg/team_detail/ui/team_detail_screen.dart';

import 'SplashScreen.dart';
import 'bloc/authentication_bloc/authentication_event.dart';
import 'bloc/bloc_delegate.dart';
import 'home_screen.dart';
import 'login/ui/SignInScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final UserRepository userRepository = RepositoryInjector.userRepository;
  runApp(
    BlocProvider(
      create: (context) =>
          AuthenticationBloc(userRepository: userRepository)..add(AppStarted()),
      child: App(userRepository: userRepository),
    ),
  );
}

class App extends StatelessWidget {
  final UserRepository _userRepository;

  App({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Uninitialized) {
            return SplashScreen();
          }
          if (state is UnAuthenticated) {
            return LoginScreen(userRepository: _userRepository);
          }
          if (state is Authenticated) {
            return SlotSelectionScreen();
          }
          return Container();
        },
      ),
    );
  }
}
