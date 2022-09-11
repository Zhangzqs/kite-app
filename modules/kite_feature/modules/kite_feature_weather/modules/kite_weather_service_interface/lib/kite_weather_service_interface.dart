library kite_weather_service_interface;

import 'package:kite_weather_entity/kite_weather_entity.dart';

abstract class WeatherDao {
  Future<Weather> getCurrentWeather(int campus);
}
