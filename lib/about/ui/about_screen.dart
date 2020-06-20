import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pubg/util/network_util.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildWelcomeText(),
              ),
              Divider(
                thickness: 2,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Hello there boys and girls..! Want to be part of epic fights and raids,fun gameplay and out of the world driving and custom room matches, then you have joined the right places.you won't be disappointed as there will be no shortage of awesomeness.",
                  style: GoogleFonts.sourceSansPro(),
                ),
              ),
              ListTile(
                title: Text(
                  "Follow us on Instagram",
                  style: GoogleFonts.sourceSansPro(),
                ),
                trailing: SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset('assets/icons/instagram-48.png')),
                onTap: () {
                  launchURL(
                      "https://instagram.com/cosmogamingz?igshid=7o93qh2op04u");
                },
              ),
              ListTile(
                title: Text(
                  "Join us on Discord",
                  style: GoogleFonts.sourceSansPro(),
                ),
                trailing: SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset('assets/icons/discord-64.png')),
                onTap: () {
                  launchURL("https://discord.com/invite/ZfNZ2nW");
                },
              ),
              ListTile(
                title: Text(
                  "Join us on Mixer",
                  style: GoogleFonts.sourceSansPro(),
                ),
                trailing: SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset('assets/icons/mixer-logo-64.png')),
                onTap: () {
                  launchURL("https://mixer.com/Havard1511");
                },
              ),
              ListTile(
                title: Text(
                  "Join our what's app group",
                  style: GoogleFonts.sourceSansPro(),
                ),
                trailing: SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset('assets/icons/whatsapp-30.png')),
                onTap: () {
                  launchURL("https://chat.whatsapp.com/LQez1dzk6HR31EVG3aN6Np");
                },
              ),
              ListTile(
                title: Text(
                  "Follow our Facebook page",
                  style: GoogleFonts.sourceSansPro(),
                ),
                trailing: SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset('assets/icons/facebook-48.png')),
                onTap: () {
                  launchURL(
                      "https://www.facebook.com/Team-Cosmos-111189120584649/");
                },
              ),
              ListTile(
                title: Text(
                  "Check out our videos on TikTok",
                  style: GoogleFonts.sourceSansPro(),
                ),
                trailing: SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset('assets/icons/tiktok-48.png')),
                onTap: () {
                  launchURL("https://vm.tiktok.com/JJjf3cM/");
                },
              ),
              ListTile(
                title: Text(
                  "Check out our videos on YouTube",
                  style: GoogleFonts.sourceSansPro(),
                ),
                trailing: SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset('assets/icons/youtube-48.png')),
                onTap: () {
                  launchURL(
                      "https://www.youtube.com/channel/UCVJWGqiu1NYP0yG7-bkCSog");
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Made with ❤️ by Team Cosmo",
                    style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Text _buildWelcomeText() => Text(
        "Welcome to Cosmo Gaming",
        style: GoogleFonts.sourceSansPro(
          fontWeight: FontWeight.w600,
          fontSize: 20
        ),
      );
}
