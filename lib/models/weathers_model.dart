class WeatherResponse {
  final String name;
  final MainInfo main;
  final List<WeatherInfo> weather;
  final WindInfo wind;

  WeatherResponse({
    required this.name,
    required this.main,
    required this.weather,
    required this.wind,
  });

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    return WeatherResponse(
      name: json['name'] ?? '-',
      main: MainInfo.fromJson(json['main'] ?? {}),
      weather: (json['weather'] as List<dynamic>? ?? [])
          .map((e) => WeatherInfo.fromJson(e))
          .toList(),
      wind: WindInfo.fromJson(json['wind'] ?? {}),
    );
  }
}

class MainInfo {
  final double temp;
  final double feelsLike;
  final int humidity;

  MainInfo(
      {required this.temp, required this.feelsLike, required this.humidity});

  factory MainInfo.fromJson(Map<String, dynamic> json) {
    return MainInfo(
      temp: (json['temp'] as num?)?.toDouble() ?? 0.0,
      feelsLike: (json['feels_like'] as num?)?.toDouble() ?? 0.0,
      humidity: (json['humidity'] as num?)?.toInt() ?? 0,
    );
  }
}

class WeatherInfo {
  final String main;
  final String description;
  final String icon;

  WeatherInfo(
      {required this.main, required this.description, required this.icon});

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    return WeatherInfo(
      main: json['main'] ?? '-',
      description: json['description'] ?? '-',
      icon: json['icon'] ?? '01d',
    );
  }
}

class WindInfo {
  final double speed;

  WindInfo({required this.speed});

  factory WindInfo.fromJson(Map<String, dynamic> json) {
    return WindInfo(
      speed: (json['speed'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
