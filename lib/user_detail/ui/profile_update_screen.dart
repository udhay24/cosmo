import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/user_detail/bloc/bloc.dart';
import 'package:pubg/user_detail/ui/profile_screen_form.dart';

class UserProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "save",
              style: TextStyle(fontSize: 16),
            ),
            textColor: Colors.white,
            onPressed: () {
              BlocProvider.of<UserProfileBloc>(context)
                  .add(SaveProfilePressed());
            },
          )
        ],
      ),
      body: Center(
        child: UserProfileForm(),
      ),
    );
  }
}
