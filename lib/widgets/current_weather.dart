import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/utils/custom_colors.dart';
import '../model/weather_data_current.dart';

// A widget that displays the current weather information
class CurrentWeather extends StatelessWidget {
  const CurrentWeather({super.key, required this.currentWeather});
  final WeatherDataCurrent currentWeather;

  @override
  Widget build(BuildContext context) {
    // Format the current date as a string
    DateTime localTime = DateTime.now()
        .toUtc()
        .add(Duration(seconds: currentWeather.timezoneOffset));
    String date = DateFormat("MMM dd, y  hh:mm a").format(localTime);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          date,
          style:
              const TextStyle(fontSize: 18, color: CustomColors.textColorBlack),
        ),
        // Display the temperature and weather icon
        temperatureWidget(),
        const SizedBox(
          height: 20,
        ),
        // Display additional weather details: wind speed, humidity, and cloud coverage
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CurrentWeatherCard(
              image: "assets/icons/windspeed.png",
              text: "${currentWeather.current.windSpeed}Km/h",
            ),
            CurrentWeatherCard(
              image: "assets/icons/clouds.png",
              text: "${currentWeather.current.clouds}%",
            ),
            CurrentWeatherCard(
              image: "assets/icons/humidity.png",
              text: "${currentWeather.current.humidity}%",
            ),
          ],
        ),
      ],
    );
  }

  // Widget to display the temperature and weather description
  Widget temperatureWidget() {
    // Ensure the weather list is not empty
    final weather = currentWeather.current.weather?.isNotEmpty == true
        ? currentWeather.current.weather![0]
        : null;
    final weatherIcon = weather?.icon ?? '01d';
    final weatherDescription = weather?.description ?? '';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Display the weather icon
        Image.asset("assets/weather/$weatherIcon.png"),
        // Vertical divider
        Container(
          height: 50,
          width: 2,
          color: CustomColors.dividerLine,
        ),
        // Display the temperature and weather description
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "${currentWeather.current.temp}°",
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 40,
                    color: CustomColors.textColorBlack),
              ),
              TextSpan(
                text: weatherDescription,
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: CustomColors.dividerLine),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// A widget that displays a weather detail card with an icon and text
class CurrentWeatherCard extends StatelessWidget {
  const CurrentWeatherCard(
      {super.key, required this.image, required this.text});

  final String image;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Container for the weather icon
        Container(
          height: 65,
          width: 65,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Image.asset(image),
        ),
        // Display the weather detail text
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
