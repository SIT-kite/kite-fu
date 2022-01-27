import 'package:flutter/material.dart';
import 'package:kite_fu/global/init_util.dart';
import 'package:kite_fu/page/fu/fu.dart';
import 'package:kite_fu/page/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initBeforeRun();
  runApp(MaterialApp(
    title: '扫福活动',
    home: const LoginPage(),
    routes: {
      '/login': (context) => const LoginPage(),
      '/fu': (context) => const FuPage(),
    },
    debugShowCheckedModeBanner: false,
  ));
}
