import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';
import 'package:intl/intl.dart';
import 'package:weather_app_join_to_it/models/weather_model.dart';

class CurrentWeatherWidget extends StatelessWidget {
  final WeatherModel? weatherModel;
  const CurrentWeatherWidget({Key? key, this.weatherModel}) : super(key: key);

  WeatherType getWeatherType(Current? current) {
    if (current?.isDay == 1) {
      if (current?.condition?.text == "Sunny") {
        return WeatherType.sunny;
      } else if (current?.condition?.text == "Patchy rain nearby") {
        return WeatherType.lightRainy;
      } else if (current?.condition?.text == "Overcast") {
        return WeatherType.overcast;
      } else if (current?.condition?.text == "Partly Cloudy" || current?.condition?.text == "Cloudy") {
        return WeatherType.cloudy;
      } else if (current?.condition?.text == "Mist") {
        return WeatherType.lightSnow;
      } else if (current?.condition?.text == "Thunder") {
        return WeatherType.thunder;
      } else if (current!.condition!.text!.contains("rain")) {
        return WeatherType.heavyRainy;
      } else if (current.condition!.text!.contains("snow")) {
        return WeatherType.heavySnow;
      } else if (current.condition?.text == "Clear") {
        return WeatherType.sunny;
      } else if (current.condition!.text!.contains("fog")) {
        return WeatherType.foggy;
      }
    }

    return WeatherType.cloudyNight;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WeatherBg(
          weatherType: getWeatherType(weatherModel?.current),
          width: MediaQuery.of(context).size.width,
          height: 300,
        ),
        SizedBox(
            height: 300,
            width: double.infinity,
            child: Column(
              children: [
                Text(
                  weatherModel?.location?.name ?? '',
                  style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Text(
                  DateFormat.yMMMMEEEEd().format(DateTime.parse(weatherModel?.current?.lastUpdated ?? '')),
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white24,
                        ),
                        child: Image.network('https:${weatherModel?.current?.condition?.icon ?? ''}')),
                    Text(
                      "${weatherModel?.current?.tempC?.round().toString() ?? ''}℃",
                      style: TextStyle(
                          color: weatherModel!.current!.tempC!.round() <= 0 ? Colors.blue : Colors.red, fontSize: 75, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white30,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text(
                              'Feels like',
                              style: TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${weatherModel?.current?.feelslikeC?.round().toString() ?? ''} ℃",
                              style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              'Wind',
                              style: TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${weatherModel?.current?.windKph?.round().toString() ?? ''} km/h",
                              style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.normal),
                            ),
                          ],
                        )
                      ],
                    ))
              ],
            ))
      ],
    );
  }
}
