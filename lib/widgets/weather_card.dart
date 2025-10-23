import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../models/weather.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;
  final String unitLabel;

  const WeatherCard({
    super.key,
    required this.weather,
    required this.unitLabel,
  });

  // 🔹 เลือกไฟล์แอนิเมชันตามคำอธิบายสภาพอากาศ
  String getAnimation(String description) {
    description = description.toLowerCase();

    if (description.contains('rain')) return 'assets/lottie/rainy icon.json';
    if (description.contains('cloud')) return 'assets/lottie/Cloud.json';
    if (description.contains('sun') || description.contains('clear')) return 'assets/lottie/Sunny.json';
    if (description.contains('snow')) return 'assets/lottie/Weather-snow.json';
    if (description.contains('night')) return 'assets/lottie/Weather-cloudy(night).json';

    // Default (กรณีหาไม่เจอ)
    return 'assets/lottie/Cloud.json';
  }

  // 🔹 เปลี่ยน Gradient ตามสภาพอากาศ
  LinearGradient getGradient(String description) {
    description = description.toLowerCase();

    if (description.contains('rain')) {
      return const LinearGradient(colors: [Color(0xFF283E51), Color(0xFF485563)]);
    } else if (description.contains('cloud')) {
      return const LinearGradient(colors: [Color(0xFF304352), Color(0xFFD7D2CC)]);
    } else if (description.contains('sun') || description.contains('clear')) {
      return const LinearGradient(colors: [Color(0xFFFFB75E), Color(0xFFED8F03)]);
    } else if (description.contains('snow')) {
      return const LinearGradient(colors: [Color(0xFF83A4D4), Color(0xFFB6FBFF)]);
    } else if (description.contains('night')) {
      return const LinearGradient(colors: [Color(0xFF141E30), Color(0xFF243B55)]);
    } else {
      return const LinearGradient(colors: [Color(0xFF1C2541), Color(0xFF0B132B)]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: getGradient(weather.description),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          )
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${weather.cityName}, ${weather.countryCode}',
            style: GoogleFonts.prompt(
              color: Colors.white.withOpacity(0.9),
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          // 🔹 แสดงแอนิเมชัน Lottie
          Lottie.asset(
            getAnimation(weather.description),
            width: 150,
            height: 150,
            fit: BoxFit.contain,
          ),
          Text(
            '${weather.temperature.toStringAsFixed(0)}$unitLabel',
            style: GoogleFonts.prompt(
              color: Colors.white,
              fontSize: 64,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            weather.description.toUpperCase(),
            style: GoogleFonts.prompt(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfo(Icons.air, '${weather.windSpeed} m/s', 'Wind'),
              _buildInfo(Icons.water_drop, '${weather.humidity}%', 'Humidity'),
              _buildInfo(Icons.cloud, weather.iconCode, 'Code'),
            ],
          ),
          const SizedBox(height: 25),
          _forecastSection(),
        ],
      ),
    );
  }

  Widget _buildInfo(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 22),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }

  Widget _forecastSection() {
    final fakeForecast = [
      {'day': 'Sun', 'temp': 29, 'icon': '☀️'},
      {'day': 'Mon', 'temp': 31, 'icon': '🌦'},
      {'day': 'Tue', 'temp': 30, 'icon': '🌧'},
      {'day': 'Wed', 'temp': 28, 'icon': '🌩'},
      {'day': 'Thu', 'temp': 29, 'icon': '☁️'},
    ];

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: fakeForecast.map((f) {
          return Column(
            children: [
              Text(f['day'].toString(), style: const TextStyle(color: Colors.white70)),
              Text(f['icon'].toString(), style: const TextStyle(fontSize: 20)),
              Text('${f['temp']}°', style: const TextStyle(color: Colors.white)),
            ],
          );
        }).toList(),
      ),
    );
  }
}
