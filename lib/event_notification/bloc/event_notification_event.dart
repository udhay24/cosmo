import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class EventNotificationEvent extends Equatable {}

class LoadEventNotifications extends EventNotificationEvent {
  @override
  List<Object> get props => [];
}