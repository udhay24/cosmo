import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pubg/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:pubg/bloc/authentication_bloc/authentication_event.dart';
import 'package:pubg/register/bloc/register_bloc.dart';
import 'package:pubg/register/bloc/register_event.dart';
import 'package:pubg/register/bloc/register_state.dart';
import 'package:pubg/register/ui/register_button.dart';
import 'package:pubg/util/validators.dart';

class RegisterForm extends StatefulWidget {
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  var doesPasswordsMatch = false;

  RegisterBloc _registerBloc;

  var passwordVisible = true;

  final GlobalKey<FormState> _formKey = GlobalKey();
  var _submitEnabled = false;

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Registering...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        }
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Registration Failure'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  onChanged: () => setState(
                      () => _submitEnabled = _formKey.currentState.validate()),
                  child: ListView(
                    children: <Widget>[
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
                              color: Colors.white, fontWeight: FontWeight.bold),
                          errorStyle: GoogleFonts.abel(color: Colors.white),
                          border: new UnderlineInputBorder(
                            borderRadius: new BorderRadius.circular(4.0),
                            borderSide: new BorderSide(),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        autovalidate: true,
                        validator: (value) {
                          return !Validators.isValidEmail(value)
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
                          suffixIcon: IconButton(
                            icon: Icon(
                              passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                          ),
                          prefixIcon: Icon(Icons.lock, color: Colors.white),
                          labelText: 'Password',
                          fillColor: Colors.white,
                          labelStyle: GoogleFonts.abel(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          errorStyle: GoogleFonts.abel(color: Colors.white),
                        ),
                        obscureText: passwordVisible,
                        autocorrect: false,
                        autovalidate: true,
                        validator: (value) {
                          return !Validators.isValidPassword(value)
                              ? 'Invalid Password'
                              : null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        style: GoogleFonts.poppins(color: Colors.white),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                          ),
                          prefixIcon: Icon(Icons.lock, color: Colors.white),
                          labelText: 'Re-enter Password',
                          fillColor: Colors.white,
                          labelStyle: GoogleFonts.abel(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          errorStyle: GoogleFonts.abel(color: Colors.white),
                        ),
                        obscureText: passwordVisible,
                        autocorrect: false,
                        autovalidate: true,
                        onChanged: (value) {
                          if (value == _passwordController.text) {
                            doesPasswordsMatch = true;
                          }
                        },
                        validator: (value) {
                          return value != _passwordController.text
                              ? "Passwords don't match"
                              : null;
                        },
                      ),
                      RegisterButton(
                        onPressed: _submitEnabled ? _onFormSubmitted : null,
                      ),
                    ],
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                  ),
                ),
              ),
            ],
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

  void _onFormSubmitted() {
    _registerBloc.add(
      Submitted(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}
