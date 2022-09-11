import 'package:flutter_test/flutter_test.dart';
import 'package:kite_feature_interface/kite_feature_interface.dart';
import 'package:kite_util_logger/kite_util_logger.dart';

class A extends AKiteFeature {
  A(super.parent);

  @override
  String get name => 'A';

  @override
  void onInit() {
    registerFeature(B(this));
    registerFeature(C(this));
    topic.subscribeTopicMessage(
      topic: 'topic1',
      callback: (KiteMessage message) {
        print(message);
      },
    );
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
    topic.subscribeTopicMessage(
      topic: 'topic1',
      callback: (KiteMessage message) {
        print(message);
      },
    );
    super.onInit();
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

    a.topic.getTopicMessageSender('C').send(topic: 'topic1', data: 123);
    a.topic.getTopicMessageSender('/A').send(topic: 'topic1', data: 123);
    a.topic.getTopicMessageSender('*').send(topic: 'topic1', data: 123);

    print(a.findFeatureByPath('/A/**'));
  });
}
