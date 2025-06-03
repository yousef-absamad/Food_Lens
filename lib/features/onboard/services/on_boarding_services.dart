import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingServices {
  static late SharedPreferences sharedPref;

  static Future initializeSharedPrefrencesStorge() async {
    sharedPref = await SharedPreferences.getInstance();
  }

  static Future<bool> isFirstTime() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isFirstTime') ?? true;
}

static Future<void> setFirstTimeWithFalse() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isFirstTime', false);
}
}
