import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/user_detail/bloc/bloc.dart';
import 'package:pubg/user_detail/bloc/user_profile_bloc.dart';
import 'package:pubg/util/validators.dart';

class JoinTeamForm extends StatefulWidget {
  final UserProfileBloc userProfileBloc;

  JoinTeamForm({@required this.userProfileBloc});

  @override
  _JoinTeamFormState createState() => _JoinTeamFormState();
}

class _JoinTeamFormState extends State<JoinTeamForm> {
  final TextEditingController _teamIDController = TextEditingController();
  final TextEditingController _teamCodeController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  bool _submitEnabled = false;

  @override
  void dispose() {
    _teamCodeController.dispose();
    _teamIDController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileBloc, UserProfileState>(
      bloc: widget.userProfileBloc,
      builder: (context, state) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Form(
            key: _formKey,
            onChanged: () => setState(
                () => _submitEnabled = _formKey.currentState.validate()),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                        controller: _teamIDController,
                        decoration: InputDecoration.collapsed(
                            hintText: "Team Id",
                            hintStyle: TextStyle(color: Colors.black54)),
                        validator: (value) {
                          if (Validators.isValidName(value)) {
                            return null;
                          } else {
                            return "Invalid ID";
                          }
                        }),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                        controller: _teamCodeController,
                        decoration: InputDecoration.collapsed(
                            hintText: "Team Code",
                            hintStyle: TextStyle(color: Colors.black54)),
                        validator: (value) {
                          if (Validators.isValidName(value)) {
                            return null;
                          } else {
                            return "Invalid Code";
                          }
                        }),
                  ),
                  OutlineButton(
                      child: Text(
                        "Join",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      borderSide: BorderSide.none,
                      textColor: Colors.blueAccent,
                      disabledTextColor: Colors.grey,
                      onPressed: _submitEnabled
                          ? () => widget.userProfileBloc.add(JoinTeamPressed(
                              teamID: _teamIDController.text,
                              teamCode: _teamCodeController.text))
                          : null)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
