import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/data_source/model/user_detail.dart';
import 'package:pubg/user_detail/bloc/bloc.dart';
import 'package:pubg/user_detail/ui/create_team_form.dart';
import 'package:pubg/user_detail/ui/join_team_form.dart';

class UserProfileForm extends StatefulWidget {
  @override
  _UserProfileFormState createState() => _UserProfileFormState();
}

class _UserProfileFormState extends State<UserProfileForm> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
//  final TextEditingController _teamIDController = TextEditingController();
//  final TextEditingController _teamCodeController = TextEditingController();
  ValueNotifier<DocumentReference> _teamReference = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
      if (state is FindTeamSuccess) {
        _teamReference.value = state.teamReference;
      } else if (state is CreateTeamSuccess) {
        _teamReference.value = state.teamReference;
      }
    }, builder: (context, state) {
      if (state is UserProfileLoading) {
        return Text("user profile Loading");
      } else {
        return Column(
          children: [
            TextFormField(
              controller: _userNameController,
              decoration: InputDecoration(
                icon: Icon(Icons.games),
                labelText: 'User Name',
              ),
              autocorrect: false,
              autovalidate: true,
            ),
            TextFormField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                icon: Icon(Icons.games),
                labelText: 'Phone Number',
              ),
              keyboardType: TextInputType.numberWithOptions(),
              autocorrect: false,
              autovalidate: true,
            ),
            ValueListenableBuilder(valueListenable: _teamReference, builder: (context, value, _) {
              return Text("Selected team ${value ?? "-"}");
            }),
            Row(
              children: [
                RaisedButton(
                  child: Text("Join Team"),
                    onPressed: () {
                  Scaffold.of(context)
                      .showBottomSheet((context) => JoinTeamForm());
                }),
                RaisedButton(
                    child: Text("Create Team"),
                    onPressed: () {
                      Scaffold.of(context)
                          .showBottomSheet((context) => CreateTeamForm());
                    })
              ],
            ),
            RaisedButton(
              onPressed: () {
                BlocProvider.of<UserProfileBloc>(context).add(
                    SaveProfilePressed(
                        userDetail: UserDetail(
                            userName: _userNameController.value.text,
                            phoneNumber: int.parse(
                                _phoneNumberController.value.text.trim()),
                            userUuid: "",
                            joinedTeam: _teamReference.value)));
              },
              child: Text("Submit"),
            )
          ],
        );
      }
    });
  }
}
