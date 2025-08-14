import 'package:flutter/foundation.dart';
import '../models/weathers_model.dart';
import '../repositories/weather_repository.dart';

enum WeatherState { idle, loading, loaded, error }

class WeatherViewModel extends ChangeNotifier {
  final WeatherRepository repo;
  WeatherViewModel(this.repo);

  WeatherState state = WeatherState.idle;
  WeatherResponse? data;
  String? error;

  Future<void> getByCoords(double lat, double lon) async {
    state = WeatherState.loading;
    error = null;
    notifyListeners();
    try {
      data = await repo.byCoords(lat, lon);
      state = WeatherState.loaded;
    } catch (e) {
      error = e.toString();
      state = WeatherState.error;
    }
    notifyListeners();
  }

  Future<void> getByCity(String city) async {
    state = WeatherState.loading;
    error = null;
    notifyListeners();
    try {
      data = await repo.byCity(city);
      state = WeatherState.loaded;
    } catch (e) {
      error = e.toString();
      state = WeatherState.error;
    }
    notifyListeners();
  }
}
