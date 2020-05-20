import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EnterDetailsScreen extends StatelessWidget {
  final Future<FirebaseUser> _user = FirebaseAuth.instance.currentUser();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  String _verificationId = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Enter your phone number"),
            TextField(
              decoration: InputDecoration(hintText: "Enter phone number"),
              controller: _phoneNumberController,
                keyboardType: TextInputType.number
            ),
            Text("Enter the user name"),
            TextField(
              decoration: InputDecoration(hintText: "Enter your name"),
              controller: _userNameController,
            ),
            TextField(
              decoration: InputDecoration(hintText: "Enter your code"),
              controller: _codeController,
                keyboardType: TextInputType.number

            ),
            RaisedButton(
              child: Text("Get Code"),
              onPressed: () async {
                FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber: "+91-70100 65028",
                    timeout: Duration(minutes: 2),
                    verificationCompleted: (credentials) async {
                      (await _user).updatePhoneNumberCredential(credentials);
                    },
                    verificationFailed: null,
                    codeSent: (verificationId, [forceResendingToken]) async {
                      _verificationId = verificationId;
                      // get the SMS code from the user somehow (probably using a text field)

                    },
                    codeAutoRetrievalTimeout: null);

              },
            ),
            RaisedButton(
              child: Text("Update"),
              onPressed: () async {
                String smsCode = _codeController.text;
                final AuthCredential credential =
                PhoneAuthProvider.getCredential(
                    verificationId: _verificationId, smsCode: smsCode);
                await (await FirebaseAuth.instance.currentUser())
                    .updatePhoneNumberCredential(credential);

                var userData = UserUpdateInfo();
                userData.displayName = _userNameController.text;
                FirebaseAuth.instance.currentUser().then(
                        (value) => value.updateProfile(userData).then((value) {
                      Navigator.pushNamed(context, '/home');
                    }).catchError(() {
                      print("Something went wrong");
                    }));
              },
            )
          ],
        ),
      ),
    );
  }
}
