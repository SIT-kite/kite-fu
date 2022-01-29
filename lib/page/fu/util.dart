import 'package:kite_fu/entity/fu.dart';

String cardTypeToString(FuType type) {
  return {
    FuType.noCard: '无卡片',
    FuType.sit: '上应福',
    FuType.innovation: '创新福',
    FuType.erudition: '博学福',
    FuType.wealth: '富贵福',
    FuType.health: '康宁福',
  }[type]!;
}
