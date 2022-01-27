import 'package:kite_fu/util/logger.dart';

import 'session_pool.dart';
import 'storage_pool.dart';

/// 应用启动前需要的初始化
Future<void> initBeforeRun() async {
  // Future.wait可以使多个Future并发执行
  Log.info('开始应用开启前的初始化');
  // 由于网络层需要依赖存储层的缓存
  // 所以必须先初始化存储层，在初始化网络层
  await StoragePool.init();
  await SessionPool.init();
  // ServicePool.init();
  Log.info('应用开启前初始化完成');
}
