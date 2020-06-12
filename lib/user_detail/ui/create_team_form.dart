import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/user_detail/bloc/bloc.dart';

class CreateTeamForm extends StatefulWidget {
  @override
  _CreateTeamFormState createState() => _CreateTeamFormState();
}

class _CreateTeamFormState extends State<CreateTeamForm> {
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _teamIDController = TextEditingController();
  final TextEditingController _teamCodeController = TextEditingController();

  @override
  void dispose() {
    _teamCodeController.dispose();
    _teamIDController.dispose();
    _teamNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserProfileBloc, UserProfileState>(
      builder: (context, state) {
        return Wrap(children: <Widget>[
          TextFormField(
            controller: _teamNameController,
            decoration: InputDecoration(labelText: "Team Name"),
          ),
          TextFormField(
            controller: _teamIDController,
            decoration: InputDecoration(labelText: "Team ID"),
          ),
          TextFormField(
            controller: _teamCodeController,
            decoration: InputDecoration(labelText: "Team Code"),
          ),
          RaisedButton(
            onPressed: () {
              BlocProvider.of<UserProfileBloc>(context).add(CreateTeamPressed(
                  teamName: _teamNameController.text,
                  teamID: _teamIDController.text,
                  teamCode: _teamCodeController.text));
            },
            child: Text("Create Team"),
          )
        ]);
      },
      listener: (BuildContext context, state) {
        if (state is CreateTeamSuccess) {
          Navigator.of(context).pop();
        }
      },
    );
  }
}
