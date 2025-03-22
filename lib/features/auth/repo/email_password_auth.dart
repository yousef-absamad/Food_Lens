import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_lens/features/auth/repo/auth_method.dart';

class EmailPasswordAuth implements AuthMethod {
  final String email;
  final String password;
  final bool isSignUp;

  EmailPasswordAuth({
    required this.isSignUp,
    required this.email,
    required this.password,
  });

  @override
  Future<void> authenticate() async {
    if (isSignUp) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } else {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    }
  }
}
