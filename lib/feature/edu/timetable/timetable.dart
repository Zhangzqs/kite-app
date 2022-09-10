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
import 'dart:core';

import 'package:kite_request_interface/kite_request_interface.dart';

import '../common/entity/index.dart';
import '../util/convert_util.dart';
import 'entity.dart';

class TimetableService extends AService {
  static const _timetableUrl = 'http://jwxt.sit.edu.cn/jwglxt/kbcx/xskbcx_cxXsgrkb.html';

  TimetableService(ISession session) : super(session);

  static List<Course> _parseTimetable(Map<String, dynamic> json) {
    final List<dynamic> courseList = json['kbList'];

    return courseList.map((e) => Course.fromJson(e)).toList();
  }

  /// 获取课表
  Future<List<Course>> getTimetable(SchoolYear schoolYear, Semester semester) async {
    final response = await session.request(
      _timetableUrl,
      RequestMethod.post,
      queryParameters: {'gnmkdm': 'N253508'},
      data: {
        // 学年名
        'xnm': schoolYear.toString(),
        // 学期名
        'xqm': semesterToFormField(semester)
      },
    );
    return _parseTimetable(response.data);
  }
}
