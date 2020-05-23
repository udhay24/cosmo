import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pubg/data_source/model/user_detail.dart';

class FireStoreRepository {
  final Firestore firestore = Firestore(app: FirebaseApp.instance);

  final Future<FirebaseUser> _firebaseUser =
      FirebaseAuth.instance.currentUser();

  Future<UserDetail> fetchTeamDetails() async {
    String userId = (await _firebaseUser).uid;
    return firestore
        .collection("team_details")
        .document(userId)
        .snapshots()
        .first
        .then((value) {
      var event = value.data;
      return UserDetail(
          pubgName: event['pubg_name'],
          teamName: event['team_name'],
          phoneNumber: event['phone_number'],
          teamMembers: event['team_member']);
    });
  }

  Future<void> updateTeamDetails(UserDetail teamDetail) async {
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
}
