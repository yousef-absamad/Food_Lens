import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthMethod {
  Future<User?> authenticate();
}
