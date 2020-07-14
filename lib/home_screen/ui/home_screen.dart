import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pubg/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:pubg/bloc/authentication_bloc/authentication_event.dart';
import 'package:pubg/bloc/navigation/bloc.dart';
import 'package:pubg/data_source/event_repository.dart';
import 'package:pubg/data_source/tournament_repository.dart';
import 'package:pubg/data_source/user_repository.dart';
import 'package:pubg/events_screen/bloc/cosmo_events_bloc.dart';
import 'package:pubg/events_screen/ui/available_event_widget.dart';
import 'package:pubg/home_screen/bloc/bloc.dart';
import 'package:pubg/tournament_screen/bloc/tournaments_screen_bloc.dart';
import 'package:pubg/tournament_screen/ui/available_tournaments_widget.dart';
import 'package:pubg/util/network_util.dart';
import 'package:pubg/util/widget_util.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  static FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeFirebaseMessaging();
    _initLocalNotifications();
  }

  static List<Widget> bottomWidgets = [
    BlocProvider(
      create: (context) => CosmoEventsBloc(
          eventRepository: EventRepository(),
          userRepository: RepositoryProvider.of<UserRepository>(context))
        ..add(LoadAvailableEvents()),
      child: AvailableEventWidget(),
    ),
    BlocProvider(
      create: (context) => TournamentsScreenBloc(
          repository: TournamentRepository(),
          userRepository: RepositoryProvider.of<UserRepository>(context))
        ..add(LoadAvailableTournaments()),
      child: TournamentsScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cosmo Gamingz",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: <Widget>[
          _buildProfileMenuAction(context),
          _buildOverFlowMenu(context),
        ],
      ),
      body: bottomWidgets[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/icons/event-tab-48.png')),
              title: Text("Events")),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/icons/tournament-48.png')),
              title: Text("Tournaments"))
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
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
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            icon: Icon(Icons.menu),
            itemBuilder: (_) {
              return <PopupMenuItem<String>>[
                popupMenuItem,
                PopupMenuItem<String>(
                    child: const Text("ID and Pass"), value: "notification"),
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
            style: Theme
                .of(context)
                .textTheme
                .headline5,
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
