import 'package:flutter/material.dart';
import 'package:kite_fu/global/env.dart';
import 'package:kite_fu/global/storage_pool.dart';
import 'package:kite_fu/util/logger.dart';

import 'fu/fu.dart';
import 'login.dart';
import 'not_found.dart';
import 'welcome.dart';

/// 路由表配置
class RouteTable {
  static const indexPath = '/';
  static const welcomePath = '/welcome';
  static const loginPath = '/login';
  static const fuPath = '/fu';
  static const notFoundPath = '/404';

  static final Map<String, WidgetBuilder> table = {
    '/welcome': (context) => const WelcomePage(),
    '/login': (context) => const LoginPage(),
    '/fu': (context) => const FuPage(),
    '/404': (context) => const NotFound(),
  };

  ///路由拦截
  static Route onGenerateRoute(RouteSettings settings) {
    final String name = settings.name!;
    Log.info('跳转路由: $name');
    // 首页
    if (name == indexPath) {
      return MaterialPageRoute(builder: table[welcomePath]!);
    }
    // 路由找不到
    if (!table.containsKey(name)) {
      return MaterialPageRoute(builder: table[notFoundPath]!);
    }

    if (currentAppMode != AppMode.mock) {
      final bool hasAuth = StoragePool.jwt.jwtToken != null;
      if (name == fuPath || name == loginPath) {
        if (hasAuth) {
          return MaterialPageRoute(builder: table[fuPath]!);
        } else {
          return MaterialPageRoute(builder: table[loginPath]!);
        }
      }
    }

    return MaterialPageRoute(builder: table[name]!);
  }
}
