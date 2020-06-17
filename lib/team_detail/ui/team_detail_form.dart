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

  ValueNotifier<Team> _team = ValueNotifier(Team(
      teamOwner: null,
      teamName: "",
      teamId: "",
      teamCode: "",
      teamMembers: List()));

  TeamDetailBloc _teamDetailBloc;

  GlobalKey<FormState> _globalKey = GlobalKey();

  @override
  void dispose() {
    super.dispose();
    _teamNameController.dispose();
    _teamCodeController.dispose();
    _teamIDController.dispose();
    _team.dispose();
  }

  @override
  void initState() {
    super.initState();
    _teamDetailBloc = BlocProvider.of<TeamDetailBloc>(context);
    _teamNameController.addListener(_onFormUpdated);
    _teamIDController.addListener(_onFormUpdated);
    _teamCodeController.addListener(_onFormUpdated);
    _team.addListener(() {
      _onFormUpdated();
    });
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
          _team.value = state.team;
        }

        if (state is TeamDetailUpdating) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Updating...'),
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
                    Text('update Failure. try again'),
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
                key: _globalKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: _teamNameController,
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide()),
                        labelText: 'Team Name',
                      ),
                      autocorrect: false,
                      autovalidate: true,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _teamIDController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide()),
                        labelText: 'Team ID',
                      ),
                      autocorrect: false,
                      autovalidate: true,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _teamCodeController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide()),
                        labelText: 'Team Code',
                      ),
                      autocorrect: false,
                      autovalidate: true,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    _buildUserList(context),
                    SizedBox(
                      height: 15,
                    ),
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
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserList(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _team,
      builder: (context, Team team, _) {
        return ListView.builder(
          itemBuilder: (context, position) {
            return FutureBuilder(
              builder: (context, AsyncSnapshot<String> snapshot) {
                if ((snapshot != null) && (snapshot.hasData)) {
                  return Container(
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(snapshot.data),
                        IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              List<DocumentReference> updatedMembers =
                                  List.from(_team.value.teamMembers)
                                    ..removeAt(position);
                              _team.value = Team(
                                  teamName: _team.value.teamName,
                                  teamCode: _team.value.teamCode,
                                  teamId: _team.value.teamId,
                                  teamOwner: _team.value.teamOwner,
                                  teamMembers:
                                      updatedMembers.cast<DocumentReference>());
                            })
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
              future: RepositoryProvider.of<UserRepository>(context)
                  .getUserNamesFromRef(team.teamMembers[position]),
            );
          },
          itemCount: _team.value.teamMembers.length ?? 0,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
        );
      },
    );
  }

  void _onFormUpdated() {
    _teamDetailBloc.add(TeamMemberDetailChanged(
        team: Team(
            teamName: _teamNameController.text,
            teamId: _teamIDController.text,
            teamCode: _teamCodeController.text,
            teamMembers: _team.value.teamMembers ?? List(),
            teamOwner: _team.value.teamOwner)));
  }

  void _onFormSubmitted() {
    _teamDetailBloc.add(
      TeamDetailSubmitPressed(
          team: Team(
              teamName: _teamNameController.text,
              teamId: _teamIDController.text,
              teamCode: _teamCodeController.text,
              teamMembers: _team.value.teamMembers,
              teamOwner: _team.value.teamOwner)),
    );
  }
}
