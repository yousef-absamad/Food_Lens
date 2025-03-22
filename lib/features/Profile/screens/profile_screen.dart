import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../auth/screens/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
          onPressed: () async {
            GoogleSignIn googleSignIn = GoogleSignIn();
            googleSignIn.disconnect();
            await FirebaseAuth.instance.signOut();

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false,
            );
          },
          icon: Icon(Icons.logout),
        ),
      ),
    );
  }
}
