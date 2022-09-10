import 'package:flutter_test/flutter_test.dart';
import 'package:kite/feature/initializer_index.dart';
import 'package:kite/feature/library/search/init.dart';
import 'package:kite/feature/library/search/service/holding_preview.dart';
import 'package:kite_util/kite_util.dart';

void main() {
  test('test holding previews', () async {
    var a = await HoldingPreviewService(LibrarySearchInitializer.session).getHoldingPreviews([
      326130,
      170523,
      54387,
      170520,
      169833,
      495521,
      393649,
      309076,
      262547,
      465036,
    ].map((e) => e.toString()).toList());
    Log.info(a);
  });
}
