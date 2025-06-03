import 'package:flutter/material.dart';
import 'package:food_lens/features/Profile/model/user_model.dart';
import 'package:food_lens/features/Profile/views/screens/privacy.dart';
import 'package:food_lens/features/Profile/views/screens/update_profile_screen.dart';
import 'package:food_lens/features/Profile/views/screens/view_profile_screen.dart';
import 'package:food_lens/features/Profile/views/widgets/logout_button.dart';
import '../widgets/profile_header.dart';
import '../widgets/settings_tile.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel userModel;
  final VoidCallback onUserUpdated;

  const ProfileScreen({
    super.key,
    required this.userModel,
    required this.onUserUpdated,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(centerTitle: true, title: Text('Profile')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileHeader(userModel: widget.userModel),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
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
                            ViewProfileScreen(userModel: widget.userModel),
                  ),
                );
              },
            ),
            SettingsTile(
              icon: Icons.edit,
              title: "Update profile",
              onTap: () async {
                final isUpdated = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            UpdateProfileScreen(userModel: widget.userModel),
                  ),
                );

                if (isUpdated ?? false) {
                  widget.onUserUpdated();
                }
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Privacy()),
                );
              },
            ),
            const LogoutButton(),
          ],
        ),
      ),
    );
  }
}

