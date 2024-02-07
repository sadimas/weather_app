import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app_join_to_it/models/weather_model.dart';
import 'package:weather_app_join_to_it/screens/home_page.dart';
import 'package:weather_app_join_to_it/service/api_service.dart';
import 'package:weather_app_join_to_it/widgets/current_weather_widget.dart';
import 'package:weather_app_join_to_it/widgets/forecast_listItem.dart';

class WeatherPage extends StatefulWidget {
  final String? city;
  final WeatherModel? weatherModel;
  const WeatherPage({Key? key, this.city, this.weatherModel}) : super(key: key);

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  WeatherApi weatherApi = WeatherApi();
  TextEditingController textController = TextEditingController();
  String searchText = '';

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          backgroundColor: Colors.blueGrey,
          appBar: AppBar(
            backgroundColor: Colors.blueGrey,
            title: const Text('Weather', style: TextStyle(color: Colors.white)),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextField(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              floatingLabelStyle: TextStyle(color: Colors.white, fontSize: 12),
                              labelText: 'Enter city',
                              labelStyle: TextStyle(fontSize: 16),
                            ),
                            keyboardType: TextInputType.text,
                            maxLines: 1,
                            controller: textController,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                        color: Colors.white,
                        onPressed: () async {
                          if (textController.text.isEmpty) {
                            var snackBar = const SnackBar(backgroundColor: Colors.red, content: Center(child: Text('Please, enter city!')));

                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            setState(() {});
                          } else {
                            String searchCity = textController.text.trim();
                            await weatherApi.getWeatherData(searchCity);
                            setState(() {
                              searchText = searchCity;
                            });
                            textController.clear();
                            FocusManager.instance.primaryFocus?.unfocus();
                          }
                        },
                        icon: const Icon(Icons.search))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                FutureBuilder(
                    future: weatherApi.getWeatherData(searchText),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        WeatherModel? cityWeatherModel = snapshot.data;
                        return CurrentWeatherWidget(
                          weatherModel: cityWeatherModel,
                        );
                      }
                      if (snapshot.hasError && widget.weatherModel?.current != null) {
                        return CurrentWeatherWidget(
                          weatherModel: widget.weatherModel,
                        );
                      }
                      return const SizedBox();
                    }),
                Expanded(
                    child: FutureBuilder(
                        future: weatherApi.getWeatherData(searchText),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            WeatherModel? cityWeatherModel = snapshot.data;
                            return Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'Weather next 7 days',
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      Forecastday? cityForecastday = cityWeatherModel?.forecast?.forecastday?[index];

                                      return ForecastListItem(
                                        forecastday: cityForecastday,
                                      );
                                    },
                                    itemCount: cityWeatherModel?.forecast?.forecastday?.length,
                                  ),
                                ),
                              ],
                            );
                          }
                          if (snapshot.hasError && widget.weatherModel?.forecast?.forecastday != null) {
                            return Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'Weather next 7 days',
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      Forecastday? forecastday = widget.weatherModel?.forecast?.forecastday?[index];

                                      return ForecastListItem(
                                        forecastday: forecastday,
                                      );
                                    },
                                    itemCount: widget.weatherModel?.forecast?.forecastday?.length,
                                  ),
                                ),
                              ],
                            );
                          }
                          return const Center(
                            child: Text(
                              'Please, choose a City for getting weather',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        })),
              ]),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                    child: FilledButton(
                        onPressed: () {
                          Get.off(() => const HomePage());
                        },
                        child: const Text('MAP'))),
                const SizedBox(width: 10),
                Expanded(
                    child: FilledButton(
                        onPressed: () async {
                          if (textController.text.isEmpty) {
                            var snackBar = const SnackBar(backgroundColor: Colors.red, content: Center(child: Center(child: Text('Please, enter city!'))));

                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          } else {
                            String searchCity = textController.text.trim();
                            await weatherApi.getWeatherData(searchCity);
                            setState(() {
                              searchText = searchCity;
                            });
                            textController.clear();
                            FocusManager.instance.primaryFocus?.unfocus();
                          }
                        },
                        child: const Text('SEARCH'))),
              ],
            ),
          )),
    );
  }
}
