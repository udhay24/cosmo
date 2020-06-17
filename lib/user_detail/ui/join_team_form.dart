import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pubg/user_detail/bloc/bloc.dart';
import 'package:pubg/user_detail/bloc/user_profile_bloc.dart';

class JoinTeamForm extends StatefulWidget {

  final UserProfileBloc userProfileBloc;

  JoinTeamForm({@required this.userProfileBloc});

  @override
  _JoinTeamFormState createState() => _JoinTeamFormState();
}

class _JoinTeamFormState extends State<JoinTeamForm> {

  final TextEditingController _teamIDController =
  TextEditingController();
  final TextEditingController _teamCodeController =
  TextEditingController();

  final GlobalKey<FormState> _globalKey = GlobalKey();
  
  @override
  void dispose() {
    _teamCodeController.dispose();
    _teamIDController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserProfileBloc, UserProfileState>(
      bloc: widget.userProfileBloc,
        builder: (context, state) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Form(
          key: _globalKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _teamIDController,
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
                              teamID: _teamIDController.text,
                              teamCode: _teamCodeController.text));
                    })
              ],
            ),
          ),
        ),
      );
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
