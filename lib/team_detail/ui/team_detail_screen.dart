import 'package:flutter/material.dart';
import 'package:pubg/team_detail/ui/team_detail_form.dart';

class TeamDetailScreen extends StatelessWidget {

  TeamDetailScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Team Detail')),
      body: TeamDetailForm(),
    );
  }
}