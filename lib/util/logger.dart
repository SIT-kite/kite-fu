import 'package:intl/intl.dart';

/// 日志工具类
class Log {
  static final dateFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
  static String _getCaller(int deep) {
    return StackTrace.current.toString().split('\n')[deep].trim().replaceAll('    ', ' ');
  }

  static void _log(String type, dynamic message) {
    print('${getCurrentTime()}  INFO  $message');
  }

  static String getCurrentTime() {
    final time = DateTime.now();
    return dateFormat.format(time);
  }

  static void info(dynamic m) {
    _log('INFO', m);
  }

  static void debug(dynamic m) {
    _log('DEBUG', m);
  }
}
