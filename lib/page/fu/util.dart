import 'package:kite_fu/entity/kite/fu.dart';

String cardTypeToString(FuType type) {
  return {
    FuType.noCard: '无卡片',
    FuType.loveCountry: '爱国福',
    FuType.wealthy: '富强福',
    FuType.harmony: '和谐福',
    FuType.friendly: '友善福',
    FuType.dedicateToWork: '敬业福',
  }[type]!;
}
