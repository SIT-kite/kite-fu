import 'dart:typed_data';

import 'package:kite_fu/dao/fu.dart';
import 'package:kite_fu/entity/fu.dart';
import 'package:kite_fu/session/abstract_session.dart';

import 'abstract_service.dart';

class FuService extends AService implements FuDao {
  FuService(ASession session) : super(session);

  @override
  Future<List<MyCard>> getList() async {
    final response = await session.get('/badge/card');
    print(response.data);
    return [];
  }

  @override
  Future<PraiseResult> getResult() async {
    // TODO: implement getResult
    throw UnimplementedError();
  }

  @override
  Future<UploadResultModel> upload(Uint8List imageBuffer) async {
    // TODO: implement upload
    throw UnimplementedError();
  }
}
