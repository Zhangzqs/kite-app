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

import 'service/function.dart';
import 'service/message.dart';
import 'using.dart';

class ApplicationInit {
  static late CookieJar cookieJar;
  static late OfficeFunctionService functionService;
  static late OfficeMessageService messageService;
  static late OfficeSession session;

  static Future<void> init({
    required Dio dio,
    required CookieJar cookieJar,
  }) async {
    ApplicationInit.cookieJar = cookieJar;
    session = OfficeSession(dio: dio);

    ApplicationInit.functionService = OfficeFunctionService(session);
    ApplicationInit.messageService = OfficeMessageService(session);
  }
}
