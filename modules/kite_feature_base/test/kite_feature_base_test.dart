import 'package:flutter_test/flutter_test.dart';
import 'package:kite_feature_base/kite_feature_base.dart';
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
        print("A receive: $message");
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
        print("C receive: $message");
      },
    );
    service.bindService(
      serviceName: 'service1',
      serviceCallback: ([List<dynamic>? args]) {
        return args![0] + args[1];
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

    final broadcastSender = a.topic.getTopicMessageSender('/A/**');
    print('Broadcast Receiver: ${broadcastSender.features}');
    broadcastSender.send(topic: 'topic1', data: 1234);

    final cSender = a.topic.getTopicMessageSender('C');
    cSender.send(topic: 'topic1', data: 123);

    final s1 = a.service.getService(featurePath: '/A/C', serviceName: 'service1');
    final s1Result = s1([1, 2]);
    Log.info('s1 result: $s1Result');
  });
}
