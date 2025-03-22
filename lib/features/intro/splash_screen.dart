import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:food_lens/features/auth/screens/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FlutterSplashScreen.fadeIn(
        nextScreen: LoginScreen(),
        backgroundColor: Colors.white,
        duration: const Duration(milliseconds: 2000),
        onInit: () async {},
        onEnd: () async {
          debugPrint("onEnd 1");
        },
        childWidget: SizedBox(
          height: 400,
          width: 400,
          child: Image.asset('assets/image/logo1.png' , fit: BoxFit.cover,),
        ),
      ),
    );
  }
}
