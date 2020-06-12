import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/data_source/repository_di.dart';
import 'package:pubg/team_detail/bloc/bloc.dart';
import 'package:pubg/team_detail/ui/team_detail_form.dart';

class TeamDetailScreen extends StatelessWidget {

  TeamDetailScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Team Detail')),
      body: Center(
        child: TeamDetailForm(),
      ),
    );
  }
}