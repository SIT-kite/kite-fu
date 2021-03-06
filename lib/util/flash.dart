/*

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

Future<void> showBasicFlash(
  BuildContext context,
  Widget content, {
  Duration? duration,
  flashStyle = FlashBehavior.floating,
}) async {
  await showFlash(
    context: context,
    duration: duration ?? const Duration(seconds: 1),
    builder: (context, controller) {
      return Flash(
        controller: controller,
        behavior: flashStyle,
        position: FlashPosition.bottom,
        boxShadows: kElevationToShadow[4],
        horizontalDismissDirection: HorizontalDismissDirection.horizontal,
        child: FlashBar(content: content),
      );
    },
  );
}

*/

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
