import 'package:flutter/material.dart';
import 'package:kite_fu/page/fu/fu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    title: '扫福活动',
    home: FuPage(),
  ));
}
