import 'dart:convert';
import 'dart:typed_data';

import 'package:kite_fu/dao/fu.dart';
import 'package:kite_fu/entity/fu.dart';
import 'package:kite_fu/session/abstract_session.dart';
import 'package:kite_fu/util/logger.dart';

import 'abstract_service.dart';

class FuService extends AService implements FuDao {
  FuService(ASession session) : super(session);

  @override
  Future<List<MyCard>> getList() async {
    Log.info('请求卡片列表');
    final response = await session.get('https://kite.sunnysab.cn/api/v2/badge/card/');
    List<dynamic> list = response.data;
    Log.info('卡片列表: $list');
    return list.map((e) => MyCard.fromJson(e)).toList();
  }

  @override
  Future<String?> getResult() async {
    Log.info('请求开奖结果');
    final response = await session.get('https://kite.sunnysab.cn/api/v2/badge/result');
    Log.info('开奖结果: ${response.data}');
    return response.data['url'];
  }

  @override
  Future<UploadResultModel> upload(Uint8List imageBuffer) async {
    Log.info('上传图片请求');
    final response = await session.post(
      'https://sunnysab.cn/api/badge/image',
      data: base64Encode(imageBuffer),
      contentType: 'text/plain',
    );
    Log.info('上传结果: ${response.data}');
    return UploadResultModel.fromJson(response.data);
  }
}
