import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/user_detail/bloc/bloc.dart';
import 'package:pubg/user_detail/bloc/user_profile_bloc.dart';

class JoinTeamForm extends StatefulWidget {
  final UserProfileBloc userProfileBloc;

  JoinTeamForm({@required this.userProfileBloc});

  @override
  _JoinTeamFormState createState() => _JoinTeamFormState();
}

class _JoinTeamFormState extends State<JoinTeamForm> {
  final TextEditingController _teamIDController = TextEditingController();
  final TextEditingController _teamCodeController = TextEditingController();

  final GlobalKey<FormState> _globalKey = GlobalKey();

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
            key: _globalKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _teamIDController,
                    decoration: InputDecoration.collapsed(hintText: "Team Id"),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: _teamCodeController,
                    decoration:
                        InputDecoration.collapsed(hintText: "Team Code"),
                  ),
                  OutlineButton(
                      child: Text(
                        "Join",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w600),
                      ),
                      borderSide: BorderSide.none,
                      onPressed: () {
                        widget.userProfileBloc.add(JoinTeamPressed(
                            teamID: _teamIDController.text,
                            teamCode: _teamCodeController.text));
                      })
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
