import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/utils/custom_colors.dart';
import '../model/weather_data_daily.dart';

// A widget that displays the sunrise and sunset times for the sun and moon
class SunMoonTimes extends StatelessWidget {
  const SunMoonTimes({super.key, required this.dailyData});

  final WeatherDataDaily dailyData;

  // Helper method to format the time from a timestamp
  String getFormattedTime(int formatData) {
    DateTime data = DateTime.fromMillisecondsSinceEpoch(
      formatData * 1000,
    );
    return DateFormat.jm().format(data);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          // Widget for displaying sun times (sunrise and sunset)
          riseSetWidget(
            label: "Sun",
            iconPath: "assets/icons/sun.png",
            riseTime: dailyData.daily.first.sunrise,
            setTime: dailyData.daily.first.sunset,
          ),
          const SizedBox(
            height: 20,
          ),
          // Widget for displaying moon times (moonrise and moonset)
          riseSetWidget(
            label: "Moon",
            iconPath: "assets/icons/imoon.png",
            riseTime: dailyData.daily.first.moonrise,
            setTime: dailyData.daily.first.moonset,
          ),
        ],
      ),
    );
  }

  // Widget to display rise and set times with an icon
  Widget riseSetWidget({
    required String label,
    required int? riseTime,
    required int? setTime,
    required String iconPath,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Display rise time with label
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "$label Rise\n",
                style: const TextStyle(color: CustomColors.dividerLine),
              ),
              TextSpan(
                text: getFormattedTime(riseTime!),
                style: const TextStyle(
                  color: CustomColors.textColorBlack,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        // Display icon
        Image.asset(
          iconPath,
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
        // Display set time with label
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "$label Set\n",
                style: const TextStyle(color: CustomColors.dividerLine),
              ),
              TextSpan(
                text: getFormattedTime(setTime!),
                style: const TextStyle(
                  color: CustomColors.textColorBlack,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
