import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/data_source/login_repository.dart';
import 'package:pubg/login/bloc/login_dart.dart';

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
                image: NetworkImage(
                    "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/9ad57880-8227-4983-9bda-20d3c85fb3d2/d53bs46-73cb26e4-a9c6-46d0-b76c-e14819f152c0.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOiIsImlzcyI6InVybjphcHA6Iiwib2JqIjpbW3sicGF0aCI6IlwvZlwvOWFkNTc4ODAtODIyNy00OTgzLTliZGEtMjBkM2M4NWZiM2QyXC9kNTNiczQ2LTczY2IyNmU0LWE5YzYtNDZkMC1iNzZjLWUxNDgxOWYxNTJjMC5qcGcifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6ZmlsZS5kb3dubG9hZCJdfQ.nNSrXEwgSNVSytoFrt8N-d4_BK3nhCtSshJ_mP-wJU0"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.red, BlendMode.darken),
            )),
        child:  LoginForm(),
        alignment: Alignment.center,
      ),
    );
  }
}
