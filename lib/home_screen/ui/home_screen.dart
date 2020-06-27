import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:pubg/bloc/authentication_bloc/authentication_event.dart';
import 'package:pubg/bloc/navigation/bloc.dart';
import 'package:pubg/data_source/user_repository.dart';
import 'package:pubg/home_screen/bloc/bloc.dart';
import 'package:pubg/home_screen/ui/available_event_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeScreenBloc>(context)
      ..add(HomeScreenStarted());
  }

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
        body: AvailableEventWidget()
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
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            icon: Icon(Icons.menu),
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

}
