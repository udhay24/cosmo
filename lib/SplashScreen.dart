import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {

  final Future<FirebaseUser> _user = FirebaseAuth.instance.currentUser();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Builder(builder: (context) {
          _user.then((value) {
            if (value == null) {
              Navigator.of(context).pushNamed('/sign');
            } else {
              Navigator.of(context).pushNamed('/home');
            }
          });
          return Center(
            child: Column(
              children: <Widget>[
                CircularProgressIndicator(),
                Text("Loading")
              ],
            ),
          );
        })
      ),
    );
  }
}
