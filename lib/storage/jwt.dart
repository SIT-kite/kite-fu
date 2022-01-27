import 'package:kite_fu/dao/jwt.dart';

class JwtStorage implements JwtDao {
  String? jwt;
  @override
  set jwtToken(String? foo) {
    jwt = foo;
  }

  @override
  String? get jwtToken {
    return jwt;
  }
}
