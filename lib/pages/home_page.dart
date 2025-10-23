import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';
import '../widgets/weather_card.dart';

enum SearchMode { cityCountry, zipCountry, coords }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherService _service = WeatherService();

  SearchMode _mode = SearchMode.cityCountry;
  TempUnit _unit = TempUnit.celsius;

  // ✅ Controllers สำหรับแต่ละโหมด
  final _cityCtrl = TextEditingController(text: 'Bangkok');
  String _countryCity = 'TH';

  final _zipCtrl = TextEditingController(text: '10001');
  String _countryZip = 'US';

  final _latCtrl = TextEditingController(text: '13.7563');
  final _lonCtrl = TextEditingController(text: '100.5018');

  Weather? _result;
  String? _error;

  String get unitLabel {
    switch (_unit) {
      case TempUnit.celsius:
        return '°C';
      case TempUnit.fahrenheit:
        return '°F';
      case TempUnit.kelvin:
        return 'K';
    }
  }

  final List<Map<String, String>> _countries = const [
    {'code': 'TH', 'name': 'Thailand'},
    {'code': 'US', 'name': 'United States'},
    {'code': 'GB', 'name': 'United Kingdom'},
    {'code': 'JP', 'name': 'Japan'},
    {'code': 'FR', 'name': 'France'},
  ];

  Future<void> _submit() async {
    setState(() {
      _error = null;
      _result = null;
    });

    try {
      Weather w;
      if (_mode == SearchMode.cityCountry) {
        w = await _service.getByCityCountry(
          city: _cityCtrl.text.trim(),
          countryCode: _countryCity,
          unit: _unit,
        );
      } else if (_mode == SearchMode.zipCountry) {
        w = await _service.getByZipCountry(
          zip: _zipCtrl.text.trim(),
          countryCode: _countryZip,
          unit: _unit,
        );
      } else {
        w = await _service.getByCoords(
          lat: double.parse(_latCtrl.text),
          lon: double.parse(_lonCtrl.text),
          unit: _unit,
        );
      }

      setState(() => _result = w);
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  Widget _buildForm() {
    switch (_mode) {
      case SearchMode.cityCountry:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _cityCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration(
                'City (e.g., Bangkok, Tokyo)',
                Icons.location_city,
              ),
            ),
            const SizedBox(height: 12),
            _countryDropdown(
              label: "Country",
              value: _countryCity,
              onChanged: (v) => setState(() => _countryCity = v!),
            ),
          ],
        );

      case SearchMode.zipCountry:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _zipCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration(
                'ZIP Code (e.g., 10001)',
                Icons.local_post_office,
              ),
            ),
            const SizedBox(height: 12),
            _countryDropdown(
              label: "Country",
              value: _countryZip,
              onChanged: (v) => setState(() => _countryZip = v!),
            ),
          ],
        );

      case SearchMode.coords:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _latCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration(
                'Latitude (e.g., 13.7563)',
                Icons.my_location,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _lonCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration(
                'Longitude (e.g., 100.5018)',
                Icons.my_location,
              ),
            ),
          ],
        );
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      prefixIcon: Icon(icon, color: Colors.white70),
    );
  }

  Widget _countryDropdown({
    required String label,
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: Colors.black87,
          iconEnabledColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          onChanged: onChanged,
          items: _countries.map((c) {
            return DropdownMenuItem<String>(
              value: c['code'],
              child: Text('${c['name']} (${c['code']})'),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String text,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: selected
            ? Colors.lightBlueAccent.withOpacity(0.2)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: selected ? Colors.lightBlueAccent : Colors.white70,
        ),
        title: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white : Colors.white70,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      // 🔹 AppBar ใหม่ ใช้โทนเดียวกับ Drawer
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0B132B), // Navy Blue
                Color(0xFF1C2541), // Deep Indigo
                Color(0xFF3A506B), // Steel Blue
              ],
            ),
          ),
        ),
        title: const Text(
          'Weather App',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0B132B), // น้ำเงินเข้ม
                Color(0xFF1C2541), // ฟ้าอมม่วง
                Color(0xFF3A506B), // ฟ้าเทา
              ],
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // 🔹 Header
              DrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1D2D50), Color(0xFF133B5C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud,
                      color: Colors.lightBlueAccent.shade100,
                      size: 60,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Weather Menu',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),

              // 🔹 เมนู 1: City + Country
              _drawerItem(
                icon: Icons.location_city,
                text: 'City + Country',
                selected: _mode == SearchMode.cityCountry,
                onTap: () {
                  setState(() => _mode = SearchMode.cityCountry);
                  Navigator.pop(context);
                },
              ),

              // 🔹 เมนู 2: ZIP + Country
              _drawerItem(
                icon: Icons.local_post_office,
                text: 'ZIP + Country',
                selected: _mode == SearchMode.zipCountry,
                onTap: () {
                  setState(() => _mode = SearchMode.zipCountry);
                  Navigator.pop(context);
                },
              ),

              // 🔹 เมนู 3: Latitude + Longitude
              _drawerItem(
                icon: Icons.my_location,
                text: 'Latitude + Longitude',
                selected: _mode == SearchMode.coords,
                onTap: () {
                  setState(() => _mode = SearchMode.coords);
                  Navigator.pop(context);
                },
              ),

              const Divider(color: Colors.white24, indent: 16, endIndent: 16),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Lottie.asset(
              'assets/lottie/background_shooting_star.json',
              fit: BoxFit.cover,
              repeat: true,
              animate: true,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Search Weather 🌤',
                    style: GoogleFonts.prompt(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildForm(),
                  const SizedBox(height: 20),

                  // 🔹 Row: Temperature Unit + Get Weather Button
                  SizedBox(
                    height: 56, // ✅ กำหนดความสูงเท่ากันทั้งสองปุ่ม
                    child: Row(
                      children: [
                        // 🔸 ซ้าย: Dropdown หน่วยอุณหภูมิ
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<TempUnit>(
                                value: _unit,
                                isExpanded: true,
                                dropdownColor: Colors.black87,
                                iconEnabledColor: Colors.white,
                                style: const TextStyle(color: Colors.white),
                                onChanged: (v) => setState(() => _unit = v!),
                                items: const [
                                  DropdownMenuItem(
                                    value: TempUnit.celsius,
                                    child: Text('Celsius (°C)'),
                                  ),
                                  DropdownMenuItem(
                                    value: TempUnit.fahrenheit,
                                    child: Text('Fahrenheit (°F)'),
                                  ),
                                  DropdownMenuItem(
                                    value: TempUnit.kelvin,
                                    child: Text('Kelvin (K)'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // 🔸 ขวา: ปุ่ม Get Weather
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: double.infinity,
                            child: ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets
                                    .zero, // ปรับให้ gradient เต็มพื้นที่
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 3,
                              ),
                              child: Ink(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF1D2D50), // น้ำเงินเข้ม
                                      Color(0xFF133B5C), // ฟ้าอมม่วง
                                      Color(0xFF3A506B), // steel blue
                                    ],
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(16),
                                  ),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.search,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'Get Weather',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                  if (_error != null)
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  if (_result != null)
                    WeatherCard(weather: _result!, unitLabel: unitLabel),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
