import 'package:flutter/material.dart';
class CustomButton extends StatelessWidget {
  final String label; 
  final VoidCallback? onPressed; 
  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed, 
        style: ElevatedButton.styleFrom(
           backgroundColor: onPressed != null ? Colors.green : Colors.grey,
          padding: const EdgeInsets.symmetric(vertical: 12), 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), 
          ),
        ),
        child: Text(
          label, 
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}