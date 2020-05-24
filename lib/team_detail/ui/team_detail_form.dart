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
  final List<TextEditingController> _membersNameController = [];

  TeamDetailBloc _teamDetailBloc;

  bool get isPopulated =>
      _pubgNameController.text.isNotEmpty &&
      _teamNameController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _teamDetailBloc = BlocProvider.of<TeamDetailBloc>(context);
    _pubgNameController.addListener(_onFormUpdated);
    _teamNameController.addListener(_onFormUpdated);
    _phoneNumberController.addListener(_onFormUpdated);

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
//          state.teamDetailModel.teamMembers.map((e) {
//
//          });
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
                        _membersNameController.add(TextEditingController()
                          ..addListener(_onFormUpdated));
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
    super.dispose();
  }

  void _onFormUpdated() {
    _teamDetailBloc.add(TeamMemberDetailChanged(
        teamDetailModel: TeamDetailModel(
            pubgName: _pubgNameController.text,
            phoneNumber: "${_phoneNumberController.text}",
            teamName: _teamNameController.text,
            teamMembers: _membersNameController.map((e) => e.text)
              .where((element) => element.isNotEmpty).toList())));
  }

  void _onFormSubmitted() {
    _teamDetailBloc.add(
      TeamDetailSubmitPressed(
        teamDetail: TeamDetailModel(
            pubgName: _pubgNameController.text,
            teamName: _teamNameController.text,
            phoneNumber: "${_phoneNumberController.text}",
            teamMembers: _membersNameController.map((e) => e.text)
              .where((element) => element.isNotEmpty).toList()),
      ),
    );
  }
}
