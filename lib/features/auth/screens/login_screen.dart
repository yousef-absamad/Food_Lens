import 'package:flutter/material.dart';

import '../../home/home.dart';
import '../widgets/custom_text_field.dart';
import 'sign_up_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormFieldState> _emailFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _passwordFieldKey =
      GlobalKey<FormFieldState>();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Please enter your email";
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Please enter your password";
    return null;
  }

  void _login(BuildContext context) {
    final isEmailValid = _emailFieldKey.currentState?.validate() ?? false;
    final isPasswordValid = _passwordFieldKey.currentState?.validate() ?? false;

    // if (isPasswordValid && isEmailValid) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text("Login Successful"),
    //       backgroundColor: Colors.green,
    //     ),
    //   );
    //   Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (context) => Home()),
    //     (route) => false,
    //   );
    // } 
    // else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text("Please fix the errors before logging in."),
    //       backgroundColor: Colors.red,
    //     ),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome Back!",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 30),
            Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: CustomTextField(
                formFieldKey: _emailFieldKey,
                hintText: "Email Address",
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                icon: Icons.email,
                validator: _validateEmail,
              ),
            ),
            const SizedBox(height: 15),
            Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: CustomTextField(
                formFieldKey: _passwordFieldKey,
                hintText: "Password",
                controller: passwordController,
                isPassword: true,
                icon: Icons.lock,
                validator: _validatePassword,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _login(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 40,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Login",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              child: const Text(
                "Don't have an account? Sign Up",
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
