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

import 'package:catcher/catcher.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kite_component/kite_component.dart';
import 'package:kite_feature_route_table/kite_feature_route_table.dart';

typedef MyWidgetBuilder<T> = KiteWidgetBuilder<T>;
typedef MyFutureBuilderError = KiteFutureBuilderError;
typedef MyFutureBuilderController = KiteFutureBuilderController;

class MyFutureBuilder<T> extends StatelessWidget {
  final MyWidgetBuilder<T>? builder;
  final MyWidgetBuilder<KiteFutureBuilderError>? onErrorBuilder;
  final MyFutureBuilderController? controller;

  /// 建议使用该参数代替future, 否则可能无法正常实现刷新功能
  final Future<T> Function()? futureGetter;

  /// 刷新之前回调
  final Future<void> Function()? onPreRefresh;

  /// 刷新后回调
  final Future<void> Function()? onPostRefresh;

  /// 是否启用下拉刷新
  final bool enablePullRefresh;

  const MyFutureBuilder({
    Key? key,
    this.builder,
    this.onErrorBuilder,
    this.controller,
    this.futureGetter,
    this.onPreRefresh,
    this.onPostRefresh,
    this.enablePullRefresh = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final kiteController = controller ?? KiteFutureBuilderController();

    return KiteFutureBuilder(
      builder: builder,
      onErrorBuilder: (BuildContext context, KiteFutureBuilderError kiteFutureBuilderError) {
        final error = kiteFutureBuilderError.error;
        final stackTrace = kiteFutureBuilderError.stacktrace;
        // 单独处理网络连接错误，且不上报
        if (error is DioError && [DioErrorType.connectTimeout, DioErrorType.other].contains((error).type)) {
          return Center(
            child: Column(
              children: [
                const Text('网络连接超时，请检查是否连接到校园网环境(也有可能学校临时维护服务器，请以网页登录结果为准)'),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pushReplacementNamed(RouteTable.connectivity),
                  child: const Text('进入网络工具检查'),
                ),
                TextButton(
                  onPressed: kiteController.refresh,
                  child: const Text('刷新页面'),
                ),
              ],
            ),
          );
        }

        Catcher.reportCheckedError(error, stackTrace);
        return null;
      },
      controller: kiteController,
      futureGetter: futureGetter,
      onPreRefresh: onPreRefresh,
      onPostRefresh: onPostRefresh,
      enablePullRefresh: enablePullRefresh,
    );
  }
}
