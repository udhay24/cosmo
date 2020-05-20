import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    return user;
  }

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration:
                  InputDecoration(border: InputBorder.none, hintText: "E-Mail"),
              controller: _emailController,
            ),
            TextField(
              decoration:
                  InputDecoration(border: InputBorder.none, hintText: "E-Mail"),
              controller: _passwordController,
            ),
            Builder(builder: (context) {
              return RaisedButton(
                child: Text("Ok"),
                onPressed: () async {
                  _auth
                      .fetchSignInMethodsForEmail(email: _emailController.text)
                      .then((value) {
                    if (value.length == 0) {
                      _auth
                          .createUserWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text)
                          .then((value) {
                        if (value.user == null) {
                        print("Error signing up");
                        } else {
                          print("Welcome ${value.user.displayName}");
                        }
                      });
                    } else {
                      _auth
                          .signInWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text)
                          .then((value) {
                        if (value.user == null) {
                          print("Error signing in");
                        } else {
                          print("Welcome ${value.user.displayName}");
                        }
                      });
                    }
                  });
                  FirebaseUser _user = await _auth.currentUser();
                  if (_user.displayName == null || _user.phoneNumber == null) {
                    Navigator.of(context).pushNamed('/detail');
                  }
                },
              );
            }),

            RaisedButton(
              child: Text("Sign in"),
              onPressed: () async {
                FirebaseUser user = await _handleSignIn();
                if (user == null) {
                  SnackBar(
                    content: Text("Sign in failed"),
                  );
                } else {
                  SnackBar(
                    content: Text("Welcome ${user.displayName}"),
                  );
                  Navigator.of(context).pushNamed('/home');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
