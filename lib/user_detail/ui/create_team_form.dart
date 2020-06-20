import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/user_detail/bloc/bloc.dart';
import 'package:pubg/util/validators.dart';

class CreateTeamForm extends StatefulWidget {
  final UserProfileBloc userProfileBloc;

  CreateTeamForm({@required this.userProfileBloc});

  @override
  _CreateTeamFormState createState() => _CreateTeamFormState();
}

class _CreateTeamFormState extends State<CreateTeamForm> {
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _teamIDController = TextEditingController();
  final TextEditingController _teamCodeController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey();
  bool _submitEnabled = false;
  bool validTeamId = false;
  bool showProgressBar = false;

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
      bloc: widget.userProfileBloc,
      listener: (previousState, state) {
        if (state is ValidTeamId) {
          validTeamId = true;
          showProgressBar = false;
        } else if (state is InValidTeamId) {
          validTeamId = false;
          showProgressBar = false;
        } else if (state is ValidatingTeamId) {
          showProgressBar = true;
        }
      },
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
                  children: <Widget>[
                    TextFormField(
                      controller: _teamNameController,
                      decoration: InputDecoration.collapsed(
                          hintText: "Team Name",
                          hintStyle: TextStyle(color: Colors.black54)),
                      validator: (value) {
                        if (!Validators.isValidName(value)) {
                          return "Invalid Team Name";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    _buildCreateFormField(),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _teamCodeController,
                      decoration: InputDecoration.collapsed(
                          hintText: "Team Code",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.black54)),
                      validator: (value) {
                        if (!Validators.isValidName(value)) {
                          return "Invalid Team Code";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    OutlineButton(
                      borderSide: BorderSide.none,
                      textColor: Colors.blueAccent,
                      disabledTextColor: Colors.grey,
                      onPressed: _submitEnabled
                          ? () => widget.userProfileBloc.add(CreateTeamPressed(
                              teamName: _teamNameController.text,
                              teamID: _teamIDController.text,
                              teamCode: _teamCodeController.text))
                          : null,
                      child: Text("Create Team"),
                    )
                  ]),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCreateFormField() {
    return Row(
      children: <Widget>[
        Expanded(
            child: TextFormField(
          controller: _teamIDController,
          decoration: InputDecoration.collapsed(
            hintText: "Team ID",
            hintStyle: TextStyle(color: Colors.black54),
          ),
          autovalidate: true,
          onChanged: (value) {
            widget.userProfileBloc
                .add(NewTeamIdEntered(teamID: _teamIDController.text));
          },
          validator: (value) {
            if (Validators.isValidName(value) && validTeamId) {
              return null;
            } else {
              return !Validators.isValidName(value) ? "Invalid team id": "Id already taken";
            }
          },
        )),
        SizedBox(
          height: 15,
          width: 15,
          child: Visibility(
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
            visible: showProgressBar,
          ),
        )
      ],
    );
  }
}
