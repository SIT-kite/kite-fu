import 'package:kite_fu/entity/fu.dart';

String cardTypeToString(FuCard type) {
  return {
    FuCard.noCard: '暂无福卡',
    FuCard.sit: '上应福',
    FuCard.innovation: '创新福',
    FuCard.erudition: '博学福',
    FuCard.wealth: '富贵福',
    FuCard.health: '康宁福',
    FuCard.kite: '风筝福',
  }[type]!;
}
