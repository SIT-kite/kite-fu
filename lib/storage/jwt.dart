import 'package:kite_fu/dao/jwt.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JwtStorage implements JwtDao {
  static const String namespace = '/jwt';
  SharedPreferences prefs;
  JwtStorage(this.prefs);

  @override
  set jwtToken(String? foo) {
    if (foo == null) {
      prefs.remove(namespace);
      return;
    }
    prefs.setString(namespace, foo);
  }

  @override
  String? get jwtToken {
    return prefs.getString(namespace);
  }
}
