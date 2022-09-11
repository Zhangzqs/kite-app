library kite_sit_edu_session;

import 'package:kite_request_interface/kite_request_interface.dart';
import 'package:kite_sit_sso_session/sso_session.dart';
import 'package:kite_util/kite_util.dart';

class EduSession extends ISession {
  final SsoSession ssoSession;

  EduSession(this.ssoSession) {
    Log.info('初始化 EduSession');
  }

  Future<void> _refreshCookie() async {
    await ssoSession.request('http://jwxt.sit.edu.cn/sso/jziotlogin', RequestMethod.get);
  }

  bool _isRedirectedToLoginPage(MyResponse response) {
    return response.realUri.path == '/jwglxt/xtgl/login_slogin.html';
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
      return await ssoSession.request(
        url,
        method,
        queryParameters: queryParameters,
        data: data,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    }

    var response = await fetch();
    // 如果返回值是登录页面，那就从 SSO 跳转一次以登录.
    if (_isRedirectedToLoginPage(response)) {
      Log.info('EduSession需要登录');
      await _refreshCookie();
      response = await fetch();
    }
    // 如果还是需要登录
    if (_isRedirectedToLoginPage(response)) {
      Log.info('SsoSession需要登录');
      await ssoSession.makeSureLogin(url);
      await _refreshCookie();
      response = await fetch();
    }
    return response;
  }
}
