import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/models/weather.dart';
import 'package:app/config/config.dart';

class WeatherApiService {
  static const String apiKey = openWeatherApiKey;
  static const String baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  Future<Weather> fetchWeather(double lat, double lon) async {
    print('Fetching weather data for latitude: $lat, longitude: $lon');

    final response = await http.get(
        Uri.parse('$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric'));

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }
}
