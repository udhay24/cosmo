import 'package:flutter/material.dart';
import 'package:pubg/user_detail/ui/profile_screen_form.dart';

class UserProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Center(
        child: UserProfileForm(),
      ),
    );
  }
}
