import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/controllers/global_controller.dart';
import 'package:weather_app/model/weather_data_hourly.dart';
import 'package:weather_app/utils/custom_colors.dart';

// A widget that displays the hourly weather forecast
class HourlyWeather extends StatelessWidget {
  const HourlyWeather({super.key, required this.hourData});
  final WeatherDataHourly hourData;

  @override
  Widget build(BuildContext context) {
    RxInt cardIndex = GlobalController().getIndex(); // Get the selected card index from the global controller
    return Column(
      children: [
        // Title for the hourly weather section
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          alignment: Alignment.topCenter,
          child: const Text(
            "Today",
            style: TextStyle(fontSize: 18),
          ),
        ),
        // Horizontal list view to display hourly weather cards
        SizedBox(
          height: 135,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: hourData.hourly.length > 13 ? 13 : hourData.hourly.length, // Limit to 13 items
            itemBuilder: (context, index) {
              final data = hourData.hourly[index];
              return GestureDetector(
                onTap: () {
                  cardIndex.value = index; // Update selected card index on tap
                },
                child: Obx(
                  () => Container(
                    width: 90,
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: cardIndex.value != index
                          ? CustomColors.cardColor
                          : null,
                      gradient: cardIndex.value == index
                          ? const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                  CustomColors.firstGradientColor,
                                  CustomColors.secondGradientColor,
                                ])
                          : null, // Highlight selected card with gradient
                    ),
                    // Display hourly weather details
                    child: HourlyDetails(
                      currenCardIndex: cardIndex.value,
                      index: index,
                      temp: data.temp ?? 0,
                      timeStamp: data.dt??0,
                      weatherIcon: data.weather![0].icon!,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// A widget that displays the details of an hourly weather card
class HourlyDetails extends StatelessWidget {
  const HourlyDetails({
    super.key,
    required this.timeStamp,
    required this.temp,
    required this.weatherIcon,
    required this.currenCardIndex,
    required this.index
  });

  final int temp;
  final int timeStamp;
  final String weatherIcon;
  final int currenCardIndex;
  final int index;

  // Helper method to format the time from a timestamp
  String formatTime(timeStamp) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    String formattedTime = DateFormat('jm').format(time);
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Display the formatted time
        Text(
          formatTime(timeStamp),
          style: TextStyle(
              fontSize: 12,
              color: currenCardIndex == index ? Colors.white : Colors.black),
        ),
        // Display the weather icon
        Image.asset("assets/weather/$weatherIcon.png"),
        // Display the temperature
        Text("$temp°"),
      ],
    );
  }
}
