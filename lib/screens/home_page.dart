import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather_app_join_to_it/models/weather_model.dart';
import 'package:weather_app_join_to_it/screens/weather_search_page.dart';
import 'package:weather_app_join_to_it/service/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  WeatherApi weatherApi = WeatherApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: const Text('Map', style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Stack(children: [
            SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GoogleMap(
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(48.383022, 31.1828699),
                      zoom: 5,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      setState(() {});
                    },
                    tiltGesturesEnabled: false,
                    onLongPress: (latlang) {
                      setState(() {});
                      _addMarkerLongPressed(latlang);
                    },
                    markers: Set<Marker>.of(markers.values),
                  ),
                ))
          ]),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                  child: FilledButton(
                      onPressed: () {
                        markers.clear();
                        setState(() {});
                      },
                      child: const Text('MAP'))),
              const SizedBox(width: 10),
              Expanded(
                  child: FilledButton(
                      onPressed: () {
                        Get.off(() => const WeatherPage());
                      },
                      child: const Text('WEATHER'))),
            ],
          ),
        ));
  }

  Future _addMarkerLongPressed(LatLng latlang) async {
    WeatherModel response = await weatherApi.getWeatherData('${latlang.latitude},${latlang.longitude}');

    setState(() {
      final MarkerId markerId = MarkerId("RANDOM_ID");
      Marker marker = Marker(
        markerId: markerId,
        draggable: true,
        position: latlang,
        infoWindow: InfoWindow(
          onTap: () => Get.off(() => WeatherPage(
                weatherModel: response,
              )),
          title: '${response.location!.name}, ${response.location!.country}',
          snippet: "Current temp. ${response.current!.tempC!.round().toString()}°C",
        ),
        icon: BitmapDescriptor.defaultMarker,
      );

      markers[markerId] = marker;
    });
  }
}
