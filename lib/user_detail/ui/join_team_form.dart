import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/user_detail/bloc/bloc.dart';
import 'package:pubg/user_detail/bloc/user_profile_bloc.dart';

class JoinTeamForm extends StatelessWidget {
  final TextEditingController _teamIdController =
      TextEditingController();
  final TextEditingController _teamCodeController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserProfileBloc, UserProfileState>(
        builder: (context, state) {
      return Wrap(children: <Widget>[
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _teamIdController,
                  decoration: InputDecoration(labelText: "Team ID"),
                ),
                SizedBox(height: 8,),
                TextFormField(
                  controller: _teamCodeController,
                  decoration: InputDecoration(labelText: "Team Code"),
                ),
                SizedBox(height: 8,),
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
        ),
      ]);
    }, listener: (context, state) {
      if (state is FindTeamSuccess) {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text("Team Found"),
          behavior: SnackBarBehavior.floating,
          elevation: 10,));
        Navigator.of(context).pop();
      } else if (state is FindTeamFailure) {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text("Team Not Found"),
            behavior: SnackBarBehavior.floating,
            elevation: 10));
      } else if (state is FindTeamSearching) {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Searching Team"),
                SizedBox(width: 10,),
                CircularProgressIndicator(
                  strokeWidth: 2,
                )
              ],
            ),
            behavior: SnackBarBehavior.floating,
            elevation: 10));
      } else if (state is CannotJoinTeam) {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text("This team has reached maximum members limit"),
          behavior: SnackBarBehavior.floating,
          elevation: 10,));
      }
    });
  }
}
