import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pubg/bloc/navigation/bloc.dart';
import 'package:pubg/data_source/model/available_event.dart';
import 'package:pubg/home_screen/bloc/bloc.dart';
import 'package:pubg/util/network_util.dart';
import 'package:pubg/util/notification_util.dart';
import 'package:pubg/util/widget_util.dart';

import 'no_internet_Screen.dart';
import 'slot_selection_dialog.dart';

class AvailableEventWidget extends StatefulWidget {
  @override
  _AvailableEventWidgetState createState() => _AvailableEventWidgetState();
}

class _AvailableEventWidgetState extends State<AvailableEventWidget> {
  static List<String> queryParam = [
    "call of duty",
    "xbox",
    "guns",
    "soldier",
  ];
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    _initializeFirebaseMessaging();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeScreenBloc, HomeScreenState>(
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
            children: <Widget>[
              Expanded(
                child: ListView.separated(
                    itemCount: state.availableEvents.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    separatorBuilder: (context, position) {
                      return Divider(
                        height: 4,
                        thickness: 2,
                        indent: 30,
                        endIndent: 30,
                      );
                    },
                    itemBuilder: (context, position) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _getEventCard(state.availableEvents[position]),
                      );
                    }),
              ),
              _buildSocialMediaCard()
            ],
          );
        } else if (state is AvailableEventsLoading) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Center(
            child: NoInternetWidget(),
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
                  homeScreenBloc: BlocProvider.of<HomeScreenBloc>(context),
                  eventId: state.eventID,
                );
              });
        } else if (state is EventRegistrationSuccess) {
          Navigator.of(listenerContext).pop();
        }
      },
    );
  }

  Widget _getEventCard(AvailableEvent event) {
    return Container(
      height: 180,
      child: Row(
        children: <Widget>[
          Card(
            clipBehavior: Clip.hardEdge,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: Container(
              width: 120,
              height: 180,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/pubg_player.jpg"),
                      colorFilter:
                          ColorFilter.mode(Colors.grey, BlendMode.overlay))),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    event.eventName,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    event.eventDescription,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w300,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 6,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                      onPressed: () {
                        BlocProvider.of<HomeScreenBloc>(context)
                            .add(EventSelected(eventID: event.eventID));
                      },
                      child: Text("Register"),
                      textColor: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _initializeFirebaseMessaging() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        handleNotificationEvent(message);
        Scaffold.of(context)
            .showSnackBar(buildSnackBar("New Event Details Received"));
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        handleNotificationEvent(message);
        BlocProvider.of<NavigationBloc>(context)
            .add(EventNotificationsNavigationEvent());
      },
      onResume: (Map<String, dynamic> message) async {
        handleNotificationEvent(message);
        BlocProvider.of<NavigationBloc>(context)
            .add(EventNotificationsNavigationEvent());
      },
    );
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      BlocProvider.of<HomeScreenBloc>(context)
          .add(UpdateFcmCode(fcmCode: token));
    });
  }

  handleNotificationEvent(Map<String, dynamic> message) {
    if (message['data'] != null) {
      BlocProvider.of<HomeScreenBloc>(context).add(EventNotificationReceived(
          roomId: message['data']['room_id'] as String,
          roomPassword: message['data']['room_password'] as String,
          eventId: message['data']['event_id'] as String));
    }
  }

  Widget _buildSocialMediaCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(
          height: 2,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text(
            "Join us on",
            style: GoogleFonts.sourceSansPro(
                fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Image.asset('assets/icons/facebook-48.png'),
              onPressed: () {
                launchURL(
                    url:
                        "https://www.facebook.com/Team-Cosmos-111189120584649/");
              },
            ),
            IconButton(
              icon: Image.asset('assets/icons/instagram-48.png'),
              onPressed: () {
                launchURL(
                    url: "https://instagram.com/cosmogamingz?igshid=7o93qh2op04u");
              },
            ),
            IconButton(
              icon: Image.asset('assets/icons/youtube-48.png'),
              onPressed: () {
                launchURL(
                    url: "https://www.youtube.com/channel/UCVJWGqiu1NYP0yG7-bkCSog");
              },
            ),
            IconButton(
              icon: Image.asset('assets/icons/whatsapp-30.png'),
              onPressed: () {
                launchURL(
                    url: "https://chat.whatsapp.com/JzlCRzapzOr86f41k1nTE1");
              },
            ),
          ],
        ),
      ],
    );
  }
}
