library kite_feature_route;

import 'package:flutter/material.dart';
import 'package:kite_feature_base/kite_feature_base.dart';

abstract class IRouteGenerator {
  // 判定该路由生成器是否能够生成指定路由名的路由
  bool accept(String routeName);
  WidgetBuilder onGenerateRoute(String routeName, Map<String, dynamic> arguments);
}

typedef NamedRouteBuilder = Widget Function(BuildContext context, Map<String, dynamic> args);

class StaticRouteTable implements IRouteGenerator {
  final Map<String, NamedRouteBuilder> table;
  StaticRouteTable(this.table);

  @override
  bool accept(String routeName) => table.containsKey(routeName);

  @override
  WidgetBuilder onGenerateRoute(String routeName, Map<String, dynamic> arguments) {
    return (context) {
      return table[routeName]!(context, arguments);
    };
  }
}

extension KiteFeatureRouteBinder on AKiteFeature {
  void registerRoute(IRouteGenerator routeGenerator) => parameterList['/route'] = routeGenerator;
  IRouteGenerator get route => parameterList['/route'];
}
