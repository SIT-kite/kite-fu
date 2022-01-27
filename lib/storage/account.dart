import 'dart:convert';

import 'package:kite_fu/dao/account.dart';
import 'package:kite_fu/entity/account.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountStorage implements AccountDao {
  static const String namespace = '/account';
  SharedPreferences prefs;
  AccountStorage(this.prefs);

  @override
  KiteUser? get account {
    if (!prefs.containsKey(namespace)) {
      return null;
    }
    try {
      String ret = prefs.getString(namespace)!;
      return KiteUser.fromJson(jsonDecode(ret));
    } catch (e) {
      return null;
    }
  }

  @override
  set account(KiteUser? foo) {
    if (foo == null) {
      prefs.remove(namespace);
      return;
    }
    prefs.setString(namespace, jsonEncode(foo.toJson()));
  }
}
