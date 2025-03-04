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
/// 存放所有 hive 的自定义类型的typeId
// TODO: Rename to HiveTypeId
class HiveTypeIdPool {
  HiveTypeIdPool._();
  static const librarySearchHistoryItem = 1;
  static const authItem = 2; // 改为单用户后已不再使用该id
  static const weatherItem = 3;
  static const reportHistoryItem = 4;
  static const balanceItem = 5;
  static const courseItem = 6;
  static const expenseItem = 7;
  static const expenseTypeItem = 8;
  static const contactItem = 9;
  static const userEventTypeItem = 10;
  static const userEventItem = 11;
  static const gameTypeItem = 12;
  static const gameRecordItem = 13;
  static const functionTypeItem = 14;
  static const timetableMetaItem = 15;
}
