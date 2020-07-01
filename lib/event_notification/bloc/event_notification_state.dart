import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pubg/event_notification/model/notification_model.dart';

@immutable
abstract class EventNotificationState extends Equatable {}

class InitialEventNotificationState extends EventNotificationState {
  @override
  List<Object> get props => [];
}

class EventNotificationLoadedState extends EventNotificationState {
  final List<NotificationModel> eventNotifications;
  
  EventNotificationLoadedState({@required this.eventNotifications});

  @override
  List<Object> get props => [eventNotifications];
}

class LoadingEventNotifications extends EventNotificationState {
  @override
  List<Object> get props => [];
}

class EventNotificationFailureState extends EventNotificationState {
  @override
  List<Object> get props => [];
}