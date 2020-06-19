import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pubg/data_source/database.dart';
import 'package:pubg/data_source/model/available_event.dart';
import 'package:pubg/data_source/model/event_notification.dart';
import 'package:sqflite/sqflite.dart';

class EventRepository {
  var _fireStore = Firestore.instance;
  var db = SqlitePersistence.create();

  Future<List<AvailableEvent>> getAvailableEvent() async {
    var documents =
        await _fireStore.collection("available_event").getDocuments();

    return documents.documents
        .map((e) => AvailableEvent.fromJson(e.data))
        .toList();
  }

  Future<AvailableEvent> getEventInfoFromID(int id) async {
    var events = await _fireStore
        .collection('available_event')
        .where('event_id', isEqualTo: id)
        .getDocuments();

    return AvailableEvent.fromJson(events.documents[0].data);
  }

  addEventDetailsToDatabase(EventNotification eventDetails) async {
    try {
      final database = await db;
      final result = await database.db.insert(
          SqlitePersistence.EventNotificationTableName, eventDetails.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      print(result);
    } catch (error) {
      print(error);
    }
  }

  Future<List<EventNotification>> getAllNotificationEvent() async {
    final database = (await db).db;
    final List<Map<String, dynamic>> maps =
        await database.query(SqlitePersistence.EventNotificationTableName);
    return maps
        .map((e) => EventNotification.fromJson(e))
        .cast<EventNotification>()
        .toList();
  }
}
