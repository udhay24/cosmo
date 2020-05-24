import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/data_source/model/team_detail.dart';
import 'package:pubg/team_detail/bloc/bloc.dart';
import 'package:pubg/team_detail/ui/form_submit_button.dart';

class TeamDetailForm extends StatefulWidget {
  State<TeamDetailForm> createState() => _TeamDetailFormState();
}

class _TeamDetailFormState extends State<TeamDetailForm> {
  final TextEditingController _pubgNameController = TextEditingController();
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final List<TextEditingController> _membersNameController =
      List.generate(4, (index) => TextEditingController());

  TeamDetailBloc _teamDetailBloc;
  List<String> _membersList = List.generate(4, (index) => "");

  @override
  void initState() {
    super.initState();
    _teamDetailBloc = BlocProvider.of<TeamDetailBloc>(context);
    _pubgNameController.addListener(_onFormUpdated);
    _teamNameController.addListener(_onFormUpdated);
    _phoneNumberController.addListener(_onFormUpdated);
    _membersNameController.forEach((element) {
      element.addListener(_onFormUpdated);
    });
    _teamDetailBloc.add(TeamDetailScreenInitialized());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TeamDetailBloc, TeamDetailState>(
      listener: (context, state) {
        if (state is PreFilled) {
          _teamNameController.text = state.teamDetailModel.teamName;
          _pubgNameController.text = state.teamDetailModel.pubgName;
          _phoneNumberController.text = state.teamDetailModel.phoneNumber;
          _membersList = List.generate(4, (index) {
            if (index < state.teamDetailModel.teamMembers.length) {
              return state.teamDetailModel.teamMembers[index];
            } else {
              return "";
            }
          });
          _membersNameController.asMap().forEach((key, value) {
            value.text = _membersList[key];
          });
        }

        if (state is TeamDetailSubmitting) {
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
        if (state is TeamDetailSubmittedSuccess) {
          Navigator.of(context).pop();
        }
        if (state is TeamDetailSubmittedFailure) {
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
                      controller: _pubgNameController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.games),
                        labelText: 'PUBG',
                      ),
                      autocorrect: false,
                      autovalidate: true,
                    ),
                    TextFormField(
                      controller: _phoneNumberController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.phone),
                        labelText: 'Phone Number',
                      ),
                      autocorrect: false,
                      autovalidate: true,
                      keyboardType: TextInputType.phone,
                    ),
                    TextFormField(
                      controller: _teamNameController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.people),
                        labelText: 'Team',
                      ),
                      autocorrect: false,
                      autovalidate: true,
                    ),
                    ListView.builder(
                      itemBuilder: (context, index) {
                        return TextFormField(
                          controller: _membersNameController[index],
                          decoration: InputDecoration(
                            icon: Icon(Icons.person),
                            labelText: 'member $index',
                          ),
                          autocorrect: false,
                          autovalidate: true,
                          keyboardType: TextInputType.text,
                        );
                      },
                      itemCount: 4,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                    ),
                    Builder(builder: (context) {
                      if (state is SubmitFormVisible) {
                        return TeamSubmitButton(onPressed: _onFormSubmitted);
                      } else {
                        return TeamSubmitButton(
                          onPressed: null,
                        );
                      }
                    })
                  ],
                ),
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
    _phoneNumberController.dispose();
    _membersNameController.map((e) => e.dispose());
    super.dispose();
  }

  void _onFormUpdated() {
    _teamDetailBloc.add(TeamMemberDetailChanged(
        teamDetailModel: TeamDetailModel(
            pubgName: _pubgNameController.text,
            phoneNumber: "${_phoneNumberController.text}",
            teamName: _teamNameController.text,
            teamMembers: _membersNameController
                .map((e) => e.text)
                .where((element) => element.isNotEmpty)
                .toList())));
  }

  void _onFormSubmitted() {
    _teamDetailBloc.add(
      TeamDetailSubmitPressed(
        teamDetail: TeamDetailModel(
            pubgName: _pubgNameController.text,
            teamName: _teamNameController.text,
            phoneNumber: "${_phoneNumberController.text}",
            teamMembers: _membersNameController
                .map((e) => e.text)
                .where((element) => element.isNotEmpty)
                .toList()),
      ),
    );
  }
}
