// 导出一些测试环境下常用的东西
// 这里填写用于测试的用户名密码
import 'package:kite_fu/global/session_pool.dart';
import 'package:kite_fu/global/storage_pool.dart';

export 'package:flutter_test/flutter_test.dart';
export 'package:kite_fu/global/session_pool.dart';
export 'package:kite_fu/global/storage_pool.dart';
export 'package:kite_fu/util/logger.dart';

const String username = '';
const String password = '';

/// 测试前调用该函数做初始化
Future<void> init() async {
  await StoragePool.init();
  await SessionPool.init();
}
