class Weather {
  final String cityName;
  final String countryCode;
  final double temperature; // หน่วยขึ้นกับที่ขอ (C/F/K)
  final String description;
  final int humidity;
  final double windSpeed;
  final String iconCode;

  Weather({
    required this.cityName,
    required this.countryCode,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.iconCode,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'] ?? '',
      countryCode: (json['sys']?['country'] ?? '') as String,
      temperature: (json['main']?['temp'] ?? 0).toDouble(),
      description: (json['weather']?[0]?['description'] ?? '') as String,
      humidity: (json['main']?['humidity'] ?? 0).toInt(),
      windSpeed: (json['wind']?['speed'] ?? 0).toDouble(),
      iconCode: (json['weather']?[0]?['icon'] ?? '') as String,
    );
  }

  String iconUrl() => 'https://openweathermap.org/img/wn/$iconCode@2x.png';
}
