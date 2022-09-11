import 'package:flutter/material.dart';

abstract class IRouteGenerator {
  // 判定该路由生成器是否能够生成指定路由名的路由
  bool accept(String routeName);
  WidgetBuilder onGenerateRoute(String routeName, Map<String, dynamic> arguments);
}
