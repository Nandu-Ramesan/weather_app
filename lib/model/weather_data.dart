import 'weather_data_current.dart';
import 'weather_data_daily.dart';
import 'weather_data_hourly.dart';

class WeatherData {
  final WeatherDataCurrent? current;
  final WeatherDataHourly? hourly;
  final WeatherDataDaily? daily;

  WeatherData([this.current, this.hourly, this.daily]);

  // function to fetch these values
  WeatherDataCurrent getCurrentWeather() =>
      current ?? WeatherDataCurrent(current: Current(), timezoneOffset: 0);
  WeatherDataHourly getHourlyWeather() =>
      hourly ?? WeatherDataHourly(hourly: []);
  WeatherDataDaily getDailyWeather() => daily ?? WeatherDataDaily(daily: []);
}
