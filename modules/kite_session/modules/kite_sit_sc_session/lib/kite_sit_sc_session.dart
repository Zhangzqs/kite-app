library kite_sit_sc_session;

import 'package:kite_session_common/kite_session_common.dart';

class ScSession extends ISession {
  final ISession _session;

  ScSession(this._session) {
    Log.info('初始化 ScSession');
  }

  Future<void> _refreshCookie() async {
    await _session.request(
      'https://authserver.sit.edu.cn/authserver/login?service=http%3A%2F%2Fsc.sit.edu.cn%2Flogin.jsp',
      RequestMethod.get,
    );
  }

  bool _isRedirectedToLoginPage(String data) {
    return data.startsWith('<script');
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
    Future<MyResponse> fetch() async {
      return await _session.request(
        url,
        method,
        queryParameters: queryParameters,
        data: data,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    }

    MyResponse response = await fetch();
    // 如果返回值是登录页面，那就从 SSO 跳转一次以登录.
    if (_isRedirectedToLoginPage(response.data as String)) {
      await _refreshCookie();
      response = await fetch();
    }
    return response;
  }
}
