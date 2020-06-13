import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/data_source/model/team_detail.dart';
import 'package:pubg/data_source/user_repository.dart';
import 'package:pubg/team_detail/bloc/bloc.dart';
import 'package:pubg/team_detail/ui/form_submit_button.dart';

class TeamDetailForm extends StatefulWidget {
  State<TeamDetailForm> createState() => _TeamDetailFormState();
}

class _TeamDetailFormState extends State<TeamDetailForm> {
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _teamIDController = TextEditingController();
  final TextEditingController _teamCodeController = TextEditingController();

  List<DocumentReference> _userList = List();
  Team _team;

  TeamDetailBloc _teamDetailBloc;

  @override
  void initState() {
    super.initState();
    _teamDetailBloc = BlocProvider.of<TeamDetailBloc>(context);
    _teamNameController.addListener(_onFormUpdated);
    _teamIDController.addListener(_onFormUpdated);
    _teamCodeController.addListener(_onFormUpdated);
    _teamDetailBloc.add(TeamDetailScreenInitialized());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TeamDetailBloc, TeamDetailState>(
      listener: (context, state) {
        if (state is PreFilled) {
          _teamNameController.text = state.team.teamName;
          _teamIDController.text = state.team.teamId;
          _teamCodeController.text = state.team.teamCode;
          _userList = state.team.teamMembers;
          _team = state.team;
        }

        if (state is TeamDetailUpdating) {
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
        if (state is TeamDetailChangeSuccess) {
          Navigator.of(context).pop();
        }
        if (state is TeamDetailChangeFailure) {
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
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                child: Column(
                  children: <Widget>[
                  TextFormField(
                  controller: _teamNameController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.games),
                    labelText: 'Team Name',
                  ),
                  autocorrect: false,
                  autovalidate: true,
                ),
                TextFormField(
                  controller: _teamIDController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: 'Team ID',
                  ),
                  autocorrect: false,
                  autovalidate: true,
                ),
                TextFormField(
                  controller: _teamCodeController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.people),
                    labelText: 'Team Code',
                  ),
                  autocorrect: false,
                  autovalidate: true,
                ),
                FutureBuilder(builder: (context, AsyncSnapshot<List<String>> snapshot) {
                  if ((snapshot != null) && (snapshot.hasData)) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return Text(snapshot.data[index]);
                      },
                      itemCount: snapshot.data.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                    );
                  }
                  else {
                    return Container();
                  }
                },
                  future: RepositoryProvider.of<UserRepository>(context).getUserNamesFromRef(_userList),
                )
                ,
                Builder(builder: (context) {
                  if (state is SubmitFormVisible) {
                    return TeamSubmitButton(onPressed: _onFormSubmitted);
                  } else {
                    return TeamSubmitButton(
                      onPressed: null,
                    );
                  }
                }),
                ],
              ),
            ),
          ),);
        },
      ),
    );
  }

  @override
  void dispose() {
    _teamNameController.dispose();
    _teamIDController.dispose();
    _teamCodeController.dispose();
    super.dispose();
  }

  void _onFormUpdated() {
    _teamDetailBloc.add(TeamMemberDetailChanged(
      team: Team(
        teamName: _teamNameController.text,
        teamId: _teamIDController.text,
        teamCode: _teamCodeController.text,
        teamMembers: _team.teamMembers ?? List(),
        teamOwner: _team.teamOwner
      )
    )
    );
  }

  void _onFormSubmitted() {
    _teamDetailBloc.add(
      TeamDetailSubmitPressed(
          team: Team(
              teamName: _teamNameController.text,
              teamId: _teamIDController.text,
              teamCode: _teamCodeController.text,
              teamMembers: _team.teamMembers,
              teamOwner: _team.teamOwner
          )
      ),
    );
  }
}
