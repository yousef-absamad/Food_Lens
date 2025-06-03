
  import 'package:flutter/material.dart';

Widget buildInkContainer({
    required Color color,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    BorderRadius? borderRadius,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(24),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: borderRadius ?? BorderRadius.circular(24),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 50, color: Colors.white),
                  const SizedBox(height: 12),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }