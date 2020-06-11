import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pubg/data_source/model/available_event.dart';

class EventRepository {
  var _fireStore = Firestore.instance;
  
  Future<List<AvailableEvent>> getAvailableEvent() async {
    var documents = await _fireStore
        .collection("available_event")
        .getDocuments();

    return documents.documents.map((e) => AvailableEvent.fromJson(e.data)).toList();
  }
}