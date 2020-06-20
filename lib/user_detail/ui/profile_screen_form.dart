import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pubg/data_source/model/user_model.dart';
import 'package:pubg/data_source/user_repository.dart';
import 'package:pubg/user_detail/bloc/bloc.dart';
import 'package:pubg/user_detail/ui/create_team_form.dart';
import 'package:pubg/util/validators.dart';
import 'package:pubg/util/widget_util.dart';

import 'join_team_form.dart';

class UserProfileForm extends StatefulWidget {
  @override
  _UserProfileFormState createState() => _UserProfileFormState();
}

class _UserProfileFormState extends State<UserProfileForm> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  ValueNotifier<DocumentReference> _teamReference = ValueNotifier(null);
  ValueNotifier<String> _selectedTeamName = ValueNotifier("");

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _teamReference.addListener(() async {
      if (_teamReference.value != null) {
        var team = await RepositoryProvider.of<UserRepository>(context)
            .getTeamDetails(_teamReference.value.documentID);
        _selectedTeamName.value = team.teamName;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _userNameController.dispose();
    _phoneNumberController.dispose();
    _teamReference.dispose();
    _selectedTeamName.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
      if (state is FindTeamSuccess) {
        _teamReference.value = state.teamReference;
        Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(buildSnackBar("Team found"));
        Navigator.of(context).pop();
        if (_formKey.currentState.validate() &&
            _selectedTeamName.value.isNotEmpty) {
          _updateProfile();
        }
      } else if (state is FindTeamSearching) {
        Navigator.of(context).pop();
        Scaffold.of(context)
            .showSnackBar(buildLoadingSnackBar("Searching Team"));
      } else if (state is CannotJoinTeam) {
        Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            buildSnackBar("This team has reached maximum members limit"),
          );
      } else if (state is FindTeamFailure) {
        Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            buildSnackBar("Team doesn't exist"),
          );
      } else if (state is CreateTeamSuccess) {
        _teamReference.value = state.teamReference;
        if (_formKey.currentState.validate() &&
            _selectedTeamName.value.isNotEmpty) {
          _updateProfile();
        }
      } else if (state is CreatingTeam) {
        Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(buildLoadingSnackBar("Creating Team"));
        Navigator.of(context).pop();
      } else if (state is UserProfileUpdateSuccess) {
        Scaffold.of(context).showSnackBar(buildSnackBar("Profile Updated"));
      } else if (state is UserProfileLoadedState) {
        _userNameController.text = state.userDetail.userName;
        _phoneNumberController.text = state.userDetail.phoneNumber.toString();
        _teamReference.value = state.userDetail.joinedTeam;
      } else if (state is UserProfileUpdating) {
        Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(buildLoadingSnackBar("Updating profile"));
      } else if (state is UserProfileStartUpdate) {
        _updateProfile();
      } else if (state is FindTeamFailure) {
        Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(buildSnackBar("Team Not Found"));
      } else if (state is CreateTeamSuccess) {
        Navigator.of(context).pop();
      }
    }, builder: (context, state) {
      if (state is UserProfileLoading) {
        return Center(child: CircularProgressIndicator());
      } else {
        return Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Display name"),
                  TextFormField(
                    controller: _userNameController,
                    decoration: InputDecoration.collapsed(
                      hintText: "name",
                      fillColor: Colors.blue,
                      focusColor: Colors.blue,
                      border: UnderlineInputBorder(),
                    ),
                    maxLength: 24,
                    autocorrect: false,
                    autovalidate: true,
                    validator: (value) {
                      if (!Validators.isValidName(value)) {
                        return 'Invalid name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(),
                  Text("Phone number"),
                  TextFormField(
                    controller: _phoneNumberController,
                    decoration: InputDecoration.collapsed(
                      hintText: "number",
                      fillColor: Colors.blue,
                      focusColor: Colors.blue,
                      border: UnderlineInputBorder(),
                    ),
                    keyboardType: TextInputType.numberWithOptions(),
                    autocorrect: false,
                    maxLength: 10,
                    autovalidate: true,
                    validator: (value) {
                      if (!Validators.isValidPhoneNumber(value)) {
                        return 'Invalid Number';
                      }
                      return null;
                    },
                  ),
                  ValueListenableBuilder(
                      valueListenable: _selectedTeamName,
                      builder: (context, String value, _) {
                        return _buildSelectedTeam(value);
                      })
                ],
              ),
            ),
          ),
        ]);
      }
    });
  }

  Widget _buildSelectedTeam(String value) {
    return ExpansionTile(
      title: Text("Selected Team"),
      subtitle: Text(value),
      leading: Icon(FontAwesomeIcons.gamepad),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Builder(builder: (buildContext) {
              var button;
              if (value != null && (value.isNotEmpty)) {
                button = "Change Team";
              } else {
                button = "Join Team";
              }
              return _buildTeamButton(button, () {
                showModalBottomSheet(
                    context: context,
                    builder: (buildContext) {
                      return JoinTeamForm(
                        userProfileBloc:
                            BlocProvider.of<UserProfileBloc>(context),
                      );
                    },
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(10),
                            right: Radius.circular(10))),
                    elevation: 4,
                    isScrollControlled: true);
              });
            }),
            _buildTeamButton("Create Team", () {
              showModalBottomSheet(
                  context: context,
                  builder: (buildContext) => CreateTeamForm(
                        userProfileBloc:
                            BlocProvider.of<UserProfileBloc>(context),
                      ),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(10),
                          right: Radius.circular(10))),
                  elevation: 4,
                  isScrollControlled: true);
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildTeamButton(String value, VoidCallback onTap) {
    return FlatButton(
      child: Text(value),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
//      borderSide: new BorderSide(color: Colors.blue),

      onPressed: () {
        onTap();
      },
    );
  }

  _updateProfile() {
    if (_formKey.currentState.validate() &&
        _selectedTeamName.value.isNotEmpty) {
      BlocProvider.of<UserProfileBloc>(context).add(UpdateProfile(
          userDetail: User(
              userName: _userNameController.value.text,
              phoneNumber: int.parse(_phoneNumberController.value.text.trim()),
              userUuid: "",
              joinedTeam: _teamReference.value)));
    } else {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Invalid data')));
    }
  }
}
