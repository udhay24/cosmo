import 'package:flutter/material.dart';

class TeamSubmitButton extends StatelessWidget {
  final VoidCallback _onPressed;

  TeamSubmitButton({Key key, VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      onPressed: _onPressed,
      child: Text('Submit'),
    );
  }
}
