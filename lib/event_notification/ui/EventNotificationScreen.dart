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
              ? _buildNoNotification()
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
                    return _buildNotificationTile(notification);
                  },
                  itemCount: state.eventNotifications.length,
                  shrinkWrap: true,
                );
        } else {
          return Center(child: Text("No able to load the notification"));
        }
      }),
    );
  }

  Widget _buildNoNotification() {
    return Center(
      child: Text("No new Notifications"),
    );
  }

  ListTile _buildNotificationTile(NotificationModel notification) {
    return ListTile(
      title: Text("${notification.eventName}"),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Room ID - ${notification.roomID}"),
          Text("Room Password - ${notification.roomPassword}")
        ],
      ),
      isThreeLine: true,
    );
  }
}
