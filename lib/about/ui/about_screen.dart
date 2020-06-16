import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:pubg/util/network_util.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            _buildWelcomeText(),

            Text("Description"),

            ListTile(
              title: Text("Follow us on Instagram"),
              trailing: Icon(FontAwesome.instagram),
              onTap: (){
                launchURL("https://instagram.com/cosmogamingz?igshid=7o93qh2op04u");
              },
            ),
            ListTile(
              title: Text("Join us on Discord"),
              trailing: Icon(FontAwesome.cc_discover),
              onTap: (){
                launchURL("https://discord.com/invite/ZfNZ2nW");
              },
            ),
            ListTile(
              title: Text("Join us on Mixer"),
              trailing: Icon(FontAwesome.mixcloud),
              onTap: (){
                launchURL("https://mixer.com/Havard1511");
              },
            ),
            ListTile(
              title: Text("Join our what's app group"),
              trailing: Icon(FontAwesome.whatsapp),
              onTap: (){
                launchURL("https://chat.whatsapp.com/LQez1dzk6HR31EVG3aN6Np");
              },
            )
          ],
        ),
      ),
    );
  }

  Text _buildWelcomeText() => Text("Welcome to Cosmo Gaming");
}
