import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:pubg/bloc/authentication_bloc/authentication_event.dart';
import 'package:pubg/data_source/model/team_detail.dart';
import 'package:pubg/team_detail/bloc/bloc.dart';
import 'package:pubg/team_detail/ui/form_submit_button.dart';

class TeamDetailForm extends StatefulWidget {
  State<TeamDetailForm> createState() => _TeamDetailFormState();
}

class _TeamDetailFormState extends State<TeamDetailForm> {
  final TextEditingController _pubgNameController = TextEditingController();
  final TextEditingController _teamNameController = TextEditingController();

  TeamDetailBloc _teamDetailBloc;

  bool get isPopulated =>
      _pubgNameController.text.isNotEmpty && _teamNameController.text.isNotEmpty;

  bool isRegisterButtonEnabled(TeamDetailState state) {
    return isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _teamDetailBloc = BlocProvider.of<TeamDetailBloc>(context);
    _pubgNameController.addListener(_onPubgNameChanged);
    _teamNameController.addListener(_onTeamNameChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TeamDetailBloc, TeamDetailState>(
      listener: (context, state) {
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Registering...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
//          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          Navigator.of(context).pop();
        }
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Registration Failure'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: BlocBuilder<TeamDetailBloc, TeamDetailState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    controller: _pubgNameController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.games),
                      labelText: 'PUBG',
                    ),
                    autocorrect: false,
                    autovalidate: true,
                    validator: (_) {
                      return !state.isPubgNameValid ? 'Invalid Pubg name' : null;
                    },
                  ),
                  TextFormField(
                    controller: _teamNameController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.people),
                      labelText: 'Team',
                    ),
                    autocorrect: false,
                    autovalidate: true,
                    validator: (_) {
                      return !state.isTeamNameValid ? 'Invalid Team name' : null;
                    },
                  ),
                  TeamSubmitButton(
                    onPressed: isRegisterButtonEnabled(state)
                        ? _onFormSubmitted
                        : null,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _pubgNameController.dispose();
    _teamNameController.dispose();
    super.dispose();
  }

  void _onPubgNameChanged() {
    _teamDetailBloc.add(
      PubgNameChanged(pubgName: _pubgNameController.text),
    );
  }

  void _onTeamNameChanged() {
    _teamDetailBloc.add(
      TeamNameChanged(teamName: _teamNameController.text),
    );
  }

  void _onFormSubmitted() {
    _teamDetailBloc.add(
      TeamDetailSubmitPressed(
        teamDetail: TeamDetail(
        pubgName: _pubgNameController.text,
          teamName: _teamNameController.text,
          phoneNumber: "+917010065028",
          teamMembers: ['udhay', 'my name is', 'gone the', 'what am i doing', 'udhay241998']
        ),
      ),
    );
  }
}