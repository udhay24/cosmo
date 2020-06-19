import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pubg/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:pubg/bloc/authentication_bloc/authentication_event.dart';
import 'package:pubg/bloc/navigation/bloc.dart';
import 'package:pubg/data_source/database.dart';
import 'package:pubg/data_source/event_repository.dart';
import 'package:pubg/data_source/model/available_event.dart';
import 'package:pubg/data_source/model/event_notification.dart';
import 'package:pubg/data_source/user_repository.dart';
import 'package:pubg/home_screen/bloc/bloc.dart';
import 'package:pubg/home_screen/ui/slot_selection_dialog.dart';
import 'package:pubg/util/notification_util.dart';
import 'package:sqflite/sqflite.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  HomeScreenBloc _homeScreenBloc;

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
    _homeScreenBloc = BlocProvider.of<HomeScreenBloc>(context)
      ..add(HomeScreenStarted());
    _initializeFirebaseMessaging();
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
                              _homeScreenBloc.add(EventSelected(
                                  eventID:
                                      state.availableEvents[position].eventID));
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
          listener: (listenerContext, state) {
            if (state is MissingUserDetails) {
              BlocProvider.of<NavigationBloc>(listenerContext)
                  .add(UserProfileNavigateEvent());
            } else if (state is ShowSlotDialog) {
              showModalBottomSheet(
                  context: context,
                  builder: (buildContext) {
                    return SlotSelectionDialog(
                      homeScreenBloc: _homeScreenBloc,
                      eventId: state.eventID,
                    );
                  });
            } else if (state is EventRegistrationSuccess) {
              Navigator.of(listenerContext).pop();
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
            popupMenuItem = PopupMenuItem<String>(
              child: Text("View Team"),
              value: "view_team",
            );
          }
          return PopupMenuButton(
            itemBuilder: (_) {
              return <PopupMenuItem<String>>[
                popupMenuItem,
                PopupMenuItem<String>(
                    child: const Text("Notifications"), value: "notification"),
                PopupMenuItem<String>(
                    child: const Text("Log out"), value: "log_out"),
                PopupMenuItem<String>(
                  child: const Text("About us"),
                  value: "about",
                )
              ];
            },
            onSelected: (value) {
              if (value == "log_out") {
                BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
              } else if (value == "manage_team") {
                BlocProvider.of<NavigationBloc>(context)
                    .add(TeamDetailNavigationEvent(isFormEditable: true));
              } else if (value == "view_team") {
                BlocProvider.of<NavigationBloc>(context)
                    .add(TeamDetailNavigationEvent(isFormEditable: false));
              } else if (value == "about") {
                BlocProvider.of<NavigationBloc>(context)
                    .add(AboutScreenNavigationEvent());
              } else if (value == "notification") {
                BlocProvider.of<NavigationBloc>(context)
                    .add(EventNotificationsNavigationEvent());
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

  _initializeFirebaseMessaging() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        handleNotificationEvent(message);
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        handleNotificationEvent(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        handleNotificationEvent(message);
      },
    );
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      _homeScreenBloc.add(UpdateFcmCode(fcmCode: token));
    });
  }

  handleNotificationEvent(Map<String, dynamic> message) {
    _homeScreenBloc.add(EventNotificationReceived(
        roomId: message['data']['room_id'] as String,
        roomPassword: message['data']['room_password'] as String,
        eventId: message['data']['event_id'] as String));
  }
}
