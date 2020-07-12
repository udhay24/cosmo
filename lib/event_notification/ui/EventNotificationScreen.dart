import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/event_notification/bloc/bloc.dart';
import 'package:pubg/event_notification/model/notification_model.dart';

class EventNotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      body: BlocBuilder<EventNotificationBloc, EventNotificationState>(
          builder: (context, state) {
        if (state is LoadingEventNotifications) {
          return Center(child: CircularProgressIndicator());
        } else if (state is EventNotificationLoadedState) {
          return (state.eventNotifications.length == 0)
              ? _buildNoNotification(context)
              : ListView.separated(
                  separatorBuilder: (context, position) {
                    return Divider(
                      height: 5,
                      thickness: 2,
                      indent: 20,
                      endIndent: 20,
                    );
                  },
                  itemBuilder: (context, position) {
                    var notification = state.eventNotifications[position];
                    return _buildNotificationTile(context, notification);
                  },
                  itemCount: state.eventNotifications.length,
                  shrinkWrap: true,
                );
        } else {
          return Center(
              child: Text(
            "Not able to load the notification",
            style: Theme.of(context).textTheme.headline4,
          ));
        }
      }),
    );
  }

  Widget _buildNoNotification(BuildContext context) {
    return Center(
      child: Text(
        "No new Notifications",
        style: Theme.of(context).textTheme.headline4,
      ),
    );
  }

  ListTile _buildNotificationTile(
      BuildContext context, NotificationModel notification) {
    return ListTile(
      title: Text(
        "${notification.eventName}",
        style: Theme.of(context).textTheme.headline4,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              "Room ID - ${notification.roomID}",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              "Room Password - ${notification.roomPassword}",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                "Last Updated: ${notification.time}",
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ),
          ),
        ],
      ),
      isThreeLine: true,
    );
  }
}
