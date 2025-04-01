import 'package:flutter/material.dart';
import 'package:food_lens/features/Profile/views/screens/profile_manager_screen.dart';
import 'package:food_lens/features/Profile/views/widgets/logout_button.dart';
import '../widgets/profile_header.dart';
import '../widgets/settings_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(centerTitle: true, title: Text('Profile')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProfileHeader(),
            //const SectionTitle(title: "Account Settings"),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8 , horizontal: 20),
              child: Text(
                'Account Settings',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            SettingsTile(
              icon: Icons.account_circle_rounded,
              title: "Healthy Profile",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            ProfileManagerScreen(mode: ProfileMode.view),
                  ),
                );
              },
            ),
            SettingsTile(
              icon: Icons.edit,
              title: "Update healthy profile",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            ProfileManagerScreen(mode: ProfileMode.update),
                  ),
                );
              },
            ),
            SettingsTile(
              icon: Icons.person_add,
              title: "Invite Friends",
              onTap: () {},
            ),
            SettingsTile(
              icon: Icons.privacy_tip,
              title: "Privacy Policy",
              onTap: () {
                //Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicy() ));
              },
            ),
            const LogoutButton(),
          ],
        ),
      ),
    );
  }
}

// Section Title
class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}
