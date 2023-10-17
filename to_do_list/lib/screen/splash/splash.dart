import 'package:flutter/material.dart';
import 'package:to_do_list/screen/home/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    Future.delayed(const Duration(seconds: 2)).then((value) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) {
            return  HomeScreen();
          },
        ),
      );
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset('assets/image/splash.png' , fit: BoxFit.cover,) ,), 
           Center(
          child:Image.asset('assets/image/sda.png' , height: 400,width: 400, )
        ),
        ],
      ),
    );
  }
}
