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
import 'package:json_annotation/json_annotation.dart';
import 'package:kite_hive_type_id_pool/kite_hive_type_id_pool.dart';

part 'entity.g.dart';

/// 存放课表元数据
@HiveType(typeId: HiveTypeIdPool.timetableMetaItem)
class TimetableMeta extends HiveObject {
  /// 课表名称
  @HiveField(0)
  String name = '';

  /// 课表描述
  @HiveField(1)
  String description = '';

  /// 课表的起始时间
  @HiveField(2)
  DateTime startDate = DateTime.now();

  /// 学年
  @HiveField(3)
  int schoolYear = 0;

  /// 学期
  @HiveField(4)
  int semester = 0;

  @override
  String toString() {
    return 'TimetableMeta{name: $name, description: $description, startDate: $startDate, schoolYear: $schoolYear, semester: $semester}';
  }
}

@HiveType(typeId: HiveTypeIdPool.courseItem)
@JsonSerializable()
class Course extends HiveObject {
  static final Map<String, int> _weekMapping = {'星期一': 1, '星期二': 2, '星期三': 3, '星期四': 4, '星期五': 5, '星期六': 6, '星期日': 7};

  /// 课程名称
  @JsonKey(name: 'kcmc')
  @HiveField(0)
  final String courseName;

  /// 星期
  @JsonKey(name: 'xqjmc', fromJson: _day2Index)
  @HiveField(1)
  final int dayIndex;

  /// 节次
  @JsonKey(name: 'jcs', fromJson: _time2Index)
  @HiveField(2)
  final int timeIndex;

  /// 周次 （原始文本）
  @JsonKey(name: 'zcd')
  @HiveField(11)
  final String weekText;

  /// 周次
  @JsonKey(ignore: true)
  @HiveField(3)
  int weekIndex = 0;

  /// 持续时长 (节)
  @JsonKey(ignore: true)
  @HiveField(12)
  int duration = 0;

  /// 教室
  @JsonKey(name: 'cdmc')
  @HiveField(4)
  final String place;

  /// 教师
  @JsonKey(name: 'xm', fromJson: _string2Vec, defaultValue: ['空'])
  @HiveField(5)
  final List<String> teacher;

  /// 校区
  @JsonKey(name: 'xqmc')
  @HiveField(6)
  final String campus;

  /// 学分
  @JsonKey(name: 'xf', fromJson: _string2Double)
  @HiveField(7)
  final double credit;

  /// 学时
  @JsonKey(name: 'zxs', fromJson: _stringToInt)
  @HiveField(8)
  final int hour;

  /// 教学班
  @JsonKey(name: 'jxbmc', fromJson: _trim)
  @HiveField(9)
  final String dynClassId;

  /// 课程代码
  @JsonKey(name: 'kch')
  @HiveField(10)
  final String courseId;

  Course(this.courseName, this.dayIndex, this.timeIndex, this.place, this.teacher, this.campus, this.credit, this.hour,
      this.dynClassId, this.courseId, this.weekText)
      : weekIndex = _weekText2Index(weekText),
        duration = _countOne(timeIndex);

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);

  @override
  String toString() {
    return 'Course{courseName: $courseName, day: $dayIndex, timeIndex: $timeIndex, week: $weekIndex, place: $place, teacher: $teacher, campus: $campus, credit: $credit, hour: $hour, dynClassId: $dynClassId, courseId: $courseId, weekText: $weekText, duration: $duration}';
  }

  /// 将中文的星期转换为数字, 如 "星期四" -> 4. 如果出错, 返回 0
  static int _day2Index(String weekDay) => _weekMapping[weekDay] ?? 0;

  /// 将 [String?] 转为十进制整数. 如果出错, 返回 64.
  ///
  /// 如果返回 0, 后续 [_time2Index] 函数在遇到错误时会执行 2 << 0, 导致第 2 位被置为 1, 产生错误
  static int _parseInt(String? x) => int.tryParse(x ?? '64') ?? 64;

  /// 将逗号分隔的字符串转为列表
  static List<String> _string2Vec(String s) => s.split(',');

  /// 字符串转小数
  static double _string2Double(String s) => double.tryParse(s) ?? double.nan;

  /// 字符串转整数 (默认 0)
  static int _stringToInt(String s) => int.tryParse(s) ?? 0;

  /// 字符串去首尾空白字符
  static String _trim(String s) => s.trim();

  /// 判断 1 的个数
  static int _countOne(int n) {
    int count = 0;
    while (n != 0) {
      count += n & 1;
      n >>= 1;
    }
    return count;
  }

  /// 解析周数字符串为整数. 例：1-8周(单),2-7周,3周
  static int _weekText2Index(String text) {
    int result = 0;
    text.split(',').forEach((weekText) {
      final int step = weekText.endsWith('(单)') || weekText.endsWith('(双)') ? 2 : 1;
      final String text = weekText.split('周')[0];
      result |= _time2Index(text, step);
    });
    return result;
  }

  /// 解析时间字符串, 如 1-2、3
  static int _time2Index(String text, [int step = 1]) {
    if (!text.contains('-')) {
      return 1 << _parseInt(text);
    }
    int result = 0;
    final timeText = text.split('-');
    int min = _parseInt(timeText.first);
    int max = _parseInt(timeText.last);
    for (int i = min; i <= max; i += step) {
      result |= 1 << i;
    }
    return result;
  }
}

/// 课表显示模式
enum DisplayMode {
  daily,
  weekly,
}
