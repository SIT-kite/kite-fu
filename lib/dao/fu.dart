import 'dart:typed_data';

import 'package:kite_fu/entity/fu.dart';

abstract class FuDao {
  /// 上传照片
  Future<UploadResultModel> upload(Uint8List imageBuffer);

  /// 获取我的福卡列表
  Future<List<MyCard>> getList();

  /// 查询中奖结果
  Future<String?> getResult();

  /// 分享记录接口，记录用户的分享操作
  /// 每次分享将加一次机会
  Future<void> share();
}
