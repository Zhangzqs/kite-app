library kite_future_builder;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

typedef KiteWidgetBuilder<T> = Widget? Function(BuildContext context, T data);

class KiteFutureBuilderError {
  final dynamic error;
  final dynamic stacktrace;

  KiteFutureBuilderError(this.error, this.stacktrace);
}

class KiteFutureBuilderController<T> {
  late _KiteFutureBuilderState<T> _state;
  void _bindState(State<KiteFutureBuilder<T>> state) => _state = state as _KiteFutureBuilderState<T>;

  Future<T> refresh() => _state.refresh();
}

class KiteFutureBuilder<T> extends StatefulWidget {
  final KiteWidgetBuilder<T>? builder;
  final KiteWidgetBuilder<KiteFutureBuilderError>? onErrorBuilder;
  final KiteFutureBuilderController? controller;

  /// 建议使用该参数代替future, 否则可能无法正常实现刷新功能
  final Future<T> Function()? futureGetter;

  /// 刷新之前回调
  final Future<void> Function()? onPreRefresh;

  /// 刷新后回调
  final Future<void> Function()? onPostRefresh;

  /// 是否启用下拉刷新
  final bool enablePullRefresh;

  const KiteFutureBuilder({
    Key? key,
    required this.builder,
    this.onErrorBuilder,
    this.controller,
    this.enablePullRefresh = false,
    this.onPreRefresh,
    this.onPostRefresh,
    required this.futureGetter,
  }) : super(key: key);

  @override
  State<KiteFutureBuilder<T>> createState() => _KiteFutureBuilderState<T>();
}

class _KiteFutureBuilderState<T> extends State<KiteFutureBuilder<T>> {
  Completer<T> completer = Completer();

  Future<T> refresh() {
    setState(() {});
    return completer.future;
  }

  Widget buildWhenSuccessful(T? data) {
    if (!completer.isCompleted) completer.complete(data);
    if (widget.builder == null) return Text(data.toString());
    final successfulWidget = widget.builder!(context, data as T);
    if (successfulWidget == null) return const Text('null');
    return successfulWidget;
  }

  Widget buildWhenError(error, stackTrace) {
    if (!completer.isCompleted) completer.completeError(error, stackTrace);

    if (widget.onErrorBuilder != null) {
      final errorWidget = widget.onErrorBuilder!(context, KiteFutureBuilderError(error, stackTrace));
      if (errorWidget != null) {
        return errorWidget;
      }
    }

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(error.toString()),
          ],
        ),
      ),
    );
  }

  Widget buildWhenOther(AsyncSnapshot<T> snapshot) {
    if (!completer.isCompleted) completer.complete();
    throw Exception('snapshot has no data or error');
  }

  Widget buildWhenLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Future<T> fetchData() async {
    if (widget.futureGetter != null) {
      return await widget.futureGetter!();
    }
    throw UnsupportedError('MyFutureBuilder must set a future or futureGetter');
  }

  Widget buildFutureBuilder() {
    return FutureBuilder<T>(
      key: UniqueKey(),
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return buildWhenSuccessful(snapshot.data);
          } else if (snapshot.hasError) {
            return buildWhenError(snapshot.error, snapshot.stackTrace);
          } else {
            return buildWhenOther(snapshot);
          }
        }
        return buildWhenLoading();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget result = buildFutureBuilder();

    RefreshController refreshController = RefreshController();
    if (widget.enablePullRefresh) {
      result = SmartRefresher(
        controller: refreshController,
        onRefresh: () async {
          completer = Completer();
          if (widget.onPreRefresh != null) await widget.onPreRefresh!();
          await refresh();
          refreshController.refreshCompleted();
          if (widget.onPostRefresh != null) await widget.onPostRefresh!();
        },
        child: result,
      );
    }
    return result;
  }

  @override
  void initState() {
    widget.controller?._bindState(this);
    super.initState();
  }
}
