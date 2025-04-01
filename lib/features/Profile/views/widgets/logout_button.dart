import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_lens/features/auth/screens/login_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text("Logout", style: TextStyle(color: Colors.red)),
      onTap: () async {
        GoogleSignIn googleSignIn = GoogleSignIn();
        googleSignIn.disconnect();
        await FirebaseAuth.instance.signOut();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
        );
      },
    );
  }
}