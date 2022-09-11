library kite_weather_service_impl;

import 'package:kite_request_interface/kite_request_interface.dart';
import 'package:kite_weather_entity/kite_weather_entity.dart';
import 'package:kite_weather_service_interface/kite_weather_service_interface.dart';

class WeatherService extends AService implements WeatherDao {
  WeatherService(super.session);

  static String _getWeatherUrl(int campus) => 'https://kite.sunnysab.cn/api/v2/weather/$campus';

  @override
  Future<Weather> getCurrentWeather(int campus) async {
    final url = _getWeatherUrl(campus);
    final response = await session.request(url, RequestMethod.get);
    final weather = Weather.fromJson(response.data['data']);

    return weather;
  }
}
