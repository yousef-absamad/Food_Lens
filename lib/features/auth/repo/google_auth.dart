import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_lens/features/auth/repo/auth_method.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuth implements AuthMethod {
  @override
  Future<void> authenticate() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      throw Exception("Google Sign-In was canceled by the user.");
    }
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
  }
}