import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/SplashScreen.dart';
import 'package:pubg/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:pubg/bloc/authentication_bloc/authentication_event.dart';
import 'package:pubg/bloc/bloc_delegate.dart';
import 'package:pubg/data_source/user_repository.dart';
import 'package:pubg/user/PersonalDetailScreen.dart';
import 'package:pubg/user/SignInScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final UserRepository userRepository = UserRepository();
  BlocSupervisor.delegate = SimpleBlocDelegate();

  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc(userRepository)..add(AppStarted()),
      child: MyApp(userRepository: userRepository),
    )
  );
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository;

  MyApp({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cosmo pubg',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/sign': (context) => SignInScreen(),
        '/home': (context) => MyHomePage(),
        '/detail': (context) => EnterDetailsScreen(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  FirebaseAuth _auth;
  Future<FirebaseUser> _user;

  MyHomePage() {
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: FutureBuilder(
        future: _user,
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            children = <Widget>[
              Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Welcome: ${snapshot.data.displayName}'),
              )
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          } else {
            if (snapshot.connectionState == ConnectionState.done && snapshot.data == null) {
              return SignInScreen();
            }
            children = <Widget>[
              SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              )
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
    ));
  }
}
