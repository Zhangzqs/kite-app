library kite_sit_office_session;

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:kite_exception/kite_exception.dart';
import 'package:kite_request_dio_adapter/kite_request_dio_adapter.dart';
import 'package:kite_request_interface/kite_request_interface.dart';
import 'package:kite_storage_auth_interface/kite_storage_auth_interface.dart';
import 'package:kite_storage_jwt_interface/kite_storage_jwt_interface.dart';

/// 应网办登录地址, POST 请求
const String _officeLoginUrl = 'https://xgfy.sit.edu.cn/unifri-flow/login';

class OfficeSession extends ISession {
  bool isLogin = false;

  JwtDao jwtDao;
  AuthStorageDao authDao;
  final Dio dio;

  OfficeSession({
    required this.dio,
    required this.jwtDao,
    required this.authDao,
  });

  Future<void> login({
    required String username,
    required String password,
  }) async {
    final Map<String, String> credential = {'account': username, 'userPassword': password, 'remember': 'true'};

    final response =
        await dio.post(_officeLoginUrl, data: credential, options: Options(contentType: Headers.jsonContentType));
    final int code = (response.data as Map)['code'];

    if (code != 0) {
      final String errMessage = (response.data as Map)['msg'];
      throw CredentialsInvalidException(msg: '($code) $errMessage');
    }
    jwtDao.jwtToken = ((response.data as Map)['data'])['authorization'];
    isLogin = true;
  }

  /// 获取当前以毫秒为单位的时间戳.
  static String _getTimestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  /// 为时间戳生成签名. 此方案是联鹏习惯的反爬方式.
  static String _sign(String ts) {
    final content = const Utf8Encoder().convert('unifri.com$ts');
    return md5.convert(content).toString();
  }

  @override
  Future<MyResponse> request(
    String url,
    RequestMethod method, {
    Map<String, String>? queryParameters,
    dynamic data,
    MyOptions? options,
    MyProgressCallback? onSendProgress,
    MyProgressCallback? onReceiveProgress,
  }) async {
    if (!isLogin) {
      final username = authDao.currentUsername!;
      final password = authDao.ssoPassword!;
      await login(
        username: username,
        password: password,
      );
    }

    Options newOptions = options?.toDioOptions() ?? Options();

    // Make default options.
    final String ts = _getTimestamp();
    final String sign = _sign(ts);
    final Map<String, dynamic> newHeaders = {
      'timestamp': ts,
      'signature': sign,
      'Authorization': jwtDao.jwtToken,
    };

    newOptions.headers == null ? newOptions.headers = newHeaders : newOptions.headers?.addAll(newHeaders);
    newOptions.method = method.toUpperCaseString();

    final response = await dio.request(
      url,
      queryParameters: queryParameters,
      data: data,
      options: newOptions,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    return response.toMyResponse();
  }
}
