import 'package:weather_app/controllers/index.dart';

class GlobalController extends GetxController {
  // Observables for tracking loading state, latitude, and longitude
  final RxBool _isLoading = true.obs;
  final RxDouble _latitude = 0.0.obs;
  final RxDouble _longitude = 0.0.obs;

  StreamSubscription? _internetSubscription;

  // Observables for tracking city, subLocality and index
  final RxString city = "".obs;
  final RxString subLocality = "".obs;
  final RxInt _currentIndex = 0.obs;

  // Getters for accessing observables
  RxBool checkLoading() => _isLoading;
  RxDouble getLatitude() => _latitude;
  RxDouble getLongitude() => _longitude;
  RxInt getIndex() => _currentIndex;
  // Observable for storing weather data
  final weatherData = WeatherData().obs;

  // Getter for accessing weather data
  WeatherData getWeatherdata() => weatherData.value;

  @override
  void onInit() {
    _isLoading.isTrue ? checkConnectionAndFetchData() : getIndex();
    super.onInit();
  }

  // Method to check internet connection and fetch data
  Future<void> checkConnectionAndFetchData() async {
    try {
      _internetSubscription =
          InternetConnection().onStatusChange.listen((event) async {
        if (event == InternetStatus.connected) {
          try {
            // Fetch location and weather data
            await getLocation();
          } catch (e) {
            // Show error snackbar if fetching data fails
            showErrorSnackbar('Error: $e');
          }
        } else if (event == InternetStatus.disconnected) {
          showErrorSnackbar('No internet connection');
        }
      });
    } catch (e) {
      showErrorSnackbar('Error');
    }
  }

  // Method to show error snackbar
  void showErrorSnackbar(String message) {
    Get.snackbar('Error', message,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3));
  }

  // Method to get address from latitude and longitude
  getAddress(double lat, double lon) async {
    List<Placemark> placemark = await placemarkFromCoordinates(lat, lon);
    Placemark place = placemark[0];
    city.value = place.locality ?? place.street ?? '';
    subLocality.value = place.thoroughfare ?? "";
  }

  // Method to get current location and weather data
  getLocation() async {
    // Check if location services are enabled
    bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      // Show error snackbar if location services are disabled
      showErrorSnackbar('Location services are disabled.');
      return;
    }

    // Check location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Show error snackbar if location permissions are denied
        showErrorSnackbar('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Show error snackbar if location permissions are permanently denied
      showErrorSnackbar('Location permissions are permanently denied.');
      return;
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition();
    _latitude.value = position.latitude;
    _longitude.value = position.longitude;

    // Get address from latitude and longitude
    getAddress(_latitude.value, _longitude.value);

    try {
      // Fetch weather data
      WeatherData data =
          await WeatherRepo().getWeather(position.latitude, position.longitude);
      weatherData.value = data;
      _isLoading.value = false; // Set loading state to false
    } catch (e) {
      // Show error snackbar if fetching weather data fails
      showErrorSnackbar('Failed to fetch weather');
    }
  }

  Future<void> getWeatherBySearch(String location) async {
    if (location.isEmpty) {
      showErrorSnackbar('Location cannot be empty.');
      return;
    }

    try {
      _isLoading.value = true;
      // Convert location name to latitude and longitude
      List<Location> locations = await locationFromAddress(location);
      if (locations.isNotEmpty) {
        _latitude.value = locations[0].latitude;
        _longitude.value = locations[0].longitude;

        // Fetch weather data
        WeatherData data = await WeatherRepo().getWeather(
          _latitude.value,
          _longitude.value,
        );

        // Update state with new data
        weatherData.value = data;
        await getAddress(_latitude.value, _longitude.value); // Update city name
        _isLoading.value = false;
      } else {
        showErrorSnackbar("Couldn't find location.");
      }
    } catch (e) {
      showErrorSnackbar("Failed to fetch weather for '$location'.");
    }
  }

  @override
  void onClose() {
    _internetSubscription?.cancel();
    super.onClose();
  }
}
