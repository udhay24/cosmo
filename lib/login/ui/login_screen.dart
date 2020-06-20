import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/data_source/login_repository.dart';
import 'package:pubg/login/bloc/login_bloc.dart';

import 'login_form.dart';

class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                    "assets/images/pubg_background.jpg", ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.redAccent, BlendMode.darken,),
            )),
        child:  LoginForm(),
        alignment: Alignment.center,
      ),
    );
  }
}
