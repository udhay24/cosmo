import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Registration {
  Timestamp date;
  DocumentReference team;
  DocumentReference selectedEvent;
  int selectedSlot;

  Registration({@required this.selectedEvent, @required this.team, @required this.date, @required this.selectedSlot});

  Registration.fromJson(Map<String, dynamic> json) {
    selectedEvent = json['selected_event'];
    team = json['team'];
    date = json['date'];
    selectedSlot = json['selected_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['selected_event'] = this.selectedEvent;
    data['team'] = this.team;
    data['date'] = this.date;
    data['selected_slot'] = this.selectedSlot;
    return data;
  }
}
