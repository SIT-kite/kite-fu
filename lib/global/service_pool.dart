import 'package:kite_fu/dao/fu.dart';
import 'package:kite_fu/global/session_pool.dart';
import 'package:kite_fu/service/kite/fu.dart';

class ServicePool {
  static late FuDao fu;
  void init() {
    fu = FuService(SessionPool.kiteSession);
  }
}
