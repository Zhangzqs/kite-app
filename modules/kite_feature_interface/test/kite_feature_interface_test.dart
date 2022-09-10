import 'package:flutter_test/flutter_test.dart';
import 'package:kite_feature_interface/kite_feature_interface.dart';
import 'package:kite_util/kite_util.dart';

class A extends AKiteFeature {
  A(super.parent);

  @override
  String get name => 'A';

  @override
  void onInit() {
    registerFeature(B(this));
    registerFeature(C(this));
    super.onInit();
  }
}

class B extends AKiteFeature {
  B(super.parent);
  @override
  String get name => 'B';
}

class C extends AKiteFeature {
  C(super.parent);

  @override
  String get name => 'C';

  @override
  void onInit() {
    registerFeature(D(this));
  }
}

class D extends AKiteFeature {
  D(super.parent);

  @override
  String get name => 'D';
}

void main() {
  test('asd', () {
    A a = A(null);
    a.onInit();
    Log.info('已注册的模块路径如下：');
    a.childrenRecursively.values.forEach((element) {
      Log.info(element.path);
    });

    a.sendMessage('C', 123);
    a.sendMessage('/A', 123);
    a.sendMessage('*', 123);
    print(a.findFeatureByPath('/A/**'));
  });
}
