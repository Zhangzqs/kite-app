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

import 'dart:convert';

import 'package:kite/feature/freshman/dao.dart';
import 'package:kite/feature/freshman/entity.dart';
import 'package:kite/mock/index.dart';
import 'package:kite_request_interface/kite_request_interface.dart';

class FreshmanService extends AService implements FreshmanDao {
  FreshmanService(super.session);

  @override
  Future<FreshmanInfo> getInfo() async {
    final response = await session.request('', RequestMethod.get);
    return FreshmanInfo.fromJson(response.data);
  }

  @override
  Future<void> update({Contact? contact, bool? visible}) async {
    await session.request('/update', RequestMethod.put, data: {
      if (contact != null) 'contact': jsonEncode(contact.toJson()),
      if (visible != null) 'visible': visible,
    });
  }

  @override
  Future<List<Mate>> getRoommates() async {
    final response = await session.request('/roommate', RequestMethod.get);
    List<dynamic> roommates = response.data['roommates']!;
    return roommates.map((e) => Mate.fromJson(e)).toList();
  }

  @override
  Future<List<Familiar>> getFamiliars() async {
    final response = await session.request('/familiar', RequestMethod.get);
    List<dynamic> fellows = response.data['peopleFamiliar']!;
    return fellows.map((e) => Familiar.fromJson(e)).toList();
  }

  @override
  Future<List<Mate>> getClassmates() async {
    final response = await session.request('/classmate', RequestMethod.get);
    List<dynamic> classmate = response.data['classmates']!;
    return classmate.map((e) => Mate.fromJson(e)).toList();
  }

  @override
  Future<Analysis> getAnalysis() async {
    final response = await session.request('/analysis', RequestMethod.get);
    return Analysis.fromJson(response.data['freshman']);
  }

  @override
  Future<void> postAnalysisLog() async {
    await session.request('/analysis/log', RequestMethod.post);
  }
}
