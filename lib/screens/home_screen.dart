import 'package:weather_app/screens/index.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalController globalController = Get.put(GlobalController());
    final InsightsController insightsController = Get.put(InsightsController());
    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Obx(
          () => Text(
            globalController.city.value,
            style: const TextStyle(fontSize: 28, color: Colors.black),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Search Location"),
                  content: TextField(
                    controller: searchController,
                    decoration:
                        const InputDecoration(hintText: "Enter city name"),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        globalController.getWeatherBySearch(
                          searchController.text.trim(),
                        );
                        searchController.clear();

                        Navigator.pop(context);
                      },
                      child: const Text("Search"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Obx(() => globalController.checkLoading().isTrue
            ? Center(
                child: Image.asset("assets/icons/clouds.png"),
              ) // Display loading indicator when data is loading
            : RefreshIndicator(
                // Implement pull-to-refresh functionality
                onRefresh: () => globalController.getLocation(),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    WeatherInsights(
                        insight: insightsController
                            .generateInsight(globalController)),
                    const SizedBox(height: 20),
                    // Display current weather widget
                    CurrentWeather(
                      currentWeather:
                          globalController.getWeatherdata().getCurrentWeather(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // Display hourly weather widget
                    HourlyWeather(
                      hourData:
                          globalController.getWeatherdata().getHourlyWeather(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // Display daily weather forecast widget
                    DailyWeatherForecast(
                      dailyData:
                          globalController.getWeatherdata().getDailyWeather(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // Display sun and moon times widget
                    SunMoonTimes(
                      dailyData:
                          globalController.getWeatherdata().getDailyWeather(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // Display comfort level widget
                    ComfortLevel(
                      currentWeather:
                          globalController.getWeatherdata().getCurrentWeather(),
                    ),
                  ],
                ),
              )),
      ),
    );
  }
}
