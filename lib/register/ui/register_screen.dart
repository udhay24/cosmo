import 'package:flutter/material.dart';
import 'package:pubg/register/ui/register_form.dart';

class RegisterScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
          title: Text(
            'Register',
            style: TextStyle(color: Colors.white),
          ),
        backgroundColor: Colors.transparent,
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(
              "assets/images/pubg_background_registration_screen.jpg"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.red, BlendMode.darken),
        )),
        child:RegisterForm(),
        alignment: Alignment.center,
      ),
    );
  }
}
