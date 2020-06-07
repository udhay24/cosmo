import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:pubg/bloc/authentication_bloc/authentication_event.dart';
import 'package:pubg/bloc/authentication_bloc/authentication_state.dart';
import 'package:pubg/bloc/navigation/bloc.dart';
import 'package:pubg/login/bloc/bloc.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Text("Home Screen")),

            SizedBox(height: 10,),

            RaisedButton(onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(
                LoggedOut()
              );
            },
            child: Text("Log out"),)
          ],
        ),
      )
    );
  }
}
