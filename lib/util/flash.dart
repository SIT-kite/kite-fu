import 'package:flutter/material.dart';

Future<void> showBasicFlash(
  BuildContext context,
  Widget content, {
  Duration? duration,
}) async {
  final snackBar = SnackBar(
    content: DefaultTextStyle(
      child: content,
      style: const TextStyle(color: Colors.black),
    ),
    shape: Border.all(color: Colors.grey),
    backgroundColor: Colors.white,
    duration: duration ?? const Duration(seconds: 3),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
