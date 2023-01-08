import 'package:dio/dio.dart';
import 'package:kite_fu/global/storage_pool.dart';
import 'package:kite_fu/session/kite_session.dart';

class SessionPool {
  static late KiteSession kiteSession;
  static Dio _initDio() {
    Dio dio = Dio();
    // 设置默认超时时间
    dio.options.connectTimeout = 10 * 1000;
    dio.options.sendTimeout = 10 * 1000;
    dio.options.receiveTimeout = 10 * 1000;

    return dio;
  }

  static Future<void> init() async {
    final dio = _initDio();
    kiteSession = KiteSession(dio, StoragePool.jwt);
  }
}
