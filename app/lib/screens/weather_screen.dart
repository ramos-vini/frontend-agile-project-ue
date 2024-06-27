import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/providers/weather_provider.dart';
import 'package:app/providers/forecast_provider.dart';
import 'package:app/widgets/weather_conditions.dart';
import 'package:app/widgets/weather_temperature.dart';
import 'package:app/models/weather.dart';
import 'package:app/models/forecast.dart';
import 'package:app/providers/location_provider.dart';

class WeatherScreen extends StatefulWidget {
  final String timeframe;

  const WeatherScreen({required this.timeframe, Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch forecast data when the widget is first displayed
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchForecast();
    });
  }

  Future<void> _fetchForecast() async {
    final locationProvider = context.read<LocationProvider>();
    if (locationProvider.currentPosition != null) {
      if (widget.timeframe == 'today') {
        context.read<WeatherProvider>().fetchWeather(
            locationProvider.currentPosition!.latitude,
            locationProvider.currentPosition!.longitude);
      } else if (widget.timeframe == 'tomorrow') {
        context.read<ForecastProvider>().fetchForecast(
            locationProvider.currentPosition!.latitude,
            locationProvider.currentPosition!.longitude);
      }
    } else {
      print('No position available');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.timeframe == 'today') {
      return Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          if (weatherProvider.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (weatherProvider.weather == null) {
            return const Center(
                child: Text('Failed to load weather data',
                    style: TextStyle(color: Colors.white)));
          }

          final Weather weather = weatherProvider.weather!;

          return Column(
            children: [
              WeatherConditions(weather: weather),
              const SizedBox(height: 80),
              WeatherTemperature(weather: weather),
            ],
          );
        },
      );
    } else if (widget.timeframe == 'tomorrow') {
      return Consumer<ForecastProvider>(
        builder: (context, forecastProvider, child) {
          if (forecastProvider.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (forecastProvider.forecast == null) {
            return const Center(
                child: Text('Failed to load forecast data',
                    style: TextStyle(color: Colors.white)));
          }

          final Forecast weather = forecastProvider.forecast!.forecasts.first;

          return Column(
            children: [
              WeatherConditions(weather: weather),
              const SizedBox(height: 80),
              WeatherTemperature(weather: weather),
            ],
          );
        },
      );
    } else {
      return const Center(
          child:
              Text('Invalid timeframe', style: TextStyle(color: Colors.white)));
    }
  }
}