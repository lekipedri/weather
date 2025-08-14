import 'package:flutter/material.dart';
import '../models/weathers_model.dart';

class WeatherCard extends StatelessWidget {
  final WeatherResponse weather;
  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final w = weather.weather.isNotEmpty ? weather.weather.first : null;
    final iconUrl =
        w != null ? 'https://openweathermap.org/img/wn/${w.icon}@2x.png' : null;

    return Card(
      color: Colors.white.withOpacity(0.2), // ungu gelap transparan
      elevation: 4,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (iconUrl != null)
                  Image.network(iconUrl, width: 64, height: 64),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        weather.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (w != null)
                        Text(
                          '${w.main} • ${w.description}',
                          style: TextStyle(color: Colors.white70),
                        ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                _chip('Temp', '${weather.main.temp.toStringAsFixed(1)} °C'),
                _chip(
                    'Feels', '${weather.main.feelsLike.toStringAsFixed(1)} °C'),
                _chip('Humidity', '${weather.main.humidity}%'),
                _chip('Wind', '${weather.wind.speed} m/s'),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, String value) {
    return Chip(
      label: Text(
        '$label: $value',
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: const Color(0xFF2E2E5E), // ungu kebiruan
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
