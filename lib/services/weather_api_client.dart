import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/weathers_model.dart';

class WeatherApiClient {
  static const String _base = 'https://api.openweathermap.org/data/2.5';
  final String apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';
  Future<WeatherResponse> fetchByCoords(
      {required double lat, required double lon}) async {
    final uri = Uri.parse(
        '$_base/weather?lat=$lat&lon=$lon&appid=${apiKey}&units=metric');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return WeatherResponse.fromJson(data);
    } else {
      throw WeatherApiException(_errorMessage(res.statusCode, res.body));
    }
  }

  Future<WeatherResponse> fetchByCity(String city) async {
    final uri =
        Uri.parse('$_base/weather?q=$city&appid=${apiKey}&units=metric');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return WeatherResponse.fromJson(data);
    } else {
      throw WeatherApiException(_errorMessage(res.statusCode, res.body));
    }
  }

  String _errorMessage(int status, String body) {
    switch (status) {
      case 401:
        return 'Invalid API key. Please check your OpenWeather API key.';
      case 404:
        return 'City not found. Please try another name.';
      default:
        return 'Failed to fetch weather (HTTP $status).';
    }
  }
}

class WeatherApiException implements Exception {
  final String message;
  WeatherApiException(this.message);
  @override
  String toString() => message;
}
