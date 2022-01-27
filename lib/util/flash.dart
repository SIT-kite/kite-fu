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
        child: FlashBar(
          content: content,
        ),
      );
    },
  );
}
