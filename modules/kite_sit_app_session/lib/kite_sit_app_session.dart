library kite_sit_app_session;

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:kite_request_dio_adapter/kite_request_dio_adapter.dart';
import 'package:kite_request_interface/kite_request_interface.dart';
import 'package:kite_storage_auth_interface/kite_storage_auth_interface.dart';
import 'package:kite_storage_jwt_interface/kite_storage_jwt_interface.dart';
import 'package:kite_util/kite_util.dart';

class SitAppSession implements ISession {
  final Dio dio;
  final JwtDao jwtDao;
  final AuthStorageDao authDao;

  SitAppSession({
    required this.dio,
    required this.jwtDao,
    required this.authDao,
  });

  Future<Response> _dioRequest(
    String url,
    String method, {
    Map<String, String>? queryParameters,
    data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    Future<Response> normallyRequest() async {
      return await _requestWithoutRetry(
        url,
        method,
        queryParameters: queryParameters,
        data: data,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    }

    try {
      return await normallyRequest();
    } on SitAppApiError catch (e, _) {
      if (e.code == 500) {
        await login(
          authDao.currentUsername ?? '',
          authDao.ssoPassword ?? '',
        );
      }
      return await normallyRequest();
    }
  }

  Future<Response> _requestWithoutRetry(
    String url,
    String method, {
    Map<String, String>? queryParameters,
    data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    String? token = jwtDao.jwtToken;
    final response = await dio.request(
      url,
      data: data,
      queryParameters: queryParameters,
      options: (options ?? Options()).copyWith(
        method: method,
        contentType: options == null ? ContentType.json.value : null,
        responseType: options == null ? ResponseType.json : null,
        headers: () {
          final Map<String, String> headersMap = {};
          if (token != null) headersMap['Authorization'] = token;
          return headersMap;
        }(),
      ),
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    // 非 json 数据
    if (!(response.headers.value(Headers.contentTypeHeader) ?? '').contains('json')) {
      // 直接返回
      return response;
    }
    try {
      final Map<String, dynamic> responseData = response.data;
      final responseDataCode = responseData['code'];
      // 请求正常
      if (responseDataCode == 0) {
        // 直接取数据然后返回
        return response;
      }
      // 请求异常

      // 存在code,但是不为0
      if (responseDataCode != null) {
        final errorMsg = responseData['msg'];
        Log.info('请求出错: $errorMsg');
        throw SitAppApiError(responseDataCode, errorMsg);
      }
    } on SitAppApiError catch (e) {
      // api请求有误
      Log.info('请求出错: ${e.msg}');
      rethrow;
    }
    throw SitAppApiFormatError(response.data);
  }

  /// 用户登录
  /// 用户不存在时，将自动创建用户
  Future<Response> login(String username, String password) async {
    final response = await dio.post('http://210.35.96.115:8099/login', data: {
      'userName': username,
      'userPassword': password,
    });
    jwtDao.jwtToken = response.data['data'];
    return response;
  }

  @override
  Future<MyResponse> request(
    String url,
    RequestMethod method, {
    Map<String, String>? queryParameters,
    data,
    MyOptions? options,
    MyProgressCallback? onSendProgress,
    MyProgressCallback? onReceiveProgress,
  }) async {
    Response response = await _dioRequest(
      url,
      method.toString().toUpperCase(),
      queryParameters: queryParameters,
      data: data,
      options: options?.toDioOptions(),
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    return response.toMyResponse();
  }
}

class SitAppApiError implements Exception {
  final int code;
  final String? msg;

  const SitAppApiError(this.code, this.msg);

  @override
  String toString() {
    return 'SitAppApiError{code: $code, msg: $msg}';
  }
}

/// 服务器数据返回格式有误
class SitAppApiFormatError implements Exception {
  final dynamic responseData;

  const SitAppApiFormatError(this.responseData);

  @override
  String toString() {
    return 'SitAppApiFormatError{responseData: $responseData}';
  }
}
