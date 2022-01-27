import 'package:kite_fu/entity/account.dart';

abstract class AccountDao {
  set account(KiteUser? foo);
  KiteUser? get account;
}
