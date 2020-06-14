import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/user_detail/bloc/bloc.dart';
import 'package:pubg/util/validators.dart';

class CreateTeamForm extends StatefulWidget {
  @override
  _CreateTeamFormState createState() => _CreateTeamFormState();
}

class _CreateTeamFormState extends State<CreateTeamForm> {
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _teamIDController = TextEditingController();
  final TextEditingController _teamCodeController = TextEditingController();

  GlobalKey<FormState> _globalKey = GlobalKey();

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
        return Container(
          color: Colors.white,
          child: Form(
            key: _globalKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(children: <Widget>[
                TextFormField(
                  controller: _teamNameController,
                  decoration: InputDecoration(labelText: "Team Name"),
//              decoration: InputDecoration(
//                border: OutlineInputBorder(
//                    borderRadius: BorderRadius.circular(8),
//                    borderSide: BorderSide()),
//                labelText: 'Team Name',
//              ),
                autovalidate: true,
                  validator: (value) {
                    if (!Validators.isValidName(value)) {
                      return "Invalid team name";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 15,),
                TextFormField(
                  controller: _teamIDController,
                  autovalidate: true,
                  decoration: InputDecoration(labelText: "Team ID"),
                  validator: (value) {
                    if (!Validators.isValidName(value)) {
                      return "Invalid Team ID";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 15,),
                TextFormField(
                  controller: _teamCodeController,
                  autovalidate: true,
                  decoration: InputDecoration(labelText: "Team Code"),
                  validator: (value) {
                    if (!Validators.isValidName(value)) {
                      return "Invalid Team Code";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 25,),
                Center(
                  child: RaisedButton(
                    onPressed: () {
                      if (_globalKey.currentState.validate()) {
                        BlocProvider.of<UserProfileBloc>(context).add(
                            CreateTeamPressed(
                                teamName: _teamNameController.text,
                                teamID: _teamIDController.text,
                                teamCode: _teamCodeController.text));
                      } else {
                        Scaffold.of(context)
                            .showSnackBar(SnackBar(content: Text("Enter valid details"),
                            behavior: SnackBarBehavior.floating,
                            elevation: 10));
                      }
                    },
                    child: Text("Create Team"),
                  ),
                )
              ]),
            ),
          ),
        );
      },
      listener: (BuildContext context, state) {
        if (state is CreateTeamSuccess) {
          Navigator.of(context).pop();
        }
      },
    );
  }
}
