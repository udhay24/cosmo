import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/data_source/login_repository.dart';
import 'package:pubg/register/bloc/register_bloc.dart';
import 'package:pubg/register/ui/register_form.dart';

class RegisterScreen extends StatelessWidget {
  final LoginRepository _userRepository;

  RegisterScreen({Key key, @required LoginRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

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
              "images/pubg_background_registration_screen.jpg"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.red, BlendMode.darken),
        )),
        child: BlocProvider<RegisterBloc>(
            create: (context) => RegisterBloc(userRepository: _userRepository),
            child: RegisterForm(),
        ),
        alignment: Alignment.center,
      ),
    );
  }
}
