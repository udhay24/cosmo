import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:pubg/bloc/authentication_bloc/authentication_event.dart';
import 'package:pubg/bloc/navigation/bloc.dart';
import 'package:pubg/data_source/login_repository.dart';
import 'package:pubg/util/notification_util.dart';

class SplashScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: RepositoryProvider.of<LoginRepository>(context).isSignedIn(),
            builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            if ((snapshot.data != null) && (snapshot.data)) {
              BlocProvider.of<AuthenticationBloc>(context).add(
                  LoggedIn());
            } else {
              BlocProvider.of<AuthenticationBloc>(context).add(
                  LoggedOut());
            }
            return Container();
          } else if (snapshot.hasError) {
            return Text("Error  splash screen");
          } else {
            return Text("Loading splash screen...");
          }
        }),
      ),
    );
  }
}
