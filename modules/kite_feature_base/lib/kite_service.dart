part of 'kite_feature_base.dart';

typedef KiteServiceCallback = dynamic Function([List<dynamic>? args]);

class FeatureService {
  AKiteFeature feature;
  FeatureService(this.feature);

  /// 已绑定的服务
  Map<String, KiteServiceCallback> boundService = {};
  void bindService({
    required String serviceName,
    required KiteServiceCallback serviceCallback,
  }) {
    if (boundService.containsKey(serviceName)) {
      throw Exception('已绑定服务：$serviceName 在 feature: ${feature.name} 上');
    }
    boundService[serviceName] = serviceCallback;
  }

  void unbindService({required String serviceName}) {
    if (!boundService.containsKey(serviceName)) {
      throw Exception('未绑定服务：$serviceName 在 feature: ${feature.name} 上');
    }
    boundService.remove(serviceName);
  }

  KiteServiceCallback getService({
    required String featurePath,
    required String serviceName,
  }) {
    final features = feature.findFeatureByPath(featurePath);
    if (features.isEmpty) {
      throw Exception('Not found feature path: $featurePath');
    }
    if (features.length != 1) {
      throw Exception('Not unique feature path: $featurePath');
    }
    final targetFeature = features.first;
    final service = targetFeature.service.boundService[serviceName];
    if (service == null) {
      throw Exception('Not found feature service: $serviceName in feature $featurePath');
    }
    return service;
  }
}
