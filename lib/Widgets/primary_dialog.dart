import 'package:flutter/material.dart';

class PrimaryDialog {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String body,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
           // add any button and perform actions here
          ],
        );
      },
    );
  }
}
