import 'package:weather_app/controllers/index.dart';

class InsightsController extends GetxController {
  // Generate an insight based on weather data
  String generateInsight(GlobalController globalController) {
    double temp = globalController
            .getWeatherdata()
            .getCurrentWeather()
            .current
            .temp
            ?.toDouble() ??
        0;
    double humidity = globalController
            .getWeatherdata()
            .getCurrentWeather()
            .current
            .humidity
            ?.toDouble() ??
        0;
    double windSpeed = globalController
            .getWeatherdata()
            .getCurrentWeather()
            .current
            .windSpeed ??
        0;

    if (temp > 30) {
      return "It's hot outside! Stay hydrated and wear light clothing.";
    } else if (temp < 10) {
      return "It's cold! Wear warm clothes and stay cozy.";
    } else if (humidity > 80) {
      return "High humidity today! You might feel sticky outdoors.";
    } else if (windSpeed > 15) {
      return "It's windy! Hold onto your hat and avoid lightweight umbrellas.";
    }
    return "Perfect weather! Enjoy your day!";
  }
}
