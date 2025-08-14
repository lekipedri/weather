import '../models/weathers_model.dart';
import '../services/weather_api_client.dart';

class WeatherRepository {
  final WeatherApiClient api;
  WeatherRepository(this.api);

  Future<WeatherResponse> byCoords(double lat, double lon) =>
      api.fetchByCoords(lat: lat, lon: lon);
  Future<WeatherResponse> byCity(String city) => api.fetchByCity(city);
}
