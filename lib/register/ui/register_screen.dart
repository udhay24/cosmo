import 'package:flutter/material.dart';
import 'package:pubg/register/ui/register_form.dart';
import 'package:pubg/util/themes.dart';

class RegisterScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.COLOR_WHITE),
        title: Text(
          'Register',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
              "assets/images/pubg_background_registration_screen.jpg"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.grey.shade500, BlendMode.darken),
        )),
        child:RegisterForm(),
      ),
    );
  }
}
