import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/bloc/navigation/bloc.dart';
import 'package:pubg/data_source/model/user_detail.dart';
import 'package:pubg/data_source/user_repository.dart';
import 'package:pubg/user_detail/bloc/bloc.dart';
import 'package:pubg/user_detail/ui/create_team_form.dart';
import 'package:pubg/user_detail/ui/join_team_form.dart';
import 'package:pubg/util/validators.dart';

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
      } else if (state is CreateTeamSuccess) {
        _teamReference.value = state.teamReference;
      } else if (state is UserProfileUpdateSuccess) {
        BlocProvider.of<NavigationBloc>(context).add(HomeScreenNavigateEvent());
      } else if (state is UserProfileLoadedState) {
        _userNameController.text = state.userDetail.userName;
        _phoneNumberController.text = state.userDetail.phoneNumber.toString();
        _teamReference.value = state.userDetail.joinedTeam;
      } else if (state is UserProfileUpdating) {
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Updating Profile"),
                SizedBox(
                  width: 10,
                ),
                CircularProgressIndicator(
                  strokeWidth: 2,
                )
              ],
            ),
            behavior: SnackBarBehavior.floating,
            elevation: 10));
      }
    }, builder: (context, state) {
      if (state is UserProfileLoading) {
        return Center(child: CircularProgressIndicator());
      } else {
        return Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _userNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide()),
                      labelText: 'User Name',
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
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide()),
                      labelText: 'Phone Number',
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
                        if (value != null && (value.isNotEmpty)) {
                          return Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text("Selected team"),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("$value")
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  RaisedButton(
                                    child: Text("Change Team"),
                                    onPressed: () {
                                      Scaffold.of(context).showBottomSheet(
                                          (context) => JoinTeamForm(),
                                          backgroundColor: Colors.white,
                                          elevation: 4);
                                    },
                                  ),
                                  RaisedButton(
                                      child: Text("Create Team"),
                                      onPressed: () {
                                        Scaffold.of(context).showBottomSheet(
                                            (context) => CreateTeamForm(),
                                            backgroundColor: Colors.white,
                                            elevation: 4);
                                      })
                                ],
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text("Selected team"),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Team not selected")
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  RaisedButton(
                                      child: Text("Join Team"),
                                      onPressed: () {
                                        Scaffold.of(context).showBottomSheet(
                                            (context) => JoinTeamForm());
                                      }),
                                  RaisedButton(
                                      child: Text("Create Team"),
                                      onPressed: () {
                                        Scaffold.of(context).showBottomSheet(
                                            (context) => CreateTeamForm());
                                      })
                                ],
                              ),
                            ],
                          );
                        }
                      })
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate() &&
                    _selectedTeamName.value.isNotEmpty) {
                  BlocProvider.of<UserProfileBloc>(context).add(
                      SaveProfilePressed(
                          userDetail: UserDetail(
                              userName: _userNameController.value.text,
                              phoneNumber: int.parse(
                                  _phoneNumberController.value.text.trim()),
                              userUuid: "",
                              joinedTeam: _teamReference.value)));
                } else {
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Invalid data')));
                }
              },
              child: Text("Update profile"),
            ),
          ),
        ]);
      }
    });
  }
}
