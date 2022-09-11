library kite_storage_auth_interface;

abstract class AuthStorageDao {
  /// 获取当前登录用户的用户名
  String? get currentUsername;

  /// 设置一个null表示退出登录当前用户
  set currentUsername(String? foo);

  /// 获取当前登录用户的用户名
  String? get ssoPassword;

  /// 设置一个null表示退出登录当前用户
  set ssoPassword(String? foo);

  /// 获取用户姓名信息
  String? get personName;

  /// 设置用户姓名
  set personName(String? foo);
}
