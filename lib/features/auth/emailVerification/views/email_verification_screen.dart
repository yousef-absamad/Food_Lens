import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_lens/features/home/screens/home_screen.dart';

import '../cubit/email_verification_cubit.dart';
import '../cubit/email_verification_state.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmailVerificationCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: BlocConsumer<EmailVerificationCubit, EmailVerificationState>(
              listener: (context, state) {
                // if (state is EmailVerificationSuccess) {
                //   Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(builder: (context) => const HomePage()),
                //   );
                // } else if (state is EmailVerificationFailure) {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(content: Text("Error: ${state.error}")),
                //   );
                // }
              },
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.email_outlined,
                      size: 80,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Verify Your Email",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "We sent a verification link to ${FirebaseAuth.instance.currentUser?.email ?? 'your email'}. Please check your inbox and click the link.",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 30),
                    if (state is EmailVerificationInProgress)
                      Text(
                        "Resend available in ${state.countdown} seconds",
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      )
                    else if (state is EmailVerificationResendAvailable)
                      TextButton(
                        onPressed: () {
                          context.read<EmailVerificationCubit>().resendEmail();
                        },
                        child: const Text(
                          "Resend Verification Email",
                          style: TextStyle(fontSize: 16, color: Colors.blueAccent),
                        ),
                      ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: state is EmailVerificationSuccess
                          ? () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const HomeScreen()),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Continue",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}