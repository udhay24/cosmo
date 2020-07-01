import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pubg/bloc/navigation/bloc.dart';
import 'package:pubg/data_source/model/available_event.dart';
import 'package:pubg/home_screen/bloc/bloc.dart';
import 'package:pubg/home_screen/model/event_detail.dart';
import 'package:pubg/util/network_util.dart';
import 'package:pubg/util/widget_util.dart';

import 'no_internet_Screen.dart';
import 'slot_selection_dialog.dart';

class AvailableEventWidget extends StatefulWidget {
  @override
  _AvailableEventWidgetState createState() => _AvailableEventWidgetState();
}

class _AvailableEventWidgetState extends State<AvailableEventWidget> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  static FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    _initializeFirebaseMessaging();
    _initLocalNotifications();
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
                child: ListView.builder(
                    itemCount: state.availableEvents.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
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
          Scaffold.of(context)
              .showSnackBar(buildSnackBar("Registration success"));
          Navigator.of(listenerContext).pop();
          BlocProvider.of<HomeScreenBloc>(context)
              .add(HomeScreenStarted()); //refresh the screen
        } else if (state is EventRegistrationFailure) {
          Scaffold.of(context).showSnackBar(
              buildSnackBar("Registration Failed Try Again Later"));
        } else if (state is CancellationSuccess) {
          Scaffold.of(context).showSnackBar(
              buildSnackBar("Cancelled Registration successfully"));
          Navigator.of(listenerContext).pop();
          BlocProvider.of<HomeScreenBloc>(context)
              .add(HomeScreenStarted()); //refresh the screen
        } else if (state is CancellationFailure) {
          Scaffold.of(context).showSnackBar(
              buildSnackBar("Unable to cancel registration try again later"));
        } else if (state is CancellationFailure) {
          Scaffold.of(context).showSnackBar(
              buildSnackBar("Unable to cancel registration try again later"));
        } else if (state is RoomDetailsAvailable) {
          _showRoomDetails(state.roomDetail);
        } else if (state is RoomDetailsNotAvailable) {
          _showRoomDetailsNotAvailable();
        }
      },
    );
  }

  Widget _getEventCard(CosmoEventUIModel event) {
    return Card(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Container(
          height: 200,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/pubg_player.jpg"),
                  colorFilter:
                  ColorFilter.mode(Colors.grey, BlendMode.darken))),
          child: Stack(
            children: [
              Positioned(
                bottom: 20,
                left: 20,
                child: Column(
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        event.event.eventName,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 150,
                      child: Text(
                        event.event.eventDescription,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 20,
                bottom: 10,
                child: FlatButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () {
                    BlocProvider.of<HomeScreenBloc>(context)
                        .add(EventSelected(eventID: event.event.eventID));
                  },
                  child: event.isRegistered ? Text("Update") : Text("Register"),
                  textColor: Colors.blueAccent,
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> _showRoomDetails(RoomDetail roomDetail) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Room Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Room Id - ${roomDetail.roomID}"),
                Text("Room Password - ${roomDetail.roomPassword}"),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showRoomDetailsNotAvailable() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Room Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Room Details are not available. check again later"),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _initLocalNotifications() async {
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('@drawable/game_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  _initializeFirebaseMessaging() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        _showNotification(message);
        Scaffold.of(context)
            .showSnackBar(buildSnackBar("New Event Details Received"));
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        _showNotification(message);
        BlocProvider.of<NavigationBloc>(context)
            .add(EventNotificationsNavigationEvent());
      },
      onResume: (Map<String, dynamic> message) async {
        _showNotification(message);
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

  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) {
    _showNotification(message);
    return Future<void>.value();
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
            style: Theme.of(context).textTheme.headline5,
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
                    url:
                    "https://instagram.com/cosmogamingz?igshid=7o93qh2op04u");
              },
            ),
            IconButton(
              icon: Image.asset('assets/icons/youtube-48.png'),
              onPressed: () {
                launchURL(
                    url:
                    "https://www.youtube.com/channel/UCVJWGqiu1NYP0yG7-bkCSog");
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

  static Future _showNotification(Map<String, dynamic> message) async {
    var pushTitle;
    var pushText;
    var action;

    if (Platform.isAndroid) {
      var nodeData = message['data'];
      pushTitle = nodeData['title'];
      pushText = nodeData['body'];
    } else {
      pushTitle = message['title'];
      pushText = message['body'];
    }
    print("AppPushs params pushTitle : $pushTitle");
    print("AppPushs params pushText : $pushText");
    print("AppPushs params pushAction : $action");

    var platformChannelSpecificsAndroid = new AndroidNotificationDetails(
        'event_details',
        'Event Details',
        'show details for the upcoming registered event',
        playSound: true,
        enableVibration: true,
        importance: Importance.Max,
        priority: Priority.High);

    var platformChannelSpecificsIos =
    new IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = new NotificationDetails(
        platformChannelSpecificsAndroid, platformChannelSpecificsIos);

    new Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        100,
        pushTitle,
        pushText,
        platformChannelSpecifics,
      );
    });
  }
}
