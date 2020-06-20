import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:pubg/data_source/model/available_event.dart';
import 'package:pubg/data_source/model/registration.dart';
import 'package:pubg/data_source/model/user_model.dart';
import 'package:pubg/home_screen/model/event_detail.dart';
import 'package:pubg/util/available_slot.dart';

import 'model/team_model.dart';

class UserRepository {
  var _fireStore = Firestore.instance;
  var _firebaseUser = FirebaseAuth.instance.currentUser();

  /// get user detail from firestore 'user' collection
  Future<User> getCurrentUserDetail() async {
    var user = await _firebaseUser;
    var userInfo =
        await _fireStore.collection('users').document(user.uid).get();

    return User.fromJson(userInfo.data);
  }

  Future<DocumentReference> getCurrentUserReference() async {
    var user = await _firebaseUser;
    return _fireStore.collection("users").document(user.uid);
  }

  Future<DocumentReference> getUserRefFromUuid(String uuid) async {
    return _fireStore.collection("users").document(uuid);
  }

  /// checks if the user profile is complete or any detail is missing
  Future<bool> isUserProfileComplete() async {
    try {
      var result = await getCurrentUserDetail();
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
  updateUserDetail(User user) async {
    _fireStore
        .collection('users')
        .document(user.userUuid)
        .setData(user.toJson(), merge: true);
  }

  ///update the user detail
  updateCurrentUserDetail(User user) async {
    var firebaseUser = await _firebaseUser;
    user.userUuid = firebaseUser.uid;
    _fireStore
        .collection('users')
        .document(firebaseUser.uid)
        .setData(user.toJson(), merge: true);
  }

  ///update the user detail
  updateUserFcmCode(String fcmCode) async {
    var firebaseUser = await _firebaseUser;
    _fireStore
        .collection('users')
        .document(firebaseUser.uid)
        .setData({'fcm_code': fcmCode}, merge: true);
  }

  removeCurrentUserFromTeam() async {
    try {
      var team = await getCurrentUserTeam();
      var userID = (await _firebaseUser).uid;

      team.teamMembers.removeWhere((element) {
        return (element.documentID == userID);
      });

      await updateTeamDetail(team);
    } catch (_) {
      print("error removing user from team");
    }
  }

  removeTeamMembershipFromUser(String userID) async {
    try {
      var user = await getUserFromRef(await getUserRefFromUuid(userID));
      var updatedUser = User(userName: user.userName, phoneNumber: user.phoneNumber, userUuid: user.userUuid, joinedTeam: null);
      await updateCurrentUserDetail(updatedUser);
    } catch (_) {
      print("error removing user from team");
    }
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
    var userDetail = await getCurrentUserDetail();
    userDetail.joinedTeam =
        _fireStore.collection("teams").document(teamDocumentID);
    updateCurrentUserDetail(userDetail);
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
    var userDetail = await getCurrentUserDetail();
    userDetail.joinedTeam =
        _fireStore.collection("teams").document(teamDocumentID);
    updateCurrentUserDetail(userDetail);
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
      var userDetail = await getCurrentUserDetail();
      var joinedTeam = await getTeamDetails(userDetail.joinedTeam.documentID);
      var teamOwner = await getUserFromRef(joinedTeam.teamOwner);
      if (teamOwner.userUuid == userDetail.userUuid) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<Team> getCurrentUserTeam() async {
    var user = await getCurrentUserDetail();
    if (user.joinedTeam.documentID == null) {
      return null;
    } else {
      return getTeamDetails(user.joinedTeam.documentID);
    }
  }

  updateTeamDetail(Team team) async {
    var currentTeam = (await getCurrentUserDetail()).joinedTeam;
    currentTeam.setData(team.toJson());
  }

  Future<User> getUserFromRef(DocumentReference docs) async {
    var user = (await docs.get()).data;
    return User.fromJson(user);
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

  Future<DocumentReference> getEventDocFromID(int eventID) async {
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

  Future<EventDetail> getEventDetailFromId(int eventID) async {
    DocumentReference _eventRef = await getEventDocFromID(eventID);
    List<int> availableSlots = await getAvailableSlots(_eventRef);
    AvailableEvent event = await getEventFromRef(_eventRef);
    return EventDetail(
        event: event,
        availableSlots: availableSlots,
        isRegistrationOpen: availableSlots.isNotEmpty);
  }

  //registers current team to the event
  registerTeamForEvent(AvailableEvent event, int slot) async {
    String dateFormat = DateFormat('dd-MM-yyyy').format(DateTime.now());
    var eventRef = await getEventDocFromID(event.eventID);
    var currentTeam = (await getCurrentUserDetail()).joinedTeam;

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

  //get matching team ids
  Future<List<String>> getMatchingTeams(String teamId) async {
    var documents = await _fireStore
        .collection('teams')
        .where('team_id', isEqualTo: teamId)
        .getDocuments();
    return documents.documents.map((e) => e['team_id']).cast<String>().toList();
  }
}
