import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:weather_app_join_to_it/constants/constants.dart';
import 'package:weather_app_join_to_it/screens/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

@override
  void initState() {
    
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(const Duration(seconds: 3),(){
      Get.off(()=>const HomePage());
    });
  }

@override
  void dispose() {
   SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blue, Colors.yellow],
          begin:Alignment.topLeft,
          end:Alignment.bottomRight),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          
          children: [
          
          Image.network(splashImage),
          const SizedBox(height: 50,),
          Text('Welcome to Weather App',style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold))
        ],),
      ),
    );
  }
}