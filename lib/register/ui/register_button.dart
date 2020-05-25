import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  final VoidCallback _onPressed;

  RegisterButton({Key key, VoidCallback onPressed})
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
      color: Colors.transparent,
      onPressed: _onPressed,
      child: Text('Register'),
    );
  }
}