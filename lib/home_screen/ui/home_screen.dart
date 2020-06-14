import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pubg/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:pubg/bloc/authentication_bloc/authentication_event.dart';
import 'package:pubg/bloc/navigation/bloc.dart';
import 'package:pubg/data_source/model/available_event.dart';
import 'package:pubg/data_source/user_repository.dart';
import 'package:pubg/home_screen/bloc/bloc.dart';
import 'package:pubg/home_screen/ui/slot_selection_dialog.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static List<String> queryParam = [
    "gaming",
    "call of duty",
    "xbox",
    "game",
    "video game"
  ];

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
            _buildProfileMenuAction(context),
            _buildOverFlowMenu(context),
          ],
        ),
        body: BlocConsumer<HomeScreenBloc, HomeScreenState>(
          buildWhen: (HomeScreenState previous, HomeScreenState current) {
            if ((current is AvailableEventsLoading) ||
                (current is AvailableEventsFailure) ||
                (current is AvailableEventsSuccess)) {
              return true;
            } else {
              return false;
            }
          },
          builder: (context, state) {
            if (state is AvailableEventsSuccess) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: Text(
                        "Available Events",
                        style: TextStyle(
                            fontFamily: FontAwesomeIcons.font.fontFamily,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: state.availableEvents.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, position) {
                          return GestureDetector(
                            child:
                                _getEventCard(state.availableEvents[position]),
                            onTap: () {
                              BlocProvider.of<HomeScreenBloc>(context).add(
                                  EventSelected(
                                      eventID: state
                                          .availableEvents[position].eventID));
                            },
                          );
                        }),
                  ),
                ],
              );
            } else if (state is AvailableEventsFailure) {
              return Center(
                child: Text("Home screen "
                    "Fetching Failed"),
              );
            } else if (state is AvailableEventsLoading) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Center(
                child:
                    Container(child: Text("Unknown state has occurred $state")),
              );
            }
          },
          listener: (context, state) {
            if (state is MissingUserDetails) {
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
        ));
  }

  Widget _getEventCard(AvailableEvent event) {
    return SizedBox.fromSize(
      size: Size(MediaQuery.of(context).size.width, 200),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: <Widget>[
            Card(
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          "https://source.unsplash.com/featured/?${queryParam[Random.secure().nextInt(queryParam.length - 1)]},${queryParam[Random.secure().nextInt(queryParam.length - 1)]}",
                        ),
                        colorFilter:
                            ColorFilter.mode(Colors.grey, BlendMode.overlay))),
              ),
            ),
            Positioned(
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          event.eventName,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          event.eventDescription,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 2,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              bottom: -20,
              left: 10,
            ),
            Positioned(
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
              right: 30,
              bottom: 10,
            )
          ],
          overflow: Overflow.visible,
        ),
      ),
    );
  }

  FutureBuilder<bool> _buildOverFlowMenu(BuildContext context) {
    return FutureBuilder(
      builder: (context, value) {
        if ((value != null) && (value.hasData)) {
          PopupMenuItem popupMenuItem;

          if ((value.data == true)) {
            popupMenuItem = PopupMenuItem<String>(
                child: const Text('Manage Team'), value: 'manage_team');
          } else {
            popupMenuItem = PopupMenuItem(
              child: Text("View Team"),
              value: "view_team",
            );
          }
          return PopupMenuButton(
            itemBuilder: (_) {
              return <PopupMenuItem<String>>[
                popupMenuItem,
                PopupMenuItem<String>(
                    child: const Text("Log out"), value: "log_out"),
              ];
            },
            onSelected: (value) {
              if (value == "log_out") {
                BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
              } else if (value == "manage_team") {
                BlocProvider.of<NavigationBloc>(context)
                    .add(UserProfileNavigateEvent());
              } else if (value == "view_team") {
                BlocProvider.of<NavigationBloc>(context)
                    .add(TeamDetailNavigationEvent());
              }
            },
          );
        } else {
          return Container();
        }
      },
      future: RepositoryProvider.of<UserRepository>(context).doesOwnTeam(),
    );
  }

  GestureDetector _buildProfileMenuAction(BuildContext context) {
    return GestureDetector(
      child: Icon(Icons.perm_identity),
      onTap: () {
        BlocProvider.of<NavigationBloc>(context)
            .add(UserProfileNavigateEvent());
      },
    );
  }
}
