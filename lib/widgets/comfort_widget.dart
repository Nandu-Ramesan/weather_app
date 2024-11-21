import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:weather_app/utils/custom_colors.dart';
import '../model/weather_data_current.dart';

// A widget that displays the comfort level, including humidity, feels-like temperature, and UV index
class ComfortLevel extends StatelessWidget {
  const ComfortLevel({super.key, required this.currentWeather});
  final WeatherDataCurrent currentWeather;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Title for the comfort level section
        const Text(
          "Comfort Level",
          style: TextStyle(fontSize: 18),
        ),
        // Container for the SleekCircularSlider
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: SleekCircularSlider(
            min: 0.0,
            max: 100,
            initialValue: currentWeather.current.humidity?.toDouble()??0,
            appearance: CircularSliderAppearance(
              infoProperties: InfoProperties(
                bottomLabelText: "Humidity",
                bottomLabelStyle: const TextStyle(
                  fontSize: 16,
                ),
              ),
              customWidths: CustomSliderWidths(
                trackWidth: 20,
                handlerSize: 0,
                progressBarWidth: 20,
              ),
              size: 160,
              customColors: CustomSliderColors(
                hideShadow: true,
                trackColor: Colors.grey.shade300,
                progressBarColors: [
                  CustomColors.firstGradientColor,
                  CustomColors.secondGradientColor,
                ],
              ),
            ),
          ),
        ),
        // Row displaying "Feels like" temperature and UV index
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Display the "Feels like" temperature
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Feels like ',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: "${currentWeather.current.feelsLike!.round()}°",
                    style: const TextStyle(
                      fontSize: 16,
                      color: CustomColors.textColorBlack,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            // Divider between "Feels like" and "UV index"
            Container(
              height: 30,
              width: 2,
              color: CustomColors.dividerLine,
            ),
            // Display the UV index
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'UV index ',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: "${currentWeather.current.uvIndex!.round()}°",
                    style: const TextStyle(
                      fontSize: 16,
                      color: CustomColors.textColorBlack,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
