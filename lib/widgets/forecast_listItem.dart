import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app_join_to_it/models/weather_model.dart';

class ForecastListItem extends StatelessWidget {
  final Forecastday? forecastday;
  const ForecastListItem({Key? key, this.forecastday}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.green[100],
        ),
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.network('https:${forecastday?.day?.condition?.icon ?? ''}'),
            Expanded(child: Text(DateFormat.MMMEd().format(DateTime.parse(forecastday?.date ?? '')))),
            Expanded(child: Text(forecastday?.day?.condition?.text ?? '')),
            Expanded(
                child: Text('${forecastday?.day?.mintempC?.round().toString() ?? ''}°C/${forecastday?.day?.maxtempC?.round().toString() ?? ''}°C')),
          ],
        ),
      ),
    );
  }
}
