
import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.blue),
          title: Text(title),
          trailing:
              trailing ??
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          onTap: onTap,
        ),
        Divider(indent: 20, endIndent: 20, thickness: 0.5),
      ],
    );
  }
}