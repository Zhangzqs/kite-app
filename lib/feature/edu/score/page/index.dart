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
import 'package:flutter_svg/svg.dart';
import 'package:kite/component/future_builder.dart';
import 'package:kite/feature/edu/score/init.dart';

import '../../common/entity/index.dart';
import '../../util/selector.dart';
import '../entity/score.dart';
import 'banner.dart';
import 'item.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({Key? key}) : super(key: key);

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  /// 四位年份
  late int selectedYear;

  /// 要查询的学期
  Semester selectedSemester = Semester.all;

  final Widget _notFoundPicture = SvgPicture.asset(
    'assets/score/not-found.svg',
    width: 260,
    height: 260,
  );

  @override
  void initState() {
    final now = DateTime.now();
    selectedYear = (now.month >= 9 ? now.year : now.year - 1);
    super.initState();
  }

  Widget _buildHeader(List<Score> scoreList) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
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
          ),
        ),
        GpaBanner(selectedSemester, scoreList),
      ],
    );
  }

  Widget _buildListView(List<Score> scoreList) {
    final list = scoreList.map((e) => ScoreItem(e)).toList();
    return ListView.separated(
      itemCount: list.length,
      separatorBuilder: (context, _) => Divider(height: 2.0, color: Theme.of(context).primaryColor.withOpacity(0.4)),
      itemBuilder: (_, index) => list[index],
    );
  }

  Widget _buildNoResult() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: _notFoundPicture,
        ),
        const Text('暂时还没有成绩', style: TextStyle(color: Colors.grey)),
        Container(
          margin: const EdgeInsets.only(left: 40, right: 40),
          child: const Text('过会儿再来吧！', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return MyFutureBuilder<List<Score>>(
      futureGetter: () => ScoreInitializer.scoreService.getScoreList(SchoolYear(selectedYear), selectedSemester),
      builder: (context, data) {
        final scoreList = data;
        return Column(
          children: [
            _buildHeader(scoreList),
            Expanded(child: scoreList.isNotEmpty ? _buildListView(scoreList) : _buildNoResult()),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('成绩查询'),
      ),
      body: _buildBody(),
    );
  }
}
