import 'package:flutter/material.dart';
import 'package:food_lens/features/Profile/model/user_model.dart';
import 'package:food_lens/features/Profile/view%20model/repo/user_epository.dart';
import 'package:food_lens/features/Profile/views/screens/update_profile_screen.dart';
import 'package:food_lens/features/Profile/views/screens/view_profile_screen.dart';
import 'package:food_lens/features/Profile/views/widgets/logout_button.dart';
import '../widgets/profile_header.dart';
import '../widgets/settings_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserModel?> _userFuture;
  final UserRepository _userRepo = UserRepository();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _userFuture = _userRepo.getUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(centerTitle: true, title: Text('Profile')),
      body: FutureBuilder<UserModel?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final userModel = snapshot.data;
          return SingleChildScrollView(
            key: ValueKey(userModel?.hashCode),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileHeader(userModel: userModel),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 20,
                  ),
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
                                ViewProfileScreen(userModel: userModel),
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
                                UpdateProfileScreen(userModel: userModel),
                      ),
                    );

                    if (isUpdated ?? false) {
                      _loadData();
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
                  onTap: () {},
                ),
                const LogoutButton(),
              ],
            ),
          );
        },
      ),
    );
  }
}
