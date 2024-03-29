import 'package:kite_fu/dao/account.dart';
import 'package:kite_fu/dao/jwt.dart';
import 'package:kite_fu/global/env.dart';
import 'package:kite_fu/mock/fu.dart';
import 'package:kite_fu/storage/account.dart';
import 'package:kite_fu/storage/jwt.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoragePool {
  static late JwtDao jwt;
  static late AccountDao account;
  static Future<void> init() async {
    if (currentAppMode == AppMode.mock) {
      jwt = JwtStorageMock();
      account = AccountMock();
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    jwt = JwtStorage(prefs);
    account = AccountStorage(prefs);
  }
}
