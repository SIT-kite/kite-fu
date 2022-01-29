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
    final response = await session.get('https://kite.sunnysab.cn/api/v2/badge/card');
    List<dynamic> list = response.data;
    return list.map((e) => MyCard.fromJson(e)).toList();
  }

  @override
  Future<PraiseResult> getResult() async {
    final response = await session.get('https://kite.sunnysab.cn/api/v2/badge/result');
    return PraiseResult.fromJson(response.data);
  }

  @override
  Future<UploadResultModel> upload(Uint8List imageBuffer) async {
    final response = await session.post(
      'https://sunnysab.cn/api/badge/image',
      data: base64Encode(imageBuffer),
      contentType: 'text/plain',
    );
    Log.info(response);
    return UploadResultModel();
  }
}
