import 'package:dio/dio.dart';
import 'package:kite_fu/global/storage_pool.dart';
import 'package:kite_fu/session/kite_session.dart';

class SessionPool {
  static Dio dio = Dio();
  static late KiteSession kiteSession;
  static Future<void> init() async {
    kiteSession = KiteSession(dio, StoragePool.jwt);
  }
}
