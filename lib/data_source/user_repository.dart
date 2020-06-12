import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pubg/data_source/model/user_detail.dart';

import 'model/team_detail.dart';

class UserRepository {
  var _fireStore = Firestore.instance;
  var _firebaseUser = FirebaseAuth.instance.currentUser();

  /// get user detail from firestore 'user' collection
  Future<UserDetail> getUserDetail() async {
    var user = await _firebaseUser;
    var userInfo = await _fireStore.collection('users').document(user.uid).get();

    return UserDetail.fromJson(userInfo.data);
  }

  /// checks if the user profile is complete or any detail is missing
  Future<bool> isUserProfileComplete() async {
    try {
      var result = await getUserDetail();
      if ((result != null) && (result.userUuid != null) &&
          (result.joinedTeam != null) && (result.phoneNumber != null) &&
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
   _fireStore.collection('users').document(firebaseUser.uid).
    setData(user.toJson());
  }

  ///create a new team and returns the reference
  Future<DocumentReference> createTeam(Team team) async {
    var _reference = _fireStore.collection("teams")
        .document();
    _reference.setData(team.toJson());
    return _reference;
  }

  addCurrentUserToTeamWithCode(String teamID, String teamCode) async {
    var user = await _firebaseUser;
    String teamDocumentID = (await _findTeamDocumentID(teamID, teamCode));
    var existingMembers = (await _getTeamDetails(teamDocumentID)).teamMembers;
    var updatedMembers = existingMembers..add(
      _fireStore.collection('users').document(user.uid)
    );
    _fireStore.collection("teams")
        .document(teamDocumentID)
    .updateData({'team_members': updatedMembers});

    //update the user profile to reflect the change
    var userDetail = await getUserDetail();
    userDetail.joinedTeam = _fireStore.collection("teams").document(teamDocumentID);
    updateUserDetail(userDetail);
  }

  addCurrentUserToTeamWithRef(DocumentReference teamReference) async {
    var user = await _firebaseUser;
    String teamDocumentID = teamReference.documentID;
    var existingMembers = (await _getTeamDetails(teamDocumentID)).teamMembers;
    var updatedMembers = existingMembers..add(
        _fireStore.collection('users').document(user.uid)
    );
    _fireStore.collection("teams")
        .document(teamDocumentID)
        .updateData({'team_members': updatedMembers});

    //update the user profile to reflect the change
    var userDetail = await getUserDetail();
    userDetail.joinedTeam = _fireStore.collection("teams").document(teamDocumentID);
    updateUserDetail(userDetail);
  }

  Future<Team> _getTeamDetails(String teamDocumentID) async {
    var teamDetails = await _fireStore.collection("teams").document(teamDocumentID).get();
    return Team.fromJson(teamDetails.data);
  }


  Future<String> _findTeamDocumentID(String teamID, String teamCode) async {
    var teamDetails = await _fireStore.collection("teams")
        .where("team_id", isEqualTo: teamID)
        .where("team_code", isEqualTo: teamCode)
        .getDocuments();
    return teamDetails.documents[0].documentID;
  }

  Future<Team> findTeam(String teamID, String teamCode) async {
    var teamDetails = await _fireStore.collection("teams")
    .where("team_id", isEqualTo: teamID)
    .where("team_code", isEqualTo: teamCode)
    .getDocuments();
    return Team.fromJson(teamDetails.documents[0].data);
  }

  Future<String> fetchTeamReference(String teamID, String teamCode) async {
    var teamDetails = await _fireStore.collection("teams")
        .where("team_id", isEqualTo: teamID)
        .where("team_code", isEqualTo: teamCode)
        .getDocuments();
    return teamDetails.documents[0].documentID;
  }
}
