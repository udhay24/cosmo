import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignin})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn();

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication signInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential authCredential = GoogleAuthProvider.getCredential(idToken: signInAuthentication.idToken, accessToken: signInAuthentication.accessToken);
    await _firebaseAuth.signInWithCredential(authCredential);
    return _firebaseAuth.currentUser();
  }

  Future<FirebaseUser> signInWithEmail(
      String email,
      String password
      ) {
    return  _firebaseAuth.signInWithEmailAndPassword(email: email, password: password).then((value) => value.user);
  }

  Future<FirebaseUser> signUpWithEmail(
      {String email,
      String password}
      ) {
    return _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password).then((value) => value.user);
  }

  Future<void> signOut() {
    return Future.wait([
      _googleSignIn.signOut(),
      _firebaseAuth.signOut()
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<String> getUser() async {
    return (await _firebaseAuth.currentUser()).email;
  }
}