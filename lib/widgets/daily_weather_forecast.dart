import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/controllers/global_controller.dart';
import 'package:weather_app/model/weather_data_daily.dart';
import 'package:weather_app/utils/custom_colors.dart';

// A widget that displays the daily weather forecast
class DailyWeatherForecast extends StatelessWidget {
  const DailyWeatherForecast({super.key, required this.dailyData});
  final WeatherDataDaily dailyData;

  // Helper method to format the date
  String dateFormat(day) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(day * 1000);
    String formatedDate = DateFormat.E().format(time);
    return formatedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Title for the upcoming weather forecast section
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(bottom: 10),
          child: const Text(
            "7-Day Forecast",
            style: TextStyle(
                color: CustomColors.textColorBlack,
                fontSize: 18,
                fontWeight: FontWeight.w500),
          ),
        ),
        // Display the list of daily weather forecasts
        dailyList()
      ],
    );
  }

  // Widget to build the list of daily weather forecasts
  Widget dailyList() {
    final GlobalController controller =Get.find<GlobalController>();
    RxInt cardIndex = controller.getIndex();
    return Container(
      height: 600,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12)),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(), 
        itemCount: dailyData.daily.length, 
        itemBuilder: (context, index) {
          return Obx(
            () => GestureDetector(
              onTap: () {
                cardIndex.value = index; // Update selected card index
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                     // Highlight selected card with gradient
                    gradient: cardIndex.value == index
                        ? const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                                CustomColors.firstGradientColor,
                                CustomColors.secondGradientColor,
                              ])
                        : null),
                        
                child: ListTile(
                  leading: Text(
                    index == 0
                        ? "Today"
                        : dateFormat(dailyData.daily[index].dt), // Format date
                    style: const TextStyle(
                        color: CustomColors.textColorBlack, fontSize: 16),
                  ),
                  title: Image.asset(
                    "assets/weather/${dailyData.daily[index].weather![0].icon}.png",
                    height: 40,
                    width: 40,
                  ),
                  subtitle: Center(
                    child: Text(dailyData.daily[index].weather![0].description!,
                        style: const TextStyle(
                            color: CustomColors.textColorBlack, fontSize: 12)),
                  ),
                  trailing: Text(
                    "${dailyData.daily[index].temp!.max}°/${dailyData.daily[index].temp!.min}°", // Display max/min temperature
                    style: const TextStyle(
                        color: CustomColors.textColorBlack, fontSize: 14),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
