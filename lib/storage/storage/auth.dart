/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import 'package:hive/hive.dart';
import 'package:kite_storage_interface/kite_storage_interface.dart';

class AuthKeys {
  static const namespace = '/auth';
  static const currentUsername = '$namespace/currentUsername';
  static const ssoPassword = '$namespace/ssoPassword';
  static const personName = '$namespace/personName';
  static const userType = '$namespace/userType';
  static const lastLogin = '$namespace/lastLogin';
}

class AuthStorage implements AuthStorageDao {
  final Box<dynamic> box;

  AuthStorage(this.box);

  @override
  String? get currentUsername => box.get(AuthKeys.currentUsername);

  @override
  set currentUsername(String? foo) => box.put(AuthKeys.currentUsername, foo);

  @override
  String? get ssoPassword => box.get(AuthKeys.ssoPassword);

  @override
  set ssoPassword(String? foo) => box.put(AuthKeys.ssoPassword, foo);

  @override
  String? get personName => box.get(AuthKeys.personName);

  @override
  set personName(String? foo) => box.put(AuthKeys.personName, foo);

  @override
  DateTime? get lastLogin => box.get(AuthKeys.lastLogin);

  @override
  set lastLogin(DateTime? foo) => box.put(AuthKeys.lastLogin, foo);
}
