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
import 'package:kite_request_interface/kite_request_interface.dart';

import '../dao/holding_preview.dart';
import '../entity/holding_preview.dart';
import 'constant.dart';

class HoldingPreviewService extends AService implements HoldingPreviewDao {
  HoldingPreviewService(ISession session) : super(session);

  @override
  Future<HoldingPreviews> getHoldingPreviews(List<String> bookIdList) async {
    var response = await session.request(
      Constants.bookHoldingPreviewsUrl,
      RequestMethod.get,
      queryParameters: {
        'bookrecnos': bookIdList.join(','),
        'curLibcodes': '',
        'return_fmt': 'json',
      },
    );

    return HoldingPreviews.fromJson(response.data);
  }
}
