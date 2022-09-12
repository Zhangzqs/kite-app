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

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:kite/component/future_builder.dart';

import '../../common/entity/index.dart';
import '../../util/selector.dart';
import '../entity/exam.dart';
import '../init.dart';

class ExamPage extends StatefulWidget {
  const ExamPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  static final dateFormat = DateFormat('MM月dd日 HH:mm');

  /// 四位年份
  late int selectedYear;

  /// 要查询的学期
  late Semester selectedSemester;

  @override
  void initState() {
    final DateTime now = DateTime.now();
    selectedYear = (now.month >= 9 ? now.year : now.year - 1);
    selectedSemester = (now.month >= 3 && now.month <= 7) ? Semester.secondTerm : Semester.firstTerm;

    super.initState();
  }

  Widget _buildItem(String icon, String text) {
    final itemStyle = Theme.of(context).textTheme.bodyText1;
    final iconImage = AssetImage('assets/$icon');
    return Row(
      children: [
        icon.isEmpty ? const SizedBox(height: 24, width: 24) : Image(image: iconImage, width: 24, height: 24),
        const SizedBox(width: 8, height: 32),
        Expanded(child: Text(text, softWrap: true, style: itemStyle))
      ],
    );
  }

  Widget buildExamItem(ExamRoom examItem) {
    final itemStyle = Theme.of(context).textTheme.bodyText2;
    final name = examItem.courseName;
    final strStartTime = examItem.time.isNotEmpty ? dateFormat.format(examItem.time[0]) : '/';
    final strEndTime = examItem.time.isNotEmpty ? dateFormat.format(examItem.time[1]) : '/';
    final place = examItem.place;
    final seatNumber = examItem.seatNumber;
    final isSecondExam = examItem.isSecondExam;

    TableRow buildRow(String icon, String title, String content) {
      return TableRow(children: [
        _buildItem(icon, title),
        Text(content, style: itemStyle),
      ]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
          child: Text(name, style: Theme.of(context).textTheme.headline6),
        ),
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {0: FlexColumnWidth(4), 1: FlexColumnWidth(5)},
          children: [
            buildRow('timetable/campus.png', '考试地点', place),
            buildRow('timetable/courseId.png', '座位号', '$seatNumber'),
            buildRow('timetable/day.png', '开始时间', strStartTime),
            buildRow('timetable/day.png', '结束时间', strEndTime),
            buildRow('', '是否重修', isSecondExam),
          ],
        )
      ],
    );
  }

  Widget buildExamItems(List<ExamRoom> examItems) {
    final widgets = examItems.map((e) => buildExamItem(e)).toList();
    if (examItems.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/score/not-found.svg',
            width: 260,
            height: 260,
          ),
          const Text('该学期暂无考试', style: TextStyle(color: Colors.grey)),
        ],
      );
    }
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: widgets[index],
      ),
      itemCount: widgets.length,
      separatorBuilder: (BuildContext context, int index) => const Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Divider(),
      ),
    );
  }

  Widget buildSemesterSelector() {
    return Container(
      margin: const EdgeInsets.only(left: 15),
      child: SemesterSelector(
        yearSelectCallback: (year) {
          setState(() => selectedYear = year);
        },
        semesterSelectCallback: (semester) {
          setState(() => selectedSemester = semester);
        },
        initialYear: selectedYear,
        initialSemester: selectedSemester,
        showEntireYear: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('考试安排')),
      body: Column(
        children: [
          buildSemesterSelector(),
          MyFutureBuilder<List<ExamRoom>>(
            futureGetter: () => ExamInitializer.examService.getExamList(
              SchoolYear(selectedYear),
              selectedSemester,
            ),
            builder: (context, data) {
              data.sort((a, b) {
                if (a.time.isEmpty || b.time.isEmpty) {
                  if (a.time.isEmpty != b.time.isEmpty) {
                    return a.time.isEmpty ? 1 : -1;
                  }
                  return 0;
                }
                return a.time[0].isAfter(b.time[0]) ? 1 : -1;
              });
              return Expanded(child: buildExamItems(data));
            },
          ),
        ],
      ),
    );
  }
}
