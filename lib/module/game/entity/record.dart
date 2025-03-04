/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import 'package:json_annotation/json_annotation.dart';
import '../using.dart';
import 'type.dart';
part 'record.g.dart';

@HiveType(typeId: HiveTypeIdPool.gameRecordItem)
@JsonSerializable()
class GameRecord {
  /// 游戏类型
  @HiveField(0)
  @JsonKey(name: 'game', toJson: GameType.toIndex, fromJson: GameType.fromIndex)
  final GameType type;

  /// 得分
  @HiveField(1)
  final int score;

  /// 游戏开始的时间
  @HiveField(2)
  @JsonKey(name: 'dateTime')
  DateTime ts;

  /// 该局用时 （秒）
  @HiveField(3)
  final int timeCost;

  GameRecord(this.type, this.score, this.ts, this.timeCost);

  Map<String, dynamic> toJson() => _$GameRecordToJson(this);

  factory GameRecord.fromJson(Map<String, dynamic> json) => _$GameRecordFromJson(json);

  @override
  String toString() {
    return 'GameRecord{type: $type, score: $score, ts: $ts, timeCost: $timeCost}';
  }
}
