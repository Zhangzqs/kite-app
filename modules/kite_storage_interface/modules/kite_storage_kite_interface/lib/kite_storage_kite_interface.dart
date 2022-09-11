library kite_storage_kite_interface;

import 'package:kite_user_entity/kite_user_entity.dart';

abstract class KiteStorageDao {
  KiteUser? get userProfile;
  set userProfile(KiteUser? foo);
}
