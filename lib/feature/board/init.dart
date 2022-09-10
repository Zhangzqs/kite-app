import 'package:kite_request_interface/kite_request_interface.dart';

import 'service.dart';

class BoardInitializer {
  static late BoardService boardServiceDao;

  static void init({required ISession kiteSession}) {
    boardServiceDao = BoardService(kiteSession);
  }
}
