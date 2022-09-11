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
import 'package:kite/feature/office/init.dart';
import 'package:kite/global/global.dart';
import 'package:kite/storage/init.dart';

import 'index.dart';

class OfficeItem extends StatefulWidget {
  const OfficeItem({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OfficeItemState();
}

class _OfficeItemState extends State<OfficeItem> {
  static const defaultContent = '通过应网办办理业务';
  String? content;

  @override
  void initState() {
    Global.eventBus.on(EventNameConstants.onHomeRefresh, _onHomeRefresh);
    return super.initState();
  }

  @override
  void dispose() {
    Global.eventBus.off(EventNameConstants.onHomeRefresh, _onHomeRefresh);
    super.dispose();
  }

  void _onHomeRefresh(_) async {
    if (!mounted) return;
    final String result = await _buildContent();
    KvStorageInitializer.home.lastOfficeStatus = result;
    setState(() => content = result);
  }

  Future<String> _buildContent() async {
    format(s, x) => x > 0 ? '$s ($x)' : '';
    try {
      final totalMessage = await OfficeInitializer.messageService.queryMessageCount();
      final draftBlock = format('草稿', totalMessage.inDraft);
      final doingBlock = format('在办', totalMessage.inProgress);
      final completedBlock = format('完成', totalMessage.completed);

      return '$draftBlock $doingBlock $completedBlock'.trim();
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 如果是首屏加载, 从缓存读
    if (content == null) {
      final String? lastOfficeStatus = KvStorageInitializer.home.lastOfficeStatus;
      content = lastOfficeStatus ?? defaultContent;
    }
    return HomeFunctionButton(route: '/office', icon: 'assets/home/icon_office.svg', title: '办公', subtitle: content);
  }
}
