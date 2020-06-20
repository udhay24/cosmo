import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:pubg/bloc/authentication_bloc/authentication_event.dart';
import 'package:pubg/data_source/login_repository.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Timer _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
        decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
                image: AssetImage('assets/images/cosmo_logo.jpeg'))),
        child: Center(
          child: FutureBuilder(
              future:
                  RepositoryProvider.of<LoginRepository>(context).isSignedIn(),
              builder: (context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasData) {
                  if ((snapshot.data != null) && (snapshot.data)) {
                    _launchEvent(context, LoggedIn());
                  } else {
                    _launchEvent(context, LoggedOut());
                  }
                  return Container();
                } else if (snapshot.hasError) {
                  return Text("Error  splash screen");
                } else {
                  return Container();
                }
              }),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: Align(
          alignment: Alignment.bottomCenter,
          child:
              SizedBox(height: 2, width: 90, child: LinearProgressIndicator()),
        ),
      )
    ]));
  }

  _launchEvent(BuildContext context, AuthenticationEvent event) {
    _timer = Timer(Duration(seconds: 2),
        () => BlocProvider.of<AuthenticationBloc>(context).add(event));
  }
}
