import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/data_source/model/team_detail.dart';
import 'package:pubg/data_source/user_repository.dart';
import 'package:pubg/team_detail/bloc/bloc.dart';

class TeamDetailViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Team"),
      ),
      body: BlocBuilder<TeamDetailBloc, TeamDetailState>(
          builder: (context, state) {
        if (state is PreFilled) {
          return _buildTeamDetail(state, context);
        } else if (state is TeamDetailEmpty) {
          return _buildEmptyScreen();
        } else {
          return _buildLoadingScreen();
        }
      }),
    );
  }

  Center _buildTeamDetail(PreFilled state, BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[Text("Team Name"), Text(state.team.teamName)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[Text("Team ID"), Text(state.team.teamId)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[Text("Team Code"), Text(state.team.teamCode)],
          ),
          Text("Team members"),
          _buildUserList(context, state.team),
        ],
      ),
    );
  }

  Center _buildLoadingScreen() => Center(child: CircularProgressIndicator());

  Center _buildEmptyScreen() =>
      Center(child: Text("You are not registered with any team"));

  Widget _buildUserList(BuildContext context, Team team) {
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
      itemCount: team.teamMembers.length ?? 0,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
    );
  }
}
