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
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:kite/component/future_builder.dart';
import 'package:kite/util/flash.dart';
import 'package:kite/util/url_launcher.dart';

import '../entity/detail.dart';
import '../init.dart';
import 'component/background.dart';
import 'component/util.dart';

String _getActivityUrl(int activityId) {
  return 'http://sc.sit.edu.cn/public/activity/activityDetail.action?activityId=$activityId';
}

class DetailPage extends StatelessWidget {
  final int activityId;
  final bool hideApplyButton;

  const DetailPage(this.activityId, {this.hideApplyButton = false, Key? key}) : super(key: key);

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('活动详情'),
      actions: [
        IconButton(
          icon: const Icon(Icons.open_in_browser),
          onPressed: () {
            launchUrlInBrowser(_getActivityUrl(activityId));
          },
        )
      ],
    );
  }

  Widget _buildBasicInfo(BuildContext context, ActivityDetail detail) {
    final valueStyle = Theme.of(context).textTheme.bodyText2;
    final keyStyle = valueStyle?.copyWith(fontWeight: FontWeight.bold);

    buildRow(String key, String value) => TableRow(
          children: [
            Text(key, style: keyStyle),
            Text(value, style: valueStyle),
          ],
        );

    final titleStyle = Theme.of(context).textTheme.headline2;
    final titleSections = extractTitle(detail.title);
    final title = titleSections.last;
    titleSections.removeLast();

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Padding(padding: const EdgeInsets.all(10), child: Text(title, style: titleStyle, softWrap: true)),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(3),
            },
            children: [
              buildRow('活动编号', detail.id.toString()),
              buildRow('地点', detail.place.toString()),
              buildRow('负责人', detail.undertaker.toString()),
              buildRow('管理方', detail.manager.toString()),
              buildRow('联系方式', detail.contact.toString()),
              buildRow('开始时间', detail.startTime.toString()),
              buildRow('时长', detail.duration.toString()),
              buildRow('标签', titleSections.join('\n')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, ActivityDetail detail) {
    return Stack(
      children: [
        const AspectRatio(
          aspectRatio: 1.8,
          child: Background(),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Card(margin: const EdgeInsets.all(8), child: _buildBasicInfo(context, detail)),
        )
      ],
    );
  }

  Widget _buildArticle(BuildContext context, String html) {
    final textStyle = Theme.of(context).textTheme.bodyText1;

    return Padding(
        padding: const EdgeInsets.all(20), child: HtmlWidget(html, isSelectable: true, textStyle: textStyle));
  }

  Widget _buildDetail(BuildContext context, ActivityDetail detail) {
    final List<Widget> items = [
      _buildInfoCard(context, detail),
      _buildArticle(context, detail.description ?? '暂无信息'),
      const SizedBox(height: 64),
    ];
    return SingleChildScrollView(
      child: Column(mainAxisSize: MainAxisSize.min, children: items),
    );
  }

  Widget _buildBody(BuildContext context) {
    return MyFutureBuilder<ActivityDetail>(
      futureGetter: () => ScInitializer.scActivityDetailService.getActivityDetail(activityId),
      builder: (context, data) {
        return _buildDetail(context, data);
      },
    );
  }

  Future<void> _sendRequest(BuildContext context, bool force) async {
    try {
      final response = await ScInitializer.scJoinActivityService.join(activityId, force);
      showBasicFlash(context, Text(response));
    } catch (e) {
      showBasicFlash(context, Text('错误: ' + e.runtimeType.toString()), duration: const Duration(seconds: 3));
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
      floatingActionButton: !hideApplyButton
          ? InkWell(
              splashColor: Colors.blue,
              onTap: () async {
                // 常规模式报名活动
                _sendRequest(context, false);
              },
              onDoubleTap: () {
                // 报名活动（强制模式）
                _sendRequest(context, true);
              },
              child: const FloatingActionButton.extended(
                icon: Icon(Icons.person_add),
                label: Text('报名'),
                onPressed: null,
              ),
            )
          : null,
    );
  }
}
