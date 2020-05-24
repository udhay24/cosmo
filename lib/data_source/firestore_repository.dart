import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:pubg/data_source/model/team_detail.dart';

class FireStoreRepository {
  final Firestore firestore = Firestore(app: FirebaseApp.instance);

  final Future<FirebaseUser> _firebaseUser =
  FirebaseAuth.instance.currentUser();

  Future<TeamDetail> fetchTeamDetails() async {
    String userId = (await _firebaseUser).uid;
    return firestore
        .collection("team_details")
        .document(userId)
        .snapshots()
        .first
        .then((value) {
      var event = value.data;
      return TeamDetail(
          pubgName: event['pubg_name'],
          teamName: event['team_name'],
          phoneNumber: event['phone_number'],
          teamMembers: event['team_member']);
    });
  }

  Future<void> updateTeamDetails(TeamDetail teamDetail) async {
    String userId = (await _firebaseUser).uid;
    return firestore
        .collection("team_details")
        .document(userId)
        .updateData(<String, dynamic>{
      'pubg_name': teamDetail.pubgName,
      'team_name': teamDetail.teamName,
      'phone_number': teamDetail.phoneNumber,
      'team_member': teamDetail.teamMembers,
    });
  }

  Future<void> createTeamDetails(TeamDetail teamDetail) async {
    String userId = (await _firebaseUser).uid;
    return firestore
        .collection("team_details")
        .document(userId)
        .setData(<String, dynamic>{
      'pubg_name': teamDetail.pubgName,
      'team_name': teamDetail.teamName,
      'phone_number': teamDetail.phoneNumber,
      'team_member': teamDetail.teamMembers,
    });
  }

  Future<bool> containsTeamDetails() async {
    String userId = (await _firebaseUser).uid;
    return firestore
        .collection("team_details")
        .document(userId)
        .snapshots()
        .first
        .then((value) {
      var event = value.data;
      if (event == null) {
        return false;
      } else {
        return true;
      }
    }, onError: () {
      return false;
    });
  }

  Future<List<int>> getAvailableSlots(String selectedTimeSlot) async {
    String dateFormat = DateFormat('dd_MM_yyyy').format(DateTime.now());

    List<int> selectedSlots = await firestore.collection(
        "$selectedTimeSlot/$dateFormat/selected_slots")
        .getDocuments()
        .then((value) {
      return value.documents.map((e) => int.parse(e.data['selected_slot']))
          .toList();
    });

    return selectedSlots;
  }

  Future<void> selectSlot(int slot, String selectedTimeSlot) async {
    String dateFormat = DateFormat('dd_MM_yyyy').format(DateTime.now());
    var user = await _firebaseUser;

    firestore.collection("$selectedTimeSlot/$dateFormat/selected_slots")
    .add(<String, dynamic> {
      'selected_slot': slot,
      'user_id': user.uid
    });
  }
}