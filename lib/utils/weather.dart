import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:location/location.dart';

const apiKey = '3a65c87004a68507506402ea1bec8b6d';
const openWeatherMapURL = 'https://api.openweathermap.org/data/2.5/weather';

class Weather {
  Future<dynamic> getWeatherFromLocation(LocationData location) async {
    HttpUtility networkHelper = HttpUtility(
        '$openWeatherMapURL?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric');

    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return 'thunder';
    } else if (condition < 400) {
      return 'drizzle';
    } else if (condition == 500) {
      return 'rain';
    } else if (condition < 600) {
      return 'heavy_rain';
    } else if (condition < 700) {
      return 'snow';
    } else if (condition < 800) {
      return 'fog';
    } else if (condition == 800) {
      return 'sun';
    } else if (condition <= 804) {
      return 'cloud';
    } else {
      return 'thermometer';
    }
  }
}

class HttpUtility {
  HttpUtility(this.weatherUrl);

  final String weatherUrl;

  Future getData() async {
    http.Response response = await http.get(Uri.parse(weatherUrl));

    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
}
