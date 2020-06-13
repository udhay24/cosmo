import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/user_detail/bloc/bloc.dart';
import 'package:pubg/user_detail/bloc/user_profile_bloc.dart';

class JoinTeamForm extends StatelessWidget {
  final TextEditingController _teamIdController =
      TextEditingController(text: "12345");
  final TextEditingController _teamCodeController =
      TextEditingController(text: "12345");

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserProfileBloc, UserProfileState>(
        builder: (context, state) {
      return Wrap(children: <Widget>[
        Container(
          child: Column(
            children: [
              TextFormField(
                controller: _teamIdController,
                decoration: InputDecoration(labelText: "Team ID"),
              ),
              TextFormField(
                controller: _teamCodeController,
                decoration: InputDecoration(labelText: "Team Code"),
              ),
              RaisedButton(
                  child: Text("Join"),
                  onPressed: () {
                    BlocProvider.of<UserProfileBloc>(context).add(
                        JoinTeamPressed(
                            teamID: _teamIdController.text,
                            teamCode: _teamCodeController.text));
                  })
            ],
          ),
        ),
      ]);
    }, listener: (context, state) {
      if (state is FindTeamSuccess) {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text("Team Found")));
        Navigator.of(context).pop();

      } else if (state is FindTeamFailure) {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text("Team Not Found")));
      }
    });
  }
}
