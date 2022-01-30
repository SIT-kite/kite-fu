import 'dart:math';
import 'dart:typed_data';

import 'package:kite_fu/dao/fu.dart';
import 'package:kite_fu/entity/fu.dart';
import 'package:kite_fu/util/logger.dart';

class FuMock implements FuDao {
  List<MyCard> myCards = [];
  int maxLimitCount = 100;
  int todayCount = 0;
  @override
  Future<List<MyCard>> getList() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return myCards;
  }

  @override
  Future<String?> getResult() async {
    // 未开奖
    return null;
  }

  @override
  Future<UploadResultModel> upload(Uint8List imageBuffer) async {
    if (todayCount >= maxLimitCount) {
      Log.info('达到单日最大次数限制');
      return UploadResultModel()..result = UploadResult.maxLimit;
    }
    Log.info('识别中');
    await Future.delayed(Duration.zero);

    todayCount++;
    if (Random.secure().nextInt(2) == 0) {
      Log.info('找不到校徽');
      return UploadResultModel()..result = UploadResult.noBadge;
    }
    Log.info('识别成功');
    if (Random.secure().nextInt(2) == 0) {
      Log.info('没抽到卡片');
      return UploadResultModel()
        ..result = UploadResult.successful
        ..card = FuCard.noCard;
    }
    Log.info('抽到卡片');
    final card = UploadResultModel()
      ..result = UploadResult.successful
      ..card = FuCard.values[Random.secure().nextInt(FuCard.values.length - 1) + 1];
    // 添加到卡包
    myCards.add(MyCard()
      ..card = card.card
      ..ts = DateTime.now());
    return card;
  }
}
