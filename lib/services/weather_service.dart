import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

enum TempUnit { celsius, fahrenheit, kelvin }

class WeatherService {
  static const String _apiKey = '0b2e39883181f25735c140e133e585b5';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  String _unitParam(TempUnit unit) {
    switch (unit) {
      case TempUnit.celsius:
        return 'metric'; // °C
      case TempUnit.fahrenheit:
        return 'imperial'; // °F
      case TempUnit.kelvin:
        return ''; // ไม่มีพารามิเตอร์ = Kelvin
    }
  }

  Future<Weather> getByCityCountry({
    required String city,
    required String countryCode,
    required TempUnit unit,
  }) async {
    final units = _unitParam(unit);
    final uri = Uri.parse(
        '$_baseUrl?q=$city,$countryCode&appid=$_apiKey${units.isNotEmpty ? '&units=$units' : ''}');
    return _fetch(uri);
  }

  Future<Weather> getByZipCountry({
    required String zip,
    required String countryCode,
    required TempUnit unit,
  }) async {
    final units = _unitParam(unit);
    final uri = Uri.parse(
        '$_baseUrl?zip=$zip,$countryCode&appid=$_apiKey${units.isNotEmpty ? '&units=$units' : ''}');
    return _fetch(uri);
  }

  Future<Weather> getByCoords({
    required double lat,
    required double lon,
    required TempUnit unit,
  }) async {
    final units = _unitParam(unit);
    final uri = Uri.parse(
        '$_baseUrl?lat=$lat&lon=$lon&appid=$_apiKey${units.isNotEmpty ? '&units=$units' : ''}');
    return _fetch(uri);
  }

  Future<Weather> _fetch(Uri uri) async {
    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return Weather.fromJson(data);
  }
}