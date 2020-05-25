import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback _onPressed;

  LoginButton({Key key, VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
        side: BorderSide(color: Colors.white, width: 1)
      ),
      disabledTextColor: Colors.red,
      textColor: Colors.white,
      onPressed: _onPressed,
      color: Colors.transparent,
      child: Text(
        'LOGIN NOW',
        style: GoogleFonts.openSansCondensed(fontWeight: FontWeight.bold),
      ),
    );
  }
}
