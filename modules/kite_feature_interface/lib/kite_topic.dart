part of 'kite_feature_interface.dart';

typedef KiteMessageCallback = void Function(KiteMessage message);

class KiteMessage<T> {
  /// 话题
  String topic;

  /// 发送者
  String sender;

  /// 接收者
  String receiver;

  T? data;

  KiteMessage({
    required this.topic,
    required this.sender,
    required this.receiver,
    this.data,
  });

  @override
  String toString() {
    return 'KiteMessage{topic: $topic, sender: $sender, receiver: $receiver, data: $data}';
  }
}

class TopicMessageSender {
  Set<AKiteFeature> features;
  String sender;
  TopicMessageSender(this.sender, this.features);

  void send<T>({
    required String topic,
    bool onlyOnce = false, // 是否只要第一个接收者收到后便不再继续广播？
    T? data,
  }) {
    for (final target in features) {
      final message = KiteMessage(
        topic: topic,
        data: data,
        sender: sender,
        receiver: target.path,
      );
      final callback = target.topic.subscribedTopicMessage[topic];
      if (callback != null) {
        // 通知订阅者的回调传递该消息
        callback(message);
        if (onlyOnce) return;
      }
    }
  }
}

class FeatureTopic {
  AKiteFeature feature;
  FeatureTopic(this.feature);

  /// 已订阅的消息
  Map<String, KiteMessageCallback> subscribedTopicMessage = {};

  /// 订阅一个话题消息
  void subscribeTopicMessage({
    required String topic,
    required KiteMessageCallback callback,
  }) {
    if (subscribedTopicMessage.containsKey(topic)) {
      throw Exception('已订阅话题：$topic 在 feature: ${feature.name} 上');
    }
    subscribedTopicMessage[topic] = callback;
  }

  /// 取消订阅一个话题消息
  void unsubscribeTopicMessage({required String topic}) {
    if (!subscribedTopicMessage.containsKey(topic)) {
      throw Exception('未订阅话题：$topic 在 feature: ${feature.name} 上');
    }
    subscribedTopicMessage.remove(topic);
  }

  /// 发布一个话题消息
  TopicMessageSender getTopicMessageSender<T>([
    String receiver = '/**', // 默认是全局广播消息
  ]) {
    final targets = feature.findFeatureByPath(receiver);
    if (targets.isEmpty) {
      Log.warn('No receiver at path: $receiver');
    }
    return TopicMessageSender(feature.path, targets);
  }
}
