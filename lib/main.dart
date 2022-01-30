import 'package:flutter/material.dart';
import 'package:kite_fu/global/init_util.dart';
import 'package:kite_fu/page/fu/fu.dart';
import 'package:kite_fu/page/login.dart';
import 'package:kite_fu/page/route_table.dart';

import 'global/storage_pool.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initBeforeRun();

  const primaryColor = Colors.red;
  final themeData = ThemeData(primaryColor: primaryColor, primarySwatch: createThemeSwatch(primaryColor));

  runApp(MaterialApp(
    theme: themeData,
    initialRoute: RouteTable.indexPath,
    onGenerateRoute: RouteTable.onGenerateRoute,
    title: '2022 新春迎福',
    routes: {
      '/login': (context) {
        if (StoragePool.jwt.jwtToken != null) {
          Navigator.pushReplacementNamed(context, '/fu');
        }
        return const LoginPage();
      },
      '/fu': (context) {
        if (StoragePool.jwt.jwtToken == null) {
          Navigator.pushReplacementNamed(context, '/login');
        }
        return const FuPage();
      },
    },
    debugShowCheckedModeBanner: false,
  ));
}

MaterialColor createThemeSwatch(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
