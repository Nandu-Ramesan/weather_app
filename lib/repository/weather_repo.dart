import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/model/weather_data.dart';
import 'package:weather_app/model/weather_data_current.dart';
import 'package:weather_app/model/weather_data_daily.dart';
import 'package:weather_app/model/weather_data_hourly.dart';
import 'package:weather_app/repository/api_key.dart';

class WeatherRepo {
  WeatherData? weatherData;

  Future<WeatherData> getWeather(lat, lon) async {
    final url = apiUrl(lat, lon);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      weatherData = WeatherData(WeatherDataCurrent.fromJson(data),
          WeatherDataHourly.fromJson(data), WeatherDataDaily.fromJson(data));
      return weatherData!;
    } else {
      throw Exception("error with status code: ${response.statusCode}");
    }
  }

  Uri apiUrl(lat, lon) {
    final url = Uri.parse(
        "https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon&exclude=minutely&units=metric&appid=$apikey");

    return url;
  }
}
