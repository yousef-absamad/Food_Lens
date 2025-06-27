import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_lens/launcher_screen.dart';
import 'package:food_lens/features/onboard/services/on_boarding_services.dart';
import 'package:food_lens/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await OnBoardingServices.initializeSharedPrefrencesStorge();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const FoodLensApp());
}


class FoodLensApp extends StatelessWidget {
  const FoodLensApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Lens',
      home: const LauncherScreen(),
    );
  }
}
