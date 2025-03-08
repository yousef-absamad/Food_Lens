import 'package:flutter/material.dart';
import 'package:food_lens/features/home/screens/home_screen.dart';
import 'package:food_lens/intro/splash_screen.dart';

import 'features/home/home.dart';

void main(){
  runApp(FoosLensApp());
}

class FoosLensApp extends StatelessWidget {
  const FoosLensApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Lens',
      home: SplashScreen(),
      //home: HomeScreen(),
      //home: Home(),
    );
  }
}