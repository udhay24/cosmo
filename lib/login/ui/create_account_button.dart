import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pubg/data_source/user_repository.dart';
import 'package:pubg/register/ui/register_screen.dart';

class CreateAccountButton extends StatelessWidget {
  final UserRepository _userRepository;

  CreateAccountButton({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return RegisterScreen(userRepository: _userRepository);
        }));
      },
      child: Text(
        'SIGN UP NOW',
        style: GoogleFonts.openSansCondensed(
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}
