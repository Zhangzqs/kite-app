part of 'kite_feature_interface.dart';

class FeatureParameterList extends SplayTreeMap<String, dynamic> {
  AKiteFeature feature;
  FeatureParameterList(this.feature);

  FeatureParameterList getParameterList({required String featurePath}) {
    final features = feature.findFeatureByPath(featurePath);
    if (features.length != 1) {
      throw Exception('Not unique feature path: $featurePath');
    }
    return features.first.parameterList;
  }
}
