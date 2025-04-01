
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final String name = user?.displayName ?? "User";
    final String email = user?.email ?? "No email";
    final String firstLetter = name.isNotEmpty ? name[0].toUpperCase() : "?";

    return Container(
      width: double.infinity,
      height: 300,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 252, 254, 255),
            const Color.fromARGB(255, 220, 233, 240),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            child: Text(firstLetter, style: TextStyle(fontSize: 40)),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            email,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}
