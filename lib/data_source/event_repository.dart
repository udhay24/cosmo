import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pubg/data_source/database.dart';
import 'package:pubg/data_source/model/available_event.dart';
import 'package:pubg/data_source/model/event_notification.dart';
import 'package:pubg/data_source/model/registration.dart';
import 'package:pubg/home_screen/model/event_detail.dart';
import 'package:pubg/util/available_slot.dart';
import 'package:pubg/util/time_util.dart';
import 'package:sqflite/sqflite.dart';

class EventRepository {
  var _fireStore = Firestore.instance;
  var db = SqlitePersistence.create();

  Future<List<CosmoGameEvent>> getAvailableEvent() async {
    var documents =
        await _fireStore.collection("available_event").getDocuments();

    return documents.documents
        .map((e) => CosmoGameEvent.fromJson(e.data))
        .toList();
  }

  Future<CosmoGameEvent> getEventInfoFromID(int id) async {
    var events = await _fireStore
        .collection('available_event')
        .where('event_id', isEqualTo: id)
        .getDocuments();

    return CosmoGameEvent.fromJson(events.documents[0].data);
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

  Stream<List<int>> getAvailableSlots(DocumentReference reference) async* {
    var event = await getEventFromRef(reference);

    Stream<QuerySnapshot> availableSlotsQuery = _fireStore
        .collection("registrations/${getCurrentDate()}/${event.eventID}")
        .snapshots();
//        .transform(StreamTransformer<QuerySnapshot, List<int>>.fromHandlers(
//            handleData: (data, sink) {
//     ));

    yield* availableSlotsQuery.map((event) {
      var selectedSlots = event.documents.map((e) {
        return e.data['selected_slot'] as int;
      }).toList();

      List<int> totalSlots =
      List<int>.generate(AvailableSlots.TOTAL_SLOTS, (index) => index + 1);
      List<int> availableSlots = totalSlots
        ..removeWhere((element) => selectedSlots.contains(element));
      return availableSlots;
    });
  }

  Future<DocumentReference> getEventDocFromID(int eventID) async {
    var event = await _fireStore
        .collection("available_event")
        .where("event_id", isEqualTo: eventID)
        .getDocuments();
    return _fireStore
        .collection("available_event")
        .document(event.documents[0].documentID);
  }

  Future<CosmoGameEvent> getEventFromRef(
      DocumentReference documentReference) async {
    var eventData = (await documentReference.get()).data;
    return CosmoGameEvent.fromJson(eventData);
  }

  Future<SelectedEventDetail> getEventDetailFromId(int eventID) async {
    DocumentReference _eventRef = await getEventDocFromID(eventID);
    Stream<List<int>> availableSlots = getAvailableSlots(_eventRef);
    CosmoGameEvent event = await getEventFromRef(_eventRef);
    return SelectedEventDetail(event: event, availableSlots: availableSlots);
  }

  //registers current team to the event
  registerTeamForEvent(CosmoGameEvent event, int slot,
      DocumentReference currentTeam) async {
    String dateFormat = DateFormat('dd-MM-yyyy').format(DateTime.now());
    var eventRef = await getEventDocFromID(event.eventID);

    _fireStore
        .collection("registrations/$dateFormat/${event.eventID}")
        .document(currentTeam.documentID)
        .setData(Registration(
        selectedEvent: eventRef,
        team: currentTeam,
        selectedSlot: slot,
        date: Timestamp.now())
        .toJson());
  }
}
