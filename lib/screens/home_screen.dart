import 'package:flutter/material.dart';
import '../services/weather_api_service.dart';
import '../models/weather_model.dart';
import '../widgets/weather_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController = TextEditingController();
  final WeatherApiService _weatherApiService = WeatherApiService();
  Weather? _weather;
  bool _isLoading = false;
  String? _error;

  void _fetchWeather() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final weatherData =
          await _weatherApiService.fetchWeather(_cityController.text);
      setState(() {
        _weather = Weather.fromJson(weatherData);
      });
    } catch (e) {
      setState(() {
        _error = 'Could not fetch weather data.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Forecast'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                hintText: 'Enter city name',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _fetchWeather,
                ),
              ),
            ),
            if (_isLoading) CircularProgressIndicator(),
            if (_error != null)
              Text(_error!, style: TextStyle(color: Colors.red)),
            if (_weather != null) WeatherCard(weather: _weather!),
          ],
        ),
      ),
    );
  }
}
