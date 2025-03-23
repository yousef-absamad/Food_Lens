import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_lens/features/auth/emailVerification/views/email_verification_screen.dart';
import 'package:food_lens/features/auth/screens/login_screen.dart';
import 'package:food_lens/features/home/screens/home_screen.dart';
import 'package:food_lens/firebase_options.dart';
import 'package:food_lens/features/intro/splash_screen.dart';

import 'features/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const FoodLensApp());
}

class FoodLensApp extends StatefulWidget {
  const FoodLensApp({super.key});

  @override
  State<FoodLensApp> createState() => _FoodLensAppState();
}

class _FoodLensAppState extends State<FoodLensApp> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.idTokenChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Lens',
      home: SplashScreen(),
      //home: LoginScreen(),
      //home: EmailVerificationScreen(),
    );
  }
}