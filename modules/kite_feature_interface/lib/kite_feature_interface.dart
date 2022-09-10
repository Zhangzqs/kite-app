library kite_feature_interface;

import 'package:flutter/widgets.dart';
import 'package:kite_util/kite_util.dart';

abstract class IRouteGenerator {
  // 判定该路由生成器是否能够生成指定路由名的路由
  bool accept(String routeName);
  WidgetBuilder onGenerateRoute(String routeName, Map<String, dynamic> arguments);
}

abstract class AKiteFeature {
  static void _iterate(AKiteFeature feature, bool? Function(AKiteFeature) m) {
    for (final child in feature.children.values) {
      if (m(child) ?? false) return;
      if (child.children.isNotEmpty) {
        _iterate(child, m);
      }
    }
  }

  /// 父 Feature
  AKiteFeature? parent;
  AKiteFeature(this.parent);

  /// 模块名称
  String get name;

  /// 路由生成器
  IRouteGenerator get routeGenerator {
    throw UnsupportedError('Feature $name unsupported to generate route');
  }

  /// 当模块初始化时
  /// parent 表示根Feature节点
  /// 当parent为 null 时，表示根节点
  void onInit() {
    for (final e in childrenRecursively.values) {
      e.onInit();
    }
  }

  /// 当模块收到消息时
  void onReceiveMessage(KiteMessage message) {
    Log.info('Feature $name receive: $message');
  }

  void sendMessage<T>(String receiver, [T? data]) {
    final targets = findFeatureByPath(receiver);
    if (targets.isEmpty) {
      Log.warn('No receiver at path: $receiver');
      return;
    }
    for (final target in targets) {
      final message = KiteMessage(
        sender: path,
        receiver: receiver,
        data: data,
      );
      target.onReceiveMessage(message);
    }
  }

  final Map<String, AKiteFeature> _features = {};

  Set<AKiteFeature> findFeatureByPath(String path) {
    List<String> pathElements = path.split('/');
    AKiteFeature result = this;
    if (pathElements[0].isEmpty) {
      // 绝对路径
      AKiteFeature root = findRoot();
      if (pathElements[1] != root.name) {
        throw Exception('Root feature is not equal actual: ${root.name} expect: ${pathElements[0]}');
      }
      result = root;
      pathElements = pathElements.sublist(2);
    }
    for (int i = 0; i < pathElements.length; i++) {
      if (pathElements[i] == '*') {
        return result.children.values.toSet();
      } else if (pathElements[i] == '**') {
        return result.childrenRecursively.values.toSet();
      }
      final next = result.children[pathElements[i]];
      if (next == null) {
        return {};
      }
      result = next;
    }
    return {result};
  }

  Set<AKiteFeature> findChildFeaturesByName(String name) {
    if (this.name == name) return {this};
    Set<AKiteFeature> result = {};
    _iterate(this, (e) {
      if (e.name == name) result.add(e);
      return false;
    });
    return result;
  }

  Map<String, AKiteFeature> get childrenRecursively {
    Map<String, AKiteFeature> result = {};
    _iterate(this, (e) {
      result[e.path] = e;
      return false; // 完整遍历
    });
    return result;
  }

  /// 获取当前feature包含的所有子feature
  Map<String, AKiteFeature> get children => _features;
  void registerFeature(AKiteFeature feature) {
    if (children.containsKey(feature.name)) {
      throw Exception('尝试注册一个重复的Feature: ${feature.name} 在 ${feature.parent?.name} 上');
    }
    _features[feature.name] = feature;
    Log.info('成功注册 Feature: ${feature.name} 在 ${feature.parent?.name} 上');
  }

  void unregisterFeature(AKiteFeature feature) {
    if (!children.containsKey(feature.name)) {
      throw Exception('尝试取消注册一个未注册的Feature: ${feature.name} 在 ${feature.parent?.name} 上');
    }
    _features.remove(feature.name);
    Log.info('成功卸载 Feature: ${feature.name} 在 ${feature.parent?.name} 上');
  }

  AKiteFeature findRoot() {
    AKiteFeature? root = this;
    while (root!.parent != null) {
      root = root.parent;
    }
    return root;
  }

  /// 获取该 feature 的绝对路径
  String get path {
    AKiteFeature? root = this;
    List<String> pathElements = [];
    while (root != null) {
      pathElements.add(root.name);
      root = root.parent;
    }
    return '/${pathElements.reversed.join('/')}';
  }

  @override
  int get hashCode => name.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is AKiteFeature && name == other.name) return true;
    return false;
  }

  @override
  String toString() {
    return 'KiteFeature-$name';
  }
}

class KiteMessage<T> {
  /// 发送者
  String sender = '';

  /// 若为空，则为广播消息
  String? receiver;

  T? data;

  KiteMessage({
    required this.sender,
    this.receiver,
    this.data,
  });

  @override
  String toString() {
    return 'KiteMessage{sender: $sender, receiver: $receiver, data: $data}';
  }
}
