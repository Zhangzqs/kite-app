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

import 'package:hive_flutter/hive_flutter.dart';
import 'package:kite/storage/dao/home.dart';
import 'package:kite/storage/storage/admin.dart';
import 'package:kite/storage/storage/develop.dart';
import 'package:kite/storage/storage/kite.dart';
import 'package:kite/storage/storage/report.dart';
import 'package:kite_storage_interface/kite_storage_interface.dart';

import 'dao/freshman.dart';
import 'storage/index.dart';

export 'storage/index.dart';

class KvStorageInitializer {
  static late ThemeSettingDao theme;
  static late AuthStorageDao auth;
  static late AdminSettingDao admin;
  static late NetworkSettingDao network;
  static late JwtDao jwt;
  static late JwtDao sitAppJwt;
  static late HomeSettingDao home;
  static late FreshmanCacheDao freshman;
  static late DevelopOptionsDao developOptions;
  static late ReportStorageDao report;
  static late KiteStorageDao kite;

  static late Box<dynamic> kvStorageBox;

  static Future<void> init({
    required Box<dynamic> kvStorageBox,
  }) async {
    KvStorageInitializer.kvStorageBox = kvStorageBox;
    auth = AuthStorage(kvStorageBox);
    admin = AdminSettingStorage(kvStorageBox);
    home = HomeSettingStorage(kvStorageBox);
    theme = ThemeSettingStorage(kvStorageBox);
    network = NetworkSettingStorage(kvStorageBox);
    jwt = JwtStorage(kvStorageBox);
    sitAppJwt = SitAppJwtStorage(kvStorageBox);
    freshman = FreshmanCacheStorage(kvStorageBox);
    developOptions = DevelopOptionsStorage(kvStorageBox);
    report = ReportStorage(kvStorageBox);
    kite = KiteStorage(kvStorageBox);
  }
}
