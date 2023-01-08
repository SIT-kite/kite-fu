import 'package:kite_fu/dao/fu.dart';
import 'package:kite_fu/global/env.dart';
import 'package:kite_fu/global/session_pool.dart';
import 'package:kite_fu/mock/fu.dart';

import '../service/fu.dart';

class ServicePool {
  static late FuDao fu;
  static void init() {
    if (currentAppMode == AppMode.mock) {
      fu = FuMock();
    } else {
      fu = FuService(SessionPool.kiteSession);
    }
  }
}
