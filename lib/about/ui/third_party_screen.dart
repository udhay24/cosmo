import 'package:flutter/material.dart';

class ThirdPartyScreen extends StatelessWidget {
  final List<String> thirdPartySoftware = [
    "firebase_auth",
    "google_sign_in",
    "equatable",
    "firebase_core",
    "firebase_analytics",
    "flutter_bloc",
    "rxdart",
    "font_awesome_flutter",
    "cloud_firestore",
    "intl",
    "package_info",
    "google_fonts",
    "flutter_launcher_icons",
    "firebase_messaging",
    "flutter_icons",
    "url_launcher",
    "lottie",
    "sqflite",
    "path",
    "Icons by Icons8"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => Navigator.of(context).pop()),
        title: Text("Third Party Software"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Third-party Licenses",
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            Text(
              "Several fantastic free and open source third party software have helped us to created this project. a few of them required us to include their license agreement. hence we have included the entire list below",
              style: Theme.of(context).textTheme.headline5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Third party software which are part of the flutter-android client:",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            ListView.separated(
              padding: EdgeInsets.all(8),
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, position) {
                return Text(
                  thirdPartySoftware[position],
                  style: Theme.of(context).textTheme.subtitle1,
                );
              },
              separatorBuilder: (context, position) {
                return SizedBox(
                  height: 10,
                );
              },
              itemCount: thirdPartySoftware.length,
              shrinkWrap: true,
            ),
          ],
        ),
      ),
    );
  }
}
