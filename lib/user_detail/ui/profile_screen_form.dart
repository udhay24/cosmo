import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/data_source/model/user_detail.dart';
import 'package:pubg/user_detail/bloc/bloc.dart';

class UserProfileForm extends StatefulWidget {
  @override
  _UserProfileFormState createState() => _UserProfileFormState();
}

class _UserProfileFormState extends State<UserProfileForm> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _teamController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserProfileBloc, UserProfileState>(
        listener: (context, state) {},
        builder: (context, state) {
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

                Text("Selected team"),

                RaisedButton(
                  onPressed: () {
                    BlocProvider.of<UserProfileBloc>(context)
                        .add(SaveProfilePressed(
                            userDetail: UserDetail(
                      userName: _userNameController.value.text,
                      phoneNumber:
                          int.parse(_phoneNumberController.value.text.trim()),
                      userUuid: "",
                    )));
                  },
                  child: Text("Submit"),
                )
              ],
            );
          }
        });
  }
}
