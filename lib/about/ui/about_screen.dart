import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info/package_info.dart';
import 'package:pubg/bloc/navigation/bloc.dart';
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
          padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildWelcomeText(context),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "About Us",
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              Text(
                "Hello there boys and girls..! Want to be part of epic fights and raids,fun gameplay and out of the world driving and custom room matches, then you have joined the right places.you won't be disappointed as there will be no shortage of awesomeness.",
                style: Theme.of(context).textTheme.subtitle1,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text("Social Media",
                    style: Theme.of(context).textTheme.headline4),
              ),
              ListTile(
                title: Text(
                  "Follow us on Instagram",
                ),
                trailing: SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset('assets/icons/instagram-48.png')),
                onTap: () {
                  launchURL(
                      url:
                          "https://instagram.com/cosmogamingz?igshid=7o93qh2op04u");
                },
              ),
              ListTile(
                title: Text(
                  "Join us on Discord",
                ),
                trailing: SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset('assets/icons/discord-64.png')),
                onTap: () {
                  launchURL(url: "https://discord.com/invite/ZfNZ2nW");
                },
              ),
              ListTile(
                title: Text(
                  "Join us on Twitch",
                ),
                trailing: SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset('assets/icons/twitch-48.png')),
                onTap: () {
                  launchURL(url: "https://www.twitch.tv/cosmo_gamingz");
                },
              ),
              ListTile(
                title: Text(
                  "Join our what's app group",
                ),
                trailing: SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset('assets/icons/whatsapp-30.png')),
                onTap: () {
                  launchURL(
                      url: "https://chat.whatsapp.com/JzlCRzapzOr86f41k1nTE1");
                },
              ),
              ListTile(
                title: Text(
                  "Follow our Facebook page",
                ),
                trailing: SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset('assets/icons/facebook-48.png')),
                onTap: () {
                  launchURL(
                      url:
                      "https://www.facebook.com/Team-Cosmos-111189120584649/");
                },
              ),
              ListTile(
                title: Text(
                  "Check out our videos on TikTok",
                ),
                trailing: SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset('assets/icons/tiktok-48.png')),
                onTap: () {
                  launchURL(url: "https://vm.tiktok.com/JJjf3cM/");
                },
              ),
              ListTile(
                title: Text(
                  "Check out our videos on YouTube",
                ),
                trailing: SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset('assets/icons/youtube-48.png')),
                onTap: () {
                  launchURL(
                      url:
                      "https://www.youtube.com/channel/UCVJWGqiu1NYP0yG7-bkCSog");
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Other",
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline4,
                ),
              ),
              ListTile(
                title: Text(
                  "Third party software used",
                ),
                onTap: () {
                  BlocProvider.of<NavigationBloc>(context)
                      .add(ThirdPartyScreenNavigationEvent());
                },
              ),
              ListTile(
                title: Text(
                  "Privacy Policy",
                ),
                onTap: () {
                  launchURL(
                    url:
                        "https://sites.google.com/view/cosmo-privacy-policy/home",
                  );
                },
              ),
              ListTile(
                title: Text(
                  "App Version",
                ),
                subtitle: FutureBuilder(
                  builder: (context, AsyncSnapshot<PackageInfo> snapshot) {
                    if ((snapshot != null) && (snapshot.hasData)) {
                      return Text(
                        snapshot.data.version,
                        style: Theme.of(context).textTheme.subtitle1,
                      );
                    } else {
                      return Text("-");
                    }
                  },
                  future: PackageInfo.fromPlatform(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Made with ❤️ by Team Cosmo",
                    style: Theme
                        .of(context)
                        .textTheme
                        .subtitle1,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeText(BuildContext context) =>
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            "Welcome to Cosmo Gaming",
            style: Theme
                .of(context)
                .textTheme
                .headline3,
          ),
        ),
      );
}
