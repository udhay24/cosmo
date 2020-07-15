import 'package:flutter/material.dart';

class RequiredRegistrationsModel {
  final String platformName;
  final String platformUrl;
  bool isSubscribed = false;

  RequiredRegistrationsModel(
      {@required this.platformName, @required this.platformUrl});
}
