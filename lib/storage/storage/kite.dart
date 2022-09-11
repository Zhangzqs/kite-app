import 'package:kite_storage_interface/kite_storage_interface.dart';
import 'package:kite_user_entity/kite_user_entity.dart';

import 'common.dart';

class KiteStorageKeys {
  static const _namespace = '/kite';
  static const userProfile = '$_namespace/userProfile';
}

class KiteStorage extends JsonStorage implements KiteStorageDao {
  KiteStorage(super.box);

  @override
  KiteUser? get userProfile => getModel(KiteStorageKeys.userProfile, KiteUser.fromJson);

  @override
  set userProfile(KiteUser? foo) => setModel<KiteUser>(KiteStorageKeys.userProfile, foo, (e) => e.toJson());
}
