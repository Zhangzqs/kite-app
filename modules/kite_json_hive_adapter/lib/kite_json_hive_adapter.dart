library kite_json_hive_adapter;

import 'dart:convert';

import 'package:hive/hive.dart';

class JsonStorage {
  final Box box;

  JsonStorage(this.box);

  void setModel<T>(
    String key,
    T? model,
    Map<String, dynamic> Function(T e) toJson,
  ) {
    if (model == null) {
      box.put(key, null);
      return;
    }
    box.put(key, jsonEncode(toJson(model)));
  }

  T? getModel<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    String? json = box.get(key);
    if (json == null) return null;
    return fromJson(jsonDecode(json));
  }

  List<T>? getModelList<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    String? json = box.get(key);
    if (json == null) return null;
    List<dynamic> list = jsonDecode(json);
    return list.map((e) => fromJson(e)).toList();
  }

  void setModelList<T>(
    String key,
    List<T>? foo,
    Map<String, dynamic> Function(T e) toJson,
  ) {
    if (foo == null) {
      box.put(key, null);
      return;
    }
    // 不为空时
    List<Map<String, dynamic>> list = foo.map((e) => toJson(e)).toList();
    String json = jsonEncode(list);
    box.put(key, json);
  }
}
