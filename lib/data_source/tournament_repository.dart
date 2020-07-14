import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pubg/data_source/model/tournament_model.dart';
import 'package:pubg/data_source/user_repository.dart';

class TournamentRepository {
  Firestore _firestore = Firestore.instance;
  UserRepository _userRepository = UserRepository();

  Future<List<TournamentModel>> fetchAllTournaments() async {
    var results =
        await _firestore.collection("available_tournaments").getDocuments();

    return results.documents.map((e) => TournamentModel.fromJson(e.data));
  }

  void registerUserToTournament(int tournamentID) async {
    var userDoc = await _userRepository.getCurrentUserReference();
    var teamDoc = (await _userRepository.getCurrentUserDetail()).joinedTeam;

    await _firestore.runTransaction((transaction) async {
      var registrationDoc =
          _firestore.document("tournament_registrations/$tournamentID");
      var registrationsJson = await transaction.get(registrationDoc);
      var registrations =
          TournamentRegistrationModel.fromJson(registrationsJson.data);
      if (!registrations.registeredMembers.contains(userDoc)) {
        registrations.registeredMembers.add(userDoc);
      }
      if (!registrations.registeredTeams.contains(teamDoc)) {
        registrations.registeredMembers.add(teamDoc);
      }
      transaction.set(registrationDoc, registrations.toJson());
    });
  }

  Future<bool> isUserRegisteredToTournament(int tournamentID) async {
    var userDoc = await _userRepository.getCurrentUserReference();
    var registrationJson = await _firestore
        .document("tournament_registrations/$tournamentID")
        .get();
    var tournamentDetails =
        TournamentRegistrationModel.fromJson(registrationJson.data);
    if (tournamentDetails.registeredMembers.contains(userDoc)) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> isUserTeamRegisteredToTournament(int tournamentID) async {
    var teamDoc = (await _userRepository.getCurrentUserDetail()).joinedTeam;
    var registrationJson = await _firestore
        .document("tournament_registrations/$tournamentID")
        .get();
    var tournamentDetails =
        TournamentRegistrationModel.fromJson(registrationJson.data);
    if (tournamentDetails.registeredTeams.contains(teamDoc)) {
      return true;
    } else {
      return false;
    }
  }
}
