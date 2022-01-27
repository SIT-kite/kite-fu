import 'package:dio/dio.dart';
import 'package:kite_fu/dao/jwt.dart';
import 'package:kite_fu/session/kite_session.dart';
import 'package:kite_fu/storage/jwt.dart';

class SessionPool {
  static Dio dio = Dio();
  static JwtDao jwt = JwtStorage();
  static late KiteSession kiteSession;
  static Future<void> init() async {
    kiteSession = KiteSession(dio, jwt);
  }
}
