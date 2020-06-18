import 'package:flutter/material.dart';

class TeamSubmitButton extends StatelessWidget {
  final VoidCallback _onPressed;

  TeamSubmitButton({Key key, VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.0),
        ),
        onPressed: _onPressed,
        textColor: Colors.blue,
        disabledTextColor: Colors.grey,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Text('Submit'),
      ),
    );
  }
}
