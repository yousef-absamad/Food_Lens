import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_lens/features/auth/repo/auth_method.dart';

class EmailPasswordAuth implements AuthMethod {
  final String email;
  final String password;
  final String fullName;
  final bool isSignUp;

  EmailPasswordAuth({
    required this.isSignUp,
    required this.email,
    required this.password,
    required this.fullName,
  });

  @override
  Future<User?> authenticate() async {
    UserCredential userCredential;

    if (isSignUp) {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      await user?.updateDisplayName(fullName);
      user = FirebaseAuth.instance.currentUser;

      return user;
    } else {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    }
  }
}
