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

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:kite/feature/library/appointment/init.dart';
import 'package:kite_session/kite_session.dart';

import 'search/entity/search_history.dart';
import 'search/init.dart';

class LibraryInitializer {
  static Future<void> init({
    required Dio dio,
    required Box<LibrarySearchHistoryItem> searchHistoryBox,
    required KiteSession kiteSession,
  }) async {
    await LibrarySearchInitializer.init(dio: dio, searchHistoryBox: searchHistoryBox);
    LibraryAppointmentInitializer.init(kiteSession: kiteSession);
  }
}
