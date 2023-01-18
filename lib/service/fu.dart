import 'dart:convert';
import 'dart:typed_data';

import 'package:kite_fu/dao/fu.dart';
import 'package:kite_fu/entity/fu.dart';
import 'package:kite_fu/session/abstract_session.dart';
import 'package:kite_fu/util/logger.dart';

import '../backend.dart';
import 'abstract_service.dart';

class FuService extends AService implements FuDao {
  FuService(ASession session) : super(session);
  static const _urlPrefix = backendBadge;

  @override
  Future<List<MyCard>> getList() async {
    Log.info('请求福卡列表 /badge/card/');
    final response = await session.get('$_urlPrefix/card/');
    List<dynamic> list = response.data;
    Log.info('福卡列表: $list');
    return list.map((e) => MyCard.fromJson(e)).toList();
  }

  @override
  Future<String?> getResult() async {
    Log.info('请求开奖结果 /badge/result');
    final response = await session.get('$_urlPrefix/result');
    Log.info('开奖结果: ${response.data}');
    return response.data['url'];
  }

  @override
  Future<UploadResultModel> upload(Uint8List imageBuffer) async {
    Log.info('上传图片请求 /badge/image');
    final response = await session.post(
      '$_urlPrefix/image',
      data: base64Encode(imageBuffer),
      contentType: 'text/plain',
    );
    Log.info('上传结果: ${response.data}');
    return UploadResultModel.fromJson(response.data);
  }

  @override
  Future<void> share() async {
    await session.post('$_urlPrefix/share');
    Log.info('成功记录一次分享操作');
  }
}
