import 'package:json_annotation/json_annotation.dart';

part 'fu.g.dart';

enum UploadResult {
  /// 无校徽
  noBadge,

  /// 达到最大限制
  maxLimit,

  /// 抽中
  successful,

  /// 活动结束
  tooLate,

  /// 活动未开始
  tooEarly,
}

UploadResult _intToUploadResult(int foo) {
  return UploadResult.values[foo - 1];
}

enum FuCard {
  /// 无效福卡
  noCard,

  /// 上应
  sit,

  /// 创新
  innovation,

  /// 博学
  erudition,

  /// 富贵
  wealth,

  /// 康宁
  health,

  /// 风筝福
  kite,
}

FuCard _intToFuType(int foo) {
  return FuCard.values[foo];
}

@JsonSerializable(createToJson: false)
class UploadResultModel {
  /// 上传结果
  @JsonKey(fromJson: _intToUploadResult)
  UploadResult result = UploadResult.noBadge;

  /// 福卡类型
  @JsonKey(fromJson: _intToFuType)
  FuCard card = FuCard.noCard;
  UploadResultModel();
  factory UploadResultModel.fromJson(Map<String, dynamic> json) => _$UploadResultModelFromJson(json);
  @override
  String toString() {
    return 'UploadResultModel{result: $result, type: $card}';
  }
}

DateTime _parseTs(String src) {
  final dt = DateTime.parse(src);
  // Log.info(dt.toLocal());
  return dt.toLocal();
}

/// 我的福卡
@JsonSerializable(createToJson: false)
class MyCard {
  @JsonKey(fromJson: _intToFuType)
  FuCard card = FuCard.noCard;
  @JsonKey(fromJson: _parseTs)
  DateTime ts = DateTime.now();
  MyCard();
  factory MyCard.fromJson(Map<String, dynamic> json) => _$MyCardFromJson(json);
  @override
  String toString() {
    return 'MyCard{card: $card, ts: $ts}';
  }
}
