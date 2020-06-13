import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:pubg/data_source/model/available_event.dart';
import 'package:pubg/data_source/model/registration.dart';
import 'package:pubg/data_source/model/user_detail.dart';
import 'package:pubg/util/available_slot.dart';

import 'model/team_detail.dart';

class UserRepository {
  var _fireStore = Firestore.instance;
  var _firebaseUser = FirebaseAuth.instance.currentUser();

  /// get user detail from firestore 'user' collection
  Future<UserDetail> getUserDetail() async {
    var user = await _firebaseUser;
    var userInfo =
        await _fireStore.collection('users').document(user.uid).get();

    return UserDetail.fromJson(userInfo.data);
  }

  Future<DocumentReference> getCurrentUserReference() async {
    var user = await _firebaseUser;
    return _fireStore.collection("users").document(user.uid);
  }

  /// checks if the user profile is complete or any detail is missing
  Future<bool> isUserProfileComplete() async {
    try {
      var result = await getUserDetail();
      if ((result != null) &&
          (result.userUuid != null) &&
          (result.joinedTeam != null) &&
          (result.phoneNumber != null) &&
          (result.userName != null)) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print("isUserProfileComplete error: $error");
      return false;
    }
  }

  ///update the user detail
  updateUserDetail(UserDetail user) async {
    var firebaseUser = await _firebaseUser;
    user.userUuid = firebaseUser.uid;
    _fireStore
        .collection('users')
        .document(firebaseUser.uid)
        .setData(user.toJson());
  }

  removeUserFromTeam() async {
    var team = await getCurrentUserTeam();
    var userID = (await _firebaseUser).uid;

    team.teamMembers.removeWhere((element) {
      return (element.documentID == userID);
    });

    await updateTeamDetail(team);
  }

  ///create a new team and returns the reference
  Future<DocumentReference> createTeam(Team team) async {
    var _reference = _fireStore.collection("teams").document();
    _reference.setData(team.toJson());
    return _reference;
  }

  addCurrentUserToTeamWithCode(String teamID, String teamCode) async {
    var user = await _firebaseUser;
    String teamDocumentID = (await _findTeamDocumentID(teamID, teamCode));
    var existingMembers = (await getTeamDetails(teamDocumentID)).teamMembers;
    if (!existingMembers
        .contains(_fireStore.collection('users').document(user.uid))) {
      existingMembers..add(_fireStore.collection('users').document(user.uid));
    }
    _fireStore
        .collection("teams")
        .document(teamDocumentID)
        .updateData({'team_members': existingMembers});

    //update the user profile to reflect the change
    var userDetail = await getUserDetail();
    userDetail.joinedTeam =
        _fireStore.collection("teams").document(teamDocumentID);
    updateUserDetail(userDetail);
  }

  addCurrentUserToTeamWithRef(DocumentReference teamReference) async {
    var user = await _firebaseUser;
    String teamDocumentID = teamReference.documentID;
    var existingMembers = (await getTeamDetails(teamDocumentID)).teamMembers;
    if (!existingMembers
        .contains(_fireStore.collection('users').document(user.uid))) {
      existingMembers..add(_fireStore.collection('users').document(user.uid));
    }
    _fireStore
        .collection("teams")
        .document(teamDocumentID)
        .updateData({'team_members': existingMembers});

    //update the user profile to reflect the change
    var userDetail = await getUserDetail();
    userDetail.joinedTeam =
        _fireStore.collection("teams").document(teamDocumentID);
    updateUserDetail(userDetail);
  }

  Future<Team> getTeamDetails(String teamDocumentID) async {
    var teamDetails =
        await _fireStore.collection("teams").document(teamDocumentID).get();
    return Team.fromJson(teamDetails.data);
  }

  Future<String> _findTeamDocumentID(String teamID, String teamCode) async {
    var teamDetails = await _fireStore
        .collection("teams")
        .where("team_id", isEqualTo: teamID)
        .where("team_code", isEqualTo: teamCode)
        .getDocuments();
    return teamDetails.documents[0].documentID;
  }

  Future<Team> findTeam(String teamID, String teamCode) async {
    var teamDetails = await _fireStore
        .collection("teams")
        .where("team_id", isEqualTo: teamID)
        .where("team_code", isEqualTo: teamCode)
        .getDocuments();
    return Team.fromJson(teamDetails.documents[0].data);
  }

  Future<String> fetchTeamReference(String teamID, String teamCode) async {
    var teamDetails = await _fireStore
        .collection("teams")
        .where("team_id", isEqualTo: teamID)
        .where("team_code", isEqualTo: teamCode)
        .getDocuments();
    return teamDetails.documents[0].documentID;
  }

  Future<bool> doesOwnTeam() async {
    try {
      var authUser = await _firebaseUser;
      var userDetail = await getUserDetail();
      var joinedTeam = await getTeamDetails(userDetail.joinedTeam.documentID);
      if (joinedTeam.teamOwner.documentID == authUser.uid) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<Team> getCurrentUserTeam() async {
    var user = await getUserDetail();
    return getTeamDetails(user.joinedTeam.documentID);
  }

  updateTeamDetail(Team team) async {
    var currentTeam = (await getUserDetail()).joinedTeam;
    currentTeam.setData(team.toJson());
  }

  Future<String> getUserNamesFromRef(DocumentReference docs) async {
    var user = (await docs.get()).data;
    return UserDetail.fromJson(user).userName;
  }

  ///events functions
  Future<List<int>> getAvailableSlots(DocumentReference reference) async {
    var event = await getEventFromRef(reference);
    String dateFormat = DateFormat('dd-MM-yyyy').format(DateTime.now());

    List<int> selectedSlots = await _fireStore
        .collection("registrations/$dateFormat/${event.eventID}")
        .getDocuments()
        .then((value) {
      return value.documents.map((e) {
        return e.data['selected_slot'] as int;
      }).toList();
    });

    List<int> totalSlots =
        List<int>.generate(AvailableSlots.TOTAL_SLOTS, (index) => index + 1);
    List<int> availableSlots = totalSlots
      ..removeWhere((element) => selectedSlots.contains(element));
    return availableSlots;
  }

  Future<DocumentReference> getEventDocFromID(String eventID) async {
    var event = await _fireStore
        .collection("available_event")
        .where("event_id", isEqualTo: eventID)
        .getDocuments();
    return _fireStore
        .collection("available_event")
        .document(event.documents[0].documentID);
  }

  Future<AvailableEvent> getEventFromRef(
      DocumentReference documentReference) async {
    var eventData = (await documentReference.get()).data;
    return AvailableEvent.fromJson(eventData);
  }

  //registers current team to the event
  registerTeamForEvent(AvailableEvent event, int slot) async {
    String dateFormat = DateFormat('dd-MM-yyyy').format(DateTime.now());
    var user = await _firebaseUser;

    var eventRef = await getEventDocFromID(event.eventID);
    var currentTeam = (await getUserDetail()).joinedTeam;

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
