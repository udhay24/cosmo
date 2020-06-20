import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoInternetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Lottie.asset('assets/lottie/no-internet-connection-empty-state.json'),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text("Something went wrong"),
        )
      ],
    );
  }
}
