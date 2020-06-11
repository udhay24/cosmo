import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:pubg/bloc/authentication_bloc/authentication_event.dart';
import 'package:pubg/bloc/navigation/bloc.dart';
import 'package:pubg/home_screen/bloc/bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeScreenBloc>(context).add(HomeScreenStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: BlocConsumer<HomeScreenBloc, HomeScreenState>(
      listener: (context, state) {
        if (state is MissingUserDetails) {
          BlocProvider.of<NavigationBloc>(context)
              .add(UserProfileNavigateEvent());
        }
      },
      builder: (context, state) {
        if (state is AvailableEventsSuccess) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Text("Home Screen")),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                onPressed: () {
                  BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                },
                child: Text("Log out"),
              ),
              ListView.builder(
                  itemCount: state.availableEvents.length,
                  shrinkWrap: true,
                  itemBuilder: (context, position) {
                    return Column(
                      children: [
                        Text(state.availableEvents[position].slotName),
                        Text(state.availableEvents[position].slotDescription),
                      ],
                    );
                  })
            ],
          );
        } else if (state is AvailableEventsFailure) {
          return Text("Home screen "
              "Fetching Failed");
        } else {
          return CircularProgressIndicator();
        }
      },
    )));
  }
}
