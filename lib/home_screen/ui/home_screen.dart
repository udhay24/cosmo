import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:pubg/bloc/authentication_bloc/authentication_event.dart';
import 'package:pubg/bloc/navigation/bloc.dart';
import 'package:pubg/data_source/user_repository.dart';
import 'package:pubg/home_screen/bloc/bloc.dart';
import 'package:pubg/home_screen/ui/slot_selection_dialog.dart';

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
        appBar: AppBar(
          actions: <Widget>[
            FutureBuilder(
              builder: (context, value) {
                if ((value != null) &&
                    (value.hasData) &&
                    (value.data == true)) {
                  return GestureDetector(
                    child: Icon(Icons.person),
                    onTap: () {
                      BlocProvider.of<NavigationBloc>(context)
                          .add(TeamDetailNavigationEvent());
                    },
                  );
                } else {
                  return Container();
                }
              },
              future:
                  RepositoryProvider.of<UserRepository>(context).doesOwnTeam(),
            )
          ],
        ),
        body: Center(
          child: BlocConsumer<HomeScreenBloc, HomeScreenState>(
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
                        BlocProvider.of<AuthenticationBloc>(context)
                            .add(LoggedOut());
                      },
                      child: Text("Log out"),
                    ),
                    ListView.builder(
                        itemCount: state.availableEvents.length,
                        shrinkWrap: true,
                        itemBuilder: (context, position) {
                          return GestureDetector(
                            child: Column(
                              children: [
                                Text(state.availableEvents[position].eventName),
                                Text(state.availableEvents[position]
                                    .eventDescription),
                              ],
                            ),
                            onTap: () {
                              BlocProvider.of<HomeScreenBloc>(context)
                                  .add(EventSelected(eventID: state.availableEvents[position].eventID));
                            },
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
            listener: (context, state) {
              if (state is MissingUserDetails) {
                BlocProvider.of<HomeScreenBloc>(context)
                    .add(HomeScreenStarted());

                BlocProvider.of<NavigationBloc>(context)
                    .add(UserProfileNavigateEvent());
              } else if (state is ShowSlotDialog) {
                Scaffold.of(context)
                    .showBottomSheet((context) => SlotSelectionDialog(
                          selectedEvent: state.selectedEvent,
                          availableSlots: state.availableSlots,
                        ));
              }
            },
          ),
        ));
  }
}
