import 'dart:convert';

import 'package:http/http.dart';
import 'package:weather_app_join_to_it/constants/constants.dart';
import 'package:weather_app_join_to_it/models/weather_model.dart';

class WeatherApi {
  Future<WeatherModel> getWeatherData(String searchParams) async {
    String url = '$baseUrl&q=$searchParams&days=7';

    try {
      Response response = await get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        WeatherModel weatherModel = WeatherModel.fromJson(json);
        return weatherModel;
      } else {
        throw ('No data found');
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
