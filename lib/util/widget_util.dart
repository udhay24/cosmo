
import 'package:flutter/material.dart';

SnackBar buildSnackBar(String text) {
  return SnackBar(
    content: Text(text),
    elevation: 10,
  );
}

SnackBar buildLoadingSnackBar(String text) {
  return SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(text),
          SizedBox(
            width: 10,
          ),
          SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          )
        ],
      ),
      elevation: 10);
}
