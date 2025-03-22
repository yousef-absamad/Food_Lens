import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_lens/core/awesome_dialog.dart';
import 'package:food_lens/core/cutom_text_field.dart';
import 'package:food_lens/features/auth/logic/auth_state.dart';
import 'package:food_lens/features/auth/logic/sign_up_cubit.dart';
import 'package:food_lens/features/auth/repo/auth_method.dart';
import 'package:food_lens/features/auth/repo/email_password_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: Builder(
        builder: (context) {
          final signUpCubit = context.read<SignUpCubit>();
          return Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 200),
                    const Text(
                      "Create Account",
                      textAlign: TextAlign.center,
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
                        formFieldKey: signUpCubit.nameFieldKey,
                        hintText: "Full Name",
                        controller: signUpCubit.nameController,
                        keyboardType: TextInputType.text,
                        icon: Icons.person,
                        validator: signUpCubit.validateName,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: CustomTextField(
                        formFieldKey: signUpCubit.emailFieldKey,
                        hintText: "Email Address",
                        controller: signUpCubit.emailController,
                        keyboardType: TextInputType.emailAddress,
                        icon: Icons.email,
                        validator: signUpCubit.validateEmail,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: CustomTextField(
                        formFieldKey: signUpCubit.passwordFieldKey,
                        hintText: "Password",
                        controller: signUpCubit.passwordController,
                        isPassword: true,
                        icon: Icons.lock,
                        validator: signUpCubit.validatePassword,
                      ),
                    ),
                    const SizedBox(height: 20),
                    BlocConsumer<SignUpCubit, AuthState>( 
                      listener: (context, state) {
                        if (state is AuthSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message), 
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else if (state is FieldsError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else if (state is AuthError) { 
                          awesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            title: 'Error',
                            desc: state.message, 
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return const CircularProgressIndicator(
                            color: Colors.green,
                          );
                        }
                        return ElevatedButton(
                          onPressed: () {
                            final AuthMethod emailPasswordAuth = EmailPasswordAuth(
                              email: signUpCubit.emailController.text,
                              password: signUpCubit.passwordController.text,
                              isSignUp: true,
                            );
                            signUpCubit.signUp(context, emailPasswordAuth);
                          },
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
                            "Sign Up",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(color: Colors.green),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}