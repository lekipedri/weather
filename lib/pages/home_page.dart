import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/core/app_scaffold.dart';
import '../../services/location_service.dart';
import '../core/routes.dart';
import '../viewmodels/weather_viewmodels.dart';
import '../widgets/weather_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _cityCtrl = TextEditingController();
  String? username;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    username = ModalRoute.of(context)?.settings.arguments as String?;
  }

  @override
  void dispose() {
    _cityCtrl.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocationWeather(BuildContext context) async {
    final loc = LocationService();
    final ok = await loc.ensurePermission();
    if (!ok) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Location permission or service not available. Enable GPS and retry.')),
      );
      return;
    }

    final pos = await loc.getCurrentPosition();
    await context
        .read<WeatherViewModel>()
        .getByCoords(pos.latitude, pos.longitude);
  }

  Future<void> _searchByCity(BuildContext context) async {
    final city = _cityCtrl.text.trim();
    if (city.isEmpty) return;
    await context.read<WeatherViewModel>().getByCity(city);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WeatherViewModel>();
    final now = DateTime.now();
    final timeStr = DateFormat('EEEE, d MMM y • HH:mm').format(now);

    return AppScaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome${username != null ? ', $username' : ''}!',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: const Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                timeStr,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _cityCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Search by city',
                        labelStyle: const TextStyle(color: Colors.white70),
                        hintText: 'e.g. Jakarta',
                        hintStyle: const TextStyle(color: Colors.white38),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white.withOpacity(0.7)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                      ),
                      onSubmitted: (_) => _searchByCity(context),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent.withOpacity(0.8),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => _searchByCity(context),
                    child: const Text('Search'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withOpacity(0.7)),
                ),
                onPressed: () => _getCurrentLocationWeather(context),
                icon: const Icon(Icons.my_location),
                label: const Text('Use Current Location'),
              ),
              const SizedBox(height: 16),
              Builder(builder: (_) {
                switch (vm.state) {
                  case WeatherState.idle:
                    return const Text(
                      'No data yet. Search a city or use current location.',
                      style: TextStyle(color: Colors.white70),
                    );
                  case WeatherState.loading:
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    );
                  case WeatherState.error:
                    return Text(
                      vm.error ?? 'Unknown error',
                      style: const TextStyle(color: Colors.redAccent),
                    );
                  case WeatherState.loaded:
                    if (vm.data == null) {
                      return const Text('No data',
                          style: TextStyle(color: Colors.white70));
                    }
                    return WeatherCard(weather: vm.data!);
                }
              }),
              const SizedBox(height: 24),
              const Divider(color: Colors.white54),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent.withOpacity(0.8),
                  foregroundColor: Colors.white,
                ),
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, AppRoutes.login),
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
