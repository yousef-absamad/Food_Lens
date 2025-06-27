import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_lens/features/auth/screens/login_screen.dart';
import 'package:food_lens/features/home/home.dart';
import 'package:food_lens/features/onboard/screens/onboard_screen.dart';
import 'package:food_lens/features/onboard/services/on_boarding_services.dart';

class LauncherScreen extends StatefulWidget {
  const LauncherScreen({super.key});

  @override
  State<LauncherScreen> createState() => _LauncherScreenState();
}

class _LauncherScreenState extends State<LauncherScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndNavigate();
    });
  }

 Future<void> _checkAndNavigate() async {
  final isFirstTime = await OnBoardingServices.isFirstTime();
  
  if (!mounted) return;

  if (isFirstTime) {
    OnBoardingServices.setFirstTimeWithFalse();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OnboardScreens()),
    );
  } else {
    final user = FirebaseAuth.instance.currentUser;
    if (!mounted) return;

    if (user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Home()),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
