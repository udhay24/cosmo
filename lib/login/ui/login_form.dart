import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pubg/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:pubg/bloc/authentication_bloc/authentication_event.dart';
import 'package:pubg/data_source/login_repository.dart';
import 'package:pubg/login/bloc/bloc.dart';
import 'package:pubg/login/ui/create_account_button.dart';
import 'package:pubg/util/themes.dart';

import 'google_login_button.dart';
import 'login_button.dart';

class LoginForm extends StatefulWidget {

  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginBloc _loginBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Login Failure'), Icon(Icons.error)],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Logging In...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return SizedBox.expand(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 40,
                                height: 5,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      color: Themes.COLOR_PRIMARY),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Cosmo",
                                style: GoogleFonts.openSans(
                                    color: Colors.white,
                                    letterSpacing: 1.3,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24),
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 12),
                            child: Text(
                              "Login",
                              style: GoogleFonts.openSansCondensed(
                                  fontSize: 36,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 40),
                            child: const SizedBox(
                              width: 60,
                              height: 5,
                              child: DecoratedBox(
                                decoration: BoxDecoration(color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            controller: _emailController,
                            style: GoogleFonts.poppins(color: Colors.white),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.white,
                              ),
                              labelText: 'Email',
                              fillColor: Colors.white,
                              labelStyle: GoogleFonts.abel(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              errorStyle: GoogleFonts.abel(color: Colors.white),
                              border: new UnderlineInputBorder(
                                borderRadius: new BorderRadius.circular(4.0),
                                borderSide: new BorderSide(),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autovalidate: true,
                            autocorrect: false,
                            cursorColor: Colors.white,
                            validator: (_) {
                              return !state.isEmailValid
                                  ? 'Invalid Email'
                                  : null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _passwordController,
                            style: GoogleFonts.poppins(color: Colors.white),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock, color: Colors.white),
                              labelText: 'Password',
                              fillColor: Colors.white,
                              labelStyle: GoogleFonts.abel(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              errorStyle: GoogleFonts.abel(color: Colors.white),
                            ),
                            obscureText: true,
                            autovalidate: true,
                            autocorrect: false,
                            validator: (_) {
                              return !state.isPasswordValid
                                  ? 'Invalid Password'
                                  : null;
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                LoginButton(
                                  onPressed: isLoginButtonEnabled(state)
                                      ? _onFormSubmitted
                                      : null,
                                ),
                                GoogleLoginButton(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  left: 30,
                  child: CreateAccountButton(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _loginBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _loginBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _loginBloc.add(
      LoginWithCredentialsPressed(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}
