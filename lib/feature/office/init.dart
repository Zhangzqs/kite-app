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

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:kite/storage/init.dart';
import 'package:kite_sit_office_session/kite_sit_office_session.dart';
import 'package:kite_storage_interface/kite_storage_interface.dart';

import 'service/function.dart';
import 'service/message.dart';

class OfficeJwtStorage implements JwtDao {
  @override
  String? jwtToken;
}

class OfficeInitializer {
  static late CookieJar cookieJar;
  static late OfficeFunctionService functionService;
  static late OfficeMessageService messageService;
  static late OfficeSession session;

  static Future<void> init({
    required Dio dio,
    required CookieJar cookieJar,
  }) async {
    OfficeInitializer.cookieJar = cookieJar;
    session = OfficeSession(
      dio: dio,
      jwtDao: OfficeJwtStorage(),
      authDao: KvStorageInitializer.auth,
    );

    OfficeInitializer.functionService = OfficeFunctionService(session);
    OfficeInitializer.messageService = OfficeMessageService(session);
  }
}
