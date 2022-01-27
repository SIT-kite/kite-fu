import 'package:kite_fu/session/abstract_session.dart';

abstract class AService {
  final ASession session;
  const AService(this.session);
}
