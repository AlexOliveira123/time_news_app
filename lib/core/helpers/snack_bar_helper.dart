import 'package:flutter/material.dart';

abstract class SnackBarHelper {
  static void show(BuildContext context, {required String message}) {
    final snackBar = SnackBar(content: Text(message), duration: Durations.long2);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
