import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pubg/data_source/model/user_model.dart';
import 'package:pubg/team_detail/bloc/bloc.dart';
import 'package:pubg/team_detail/model/team_detail.dart';
import 'package:pubg/team_detail/ui/form_submit_button.dart';
import 'package:pubg/util/network_util.dart';
import 'package:pubg/util/validators.dart';

class TeamDetailForm extends StatefulWidget {
  State<TeamDetailForm> createState() => _TeamDetailFormState();
  final bool isFormEditable;

  TeamDetailForm({@required this.isFormEditable});
}

class _TeamDetailFormState extends State<TeamDetailForm> {
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _teamIDController = TextEditingController();
  final TextEditingController _teamCodeController = TextEditingController();

  bool codeVisible = false;

  TeamDetail team =
      TeamDetail(teamName: "", teamId: "", teamCode: "", teamMembers: List());

  final List<User> removedMembers = List();

  TeamDetailBloc _teamDetailBloc;

  GlobalKey<FormState> _formKey = GlobalKey();
  bool submitEnabled = false;

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
                      key: _formKey,
                      onChanged: () => setState(() =>
                          submitEnabled = _formKey.currentState.validate()),
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
              TeamSubmitButton(
                  onPressed: (submitEnabled && widget.isFormEditable)
                      ? _onFormSubmitted
                      : null),
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
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54),
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
        readOnly: !widget.isFormEditable,
        decoration: InputDecoration(
          border: UnderlineInputBorder(borderSide: BorderSide()),
          labelText: 'Team Password',
          helperText:
              "This is a Secret code which will be used by other members to join your team",
          helperMaxLines: 2,
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
        validator: (value) {
          if (Validators.isValidName(value)) {
            return null;
          } else {
            return "Invalid ID";
          }
        });
  }

  TextFormField _buildIdFormField() {
    return TextFormField(
        controller: _teamIDController,
        readOnly: true,
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
                onPressed: null)),
        autocorrect: false,
        validator: (value) {
          if (Validators.isValidName(value)) {
            return null;
          } else {
            return "Invalid ID";
          }
        });
  }

  Widget _buildNameFormField() {
    return TextFormField(
        controller: _teamNameController,
        readOnly: !widget.isFormEditable,
        decoration: InputDecoration(
            border: UnderlineInputBorder(borderSide: BorderSide()),
            labelText: 'Team Name',
            helperText:
                "This is the name of your team which will be seen by everyone",
            helperMaxLines: 2,
            suffix: IconButton(
                icon: Icon(
                  Icons.close,
                  size: 20,
                ),
                onPressed: widget.isFormEditable
                    ? () {
                        _teamNameController.clear();
                      }
                    : null)),
        autocorrect: false,
        validator: (value) {
          if (Validators.isValidName(value)) {
            return null;
          } else {
            return "Invalid ID";
          }
        });
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
        return ListTile(
          title: Text(team.teamMembers[position].userName),
          subtitle: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Phone number: ",
                      style: Theme.of(context).textTheme.headline6,
                    )),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    child: ButtonBar(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "${team.teamMembers[position].phoneNumber}",
                          style: GoogleFonts.abel(
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                              color: Colors.black87),
                        ),
                        Icon(FontAwesomeIcons.whatsapp)
                      ],
                    ),
                    onTap: () {
                      String url =
                          "https://wa.me/91${team.teamMembers[position].phoneNumber}";
                      launchURL(url: url);
                    },
                  ),
                ),
              )
            ],
          ),
          trailing: IconButton(
              icon: Icon(
                Icons.delete_outline,
              ),
              disabledColor: Colors.blueGrey,
              color: Color(0xaeff4b5b),
              onPressed: widget.isFormEditable
                  ? () {
                      removedMembers.add(team.teamMembers[position]);
                      List<User> updatedMembers = List.from(team.teamMembers)
                        ..removeAt(position);
                      setState(() {
                        team = TeamDetail(
                            teamName: team.teamName,
                            teamCode: team.teamCode,
                            teamId: team.teamId,
                            teamMembers: updatedMembers.cast<User>());
                      });
                    }
                  : null),
        );
      },
      itemCount: team.teamMembers.length ?? 0,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
    );
  }

  void _onFormSubmitted() {
    team = TeamDetail(
      teamName: _teamNameController.text,
      teamId: _teamIDController.text,
      teamCode: _teamCodeController.text,
      teamMembers: team.teamMembers ?? List(),
    );
    _teamDetailBloc.add(
      TeamDetailSubmitPressed(team: team, removedUsers: removedMembers),
    );
  }
}
