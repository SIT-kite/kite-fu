import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:kite_fu/dao/jwt.dart';
import 'package:kite_fu/entity/account.dart';
import 'package:kite_fu/session/abstract_session.dart';
import 'package:kite_fu/util/logger.dart';

class KiteSession extends ASession {
  final Dio dio;
  final JwtDao jwtDao;
  KiteUser? profile;

  KiteSession(this.dio, this.jwtDao);

  @override
  Future<Response> request(
    String url,
    String method, {
    Map<String, String>? queryParameters,
    data,
    Options? options,
    String? contentType,
    ResponseType? responseType,
  }) async {
    String? token = jwtDao.jwtToken;
    final response = await dio.request(
      url,
      data: data,
      queryParameters: queryParameters,
      options: (options ?? Options()).copyWith(
        method: method,
        contentType: contentType ?? ContentType.json.value,
        responseType: responseType ?? ResponseType.json,
        headers: token == null ? null : {'Authorization': 'Bearer ' + token},
      ),
    );
    try {
      final Map<String, dynamic> responseData = response.data;
      final responseDataCode = responseData['code'];
      // 请求正常
      if (responseDataCode == 0) {
        // 直接取数据然后返回
        response.data = responseData['data'];
        return response;
      }
      // 请求异常

      // 存在code,但是不为0
      if (responseDataCode != null) {
        final errorMsg = responseData['msg'];
        Log.info('请求出错: $errorMsg');
        throw KiteApiError(responseDataCode, errorMsg);
      }
    } on KiteApiError catch (e) {
      // api请求有误
      Log.info('请求出错: ${e.msg}');
      rethrow;
    }
    throw KiteApiFormatError(response.data);
  }

  /// 用户登录
  /// 用户不存在时，将自动创建用户
  Future<KiteUser> login(String username, String password) async {
    final response = await post('https://kite.sunnysab.cn/api/v2/session', data: {
      'account': username,
      'password': password,
    });
    jwtDao.jwtToken = response.data['token'];
    profile = KiteUser.fromJson(response.data['profile']);
    return profile!;
  }
}

class KiteApiError implements Exception {
  final int code;
  final String? msg;
  const KiteApiError(this.code, this.msg);

  @override
  String toString() {
    return 'KiteApiError{code: $code, msg: $msg}';
  }
}

/// 服务器数据返回格式有误
class KiteApiFormatError implements Exception {
  final dynamic responseData;
  const KiteApiFormatError(this.responseData);

  @override
  String toString() {
    return 'KiteApiFormatError{responseData: $responseData}';
  }
}
