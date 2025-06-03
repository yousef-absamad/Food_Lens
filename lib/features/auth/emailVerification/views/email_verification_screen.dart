import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_lens/core/widgets/custom_button.dart';
import 'package:food_lens/features/Profile/views/screens/complete_profile_screen.dart';
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
              listener: (context, state) {},
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 50),
                      const Text(
                        "Verify Your Email",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color:  Color.fromARGB(255, 3, 169, 8),
                        ),
                      ),
                      SizedBox(
                        height: 350,
                        child: SvgPicture.asset('assets/image/email_check.svg'),
                      ),
                      Text(
                        "We sent a verification link to",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        FirebaseAuth.instance.currentUser?.email ??
                            'your email',
                        style: const TextStyle(
                          fontSize: 18,
                          color:Colors.blueAccent,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        ' Please check your inbox and click the link.',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 30),
                      if (state is EmailVerificationInProgress)
                        Text(
                          textAlign: TextAlign.start,
                          "Resend available in ${state.countdown} seconds",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        )
                      else if (state is EmailVerificationResendAvailable)
                        TextButton(
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          onPressed: () {
                            context
                                .read<EmailVerificationCubit>()
                                .resendEmail();
                          },
                          child: const Text(
                            "Resend Verification Email",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 3, 169, 8),
                            ),
                          ),
                        ),
                      const SizedBox(height: 100),
                      CustomButton(
                        label: "Continue",
                        onPressed:
                            state is EmailVerificationSuccess
                                ? () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => CompleteProfileScreen(),
                                    ),
                                  );
                                }
                                : null,
                      ),
                    
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
