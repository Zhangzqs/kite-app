library kite_sit_report_session;

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:kite_request_dio_adapter/kite_request_dio_adapter.dart';
import 'package:kite_request_interface/kite_request_interface.dart';

class ReportSession extends ISession {
  final Dio dio;
  String Function() usernameGetter;

  ReportSession({
    required this.dio,
    required this.usernameGetter,
  });

  /// 获取当前以毫秒为单位的时间戳.
  static String _getTimestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  /// 为时间戳生成签名. 此方案是联鹏习惯的反爬方式.
  String _md5(String s) => md5.convert(const Utf8Encoder().convert(s)).toString();

  String _sign(String u, String t) {
    final hash = _md5('${u}Unifrinew$t').toString().toUpperCase();
    return hash.substring(16, 32) + hash.substring(0, 16);
  }

  Future<Response> _dioRequest(
    String url,
    String method, {
    Map<String, String>? queryParameters,
    dynamic data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    Options newOptions = options ?? Options();

    // Make default options.
    final String ts = _getTimestamp();
    final String sign = _sign(usernameGetter(), ts);
    final Map<String, dynamic> newHeaders = {'ts': ts, 'decodes': sign};

    newOptions.headers == null ? newOptions.headers = newHeaders : newOptions.headers?.addAll(newHeaders);
    newOptions.method = method;

    return await dio.request(
      url,
      queryParameters: queryParameters,
      data: data,
      options: newOptions,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
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
      method.toUpperCaseString(),
      queryParameters: queryParameters,
      data: data,
      options: options?.toDioOptions(),
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    return response.toMyResponse();
  }
}

class ReportException implements Exception {
  String msg;

  ReportException([this.msg = '']);

  @override
  String toString() {
    return msg;
  }
}
