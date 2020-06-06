import 'package:cloud_firestore/cloud_firestore.dart';

class Registration {
  Timestamp selectedSlot;
  DocumentReference team;
  DocumentReference date;

  Registration({this.selectedSlot, this.team, this.date});

  Registration.fromJson(Map<String, dynamic> json) {
    selectedSlot = json['selected_slot'];
    team = json['team'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['selected_slot'] = this.selectedSlot;
    data['team'] = this.team;
    data['date'] = this.date;
    return data;
  }
}
