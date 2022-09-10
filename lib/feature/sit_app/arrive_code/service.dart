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

import 'package:kite_request_interface/kite_request_interface.dart';

import 'dao.dart';

class ArriveCodeService extends AService implements ArriveCodeDao {
  ArriveCodeService(ISession session) : super(session);

  @override
  Future<String> arrive(String code) async {
    final response = await session.request(
      'https://xgfy.sit.edu.cn//regist/scan/appAdd',
      RequestMethod.post,
      data: {'place': code},
    );
    return response.data['msg'];
  }
}
