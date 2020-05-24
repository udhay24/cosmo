import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:pubg/bloc/authentication_bloc/authentication_event.dart';
import 'package:pubg/slot_registration/bloc/bloc.dart';
import 'package:pubg/slot_registration/ui/slot_selection_form.dart';
import 'package:pubg/team_detail/ui/team_detail_screen.dart';

class SlotSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Slot Selection"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(
                LoggedOut(),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => TeamDetailScreen()));
            },
          )
        ],
      ),
      body: BlocProvider<SlotSelectionBloc>(
        create: (context) => SlotSelectionBloc(),
        child: SlotSelectionForm(),
      ),
    );
  }
}
