import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pubg/data_source/model/team_model.dart';
import 'package:pubg/data_source/model/user_model.dart';
import 'package:pubg/team_detail/bloc/bloc.dart';
import 'package:pubg/team_detail/model/team_detail.dart';
import 'package:pubg/team_detail/ui/form_submit_button.dart';
import 'package:pubg/util/network_util.dart';

class TeamDetailForm extends StatefulWidget {
  State<TeamDetailForm> createState() => _TeamDetailFormState();
}

class _TeamDetailFormState extends State<TeamDetailForm> {
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _teamIDController = TextEditingController();
  final TextEditingController _teamCodeController = TextEditingController();

  bool codeVisible = false;

  TeamDetail team =
      TeamDetail(teamName: "", teamId: "", teamCode: "", teamMembers: List());

  TeamDetailBloc _teamDetailBloc;

  GlobalKey<FormState> _globalKey = GlobalKey();

  @override
  void dispose() {
    super.dispose();
    _teamNameController.dispose();
    _teamCodeController.dispose();
    _teamIDController.dispose();
  }

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
          setState(() {
            team = state.team;
          });
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
          return Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Form(
                      key: _globalKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _buildHeading("Team Profile"),
                          _buildNameFormField(),
                          _buildIdFormField(),
                          _buildCodeFormField(),
                          SizedBox(
                            height: 35,
                          ),
                          _buildHeading("Team Members"),
                          _buildUserList(),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Builder(builder: (context) {
                  return TeamSubmitButton(onPressed: null);
              }),
            ],
          );
        },
      ),
    );
  }

  Row _buildHeading(String heading) {
    return Row(
      children: <Widget>[
        Text(
          heading,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black54
          ),
        ),
        Expanded(
          child: Divider(
            thickness: 2,
            indent: 10,
            endIndent: 10,
          ),
        )
      ],
    );
  }

  TextFormField _buildCodeFormField() {
    return TextFormField(
      controller: _teamCodeController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(borderSide: BorderSide()),
        labelText: 'Team Code',
        helperText:
            "This is a Secret code which will be used by other members to join your team",
        suffix: IconButton(
            icon: Icon(
              codeVisible ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
              size: 14,
            ),
            onPressed: () {
              setState(() {
                codeVisible = !codeVisible;
              });
            }),
      ),
      obscureText: codeVisible,
      autocorrect: false,
      autovalidate: true,
    );
  }

  TextFormField _buildIdFormField() {
    return TextFormField(
      controller: _teamIDController,
      decoration: InputDecoration(
          border: UnderlineInputBorder(borderSide: BorderSide()),
          labelText: 'Team ID',
          helperText:
              "This is a unique id representing your team in event registrations",
          suffix: IconButton(
              icon: Icon(
                FontAwesomeIcons.pen,
                size: 14,
              ),
              onPressed: () {
                _teamIDController.text =
                    "${_teamNameController.text}_${Random().nextInt(100000)}";
              })),
      autocorrect: false,
      autovalidate: true,
    );
  }

  Widget _buildNameFormField() {
    return TextFormField(
      controller: _teamNameController,
      decoration: InputDecoration(
          border: UnderlineInputBorder(borderSide: BorderSide()),
          labelText: 'Team Name',
          helperText:
              "This is the name of your team which will be seen by everyone",
          suffix: IconButton(
              icon: Icon(
                Icons.close,
                size: 20,
              ),
              onPressed: () {
                _teamNameController.clear();
              })),
      autocorrect: false,
      autovalidate: true,
    );
  }

  Widget _buildUserList() {
    return ListView.separated(
      separatorBuilder: (_, _position) {
        return Divider(
          thickness: 1,
          indent: 30,
          endIndent: 30,
        );
      },
      itemBuilder: (context, position) {
        return ExpansionTile(
          title: Text(team.teamMembers[position].userName),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text("User Id: "),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      "${team.teamMembers[position].userUuid}",
                      style: GoogleFonts.abel(
                          fontWeight: FontWeight.w600, letterSpacing: 1),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("Phone number: ")),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      child: ButtonBar(
                        children: <Widget>[
                          Text(
                            "${team.teamMembers[position].phoneNumber}",
                            style: GoogleFonts.abel(
                                fontWeight: FontWeight.w600, letterSpacing: 1),
                          ),
                          Icon(FontAwesomeIcons.whatsapp)
                        ],
                      ),
                      onTap: () {
                        String url =
                            "https://wa.me/91${team.teamMembers[position].phoneNumber}";
                        launchURL(url);
                      },
                    ),
                  ),
                )
              ],
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: FlatButton.icon(
                    icon: Icon(
                      Icons.delete_outline,
                      color: Color(0xaeff4b5b),
                    ),
                    label: Text(
                      "remove user",
                      style: TextStyle(color: Color(0xaeff4b5b)),
                    ),
                    onPressed: () {
                      List<User> updatedMembers = List.from(team.teamMembers)
                        ..removeAt(position);
                      setState(() {
                        team = TeamDetail(
                            teamName: team.teamName,
                            teamCode: team.teamCode,
                            teamId: team.teamId,
                            teamMembers: updatedMembers.cast<User>());
                      });
                    })),
          ],
        );
      },
      itemCount: team.teamMembers.length ?? 0,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
    );
  }

  void _onFormUpdated() {
    _teamDetailBloc.add(TeamMemberDetailChanged(
        team: Team(
      teamName: _teamNameController.text,
      teamId: _teamIDController.text,
      teamCode: _teamCodeController.text,
      teamMembers: team.teamMembers ?? List(),
    )));
  }

  void _onFormSubmitted() {
    _teamDetailBloc.add(
      TeamDetailSubmitPressed(team: team),
    );
  }
}
