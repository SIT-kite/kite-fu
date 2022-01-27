import 'package:kite_fu/dao/jwt.dart';
import 'package:kite_fu/storage/jwt.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoragePool {
  static late JwtDao jwt;
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    jwt = JwtStorage(prefs);
  }
}
