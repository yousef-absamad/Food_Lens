import 'package:flutter/material.dart';
import 'package:food_lens/features/Profile/model/user_model.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel? userModel;
  const ProfileHeader({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    final String name = userModel?.fullName ?? "User";
    final String email = userModel?.email ?? "No email";
    final String? photoURL = userModel?.photoUrl;
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
            backgroundImage: photoURL != null ? NetworkImage(photoURL) : null,
            child: photoURL == null
                ? Text(
                    firstLetter,
                    style: const TextStyle(fontSize: 40),
                  )
                : null,
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
