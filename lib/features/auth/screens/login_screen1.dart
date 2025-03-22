import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_lens/features/auth/logic/auth_state.dart';
import 'package:food_lens/features/auth/logic/login_cubit.dart';
import 'package:food_lens/features/auth/repo/auth_method.dart';
import 'package:food_lens/features/auth/repo/email_password_auth.dart';
import 'package:food_lens/features/auth/repo/google_auth.dart';
import 'package:food_lens/features/auth/screens/sign_up_screen1.dart';

import '../../../core/awesome_dialog.dart';
import '../../../core/cutom_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Builder(
        builder: (context) {
          final loginCubit = context.read<LoginCubit>();
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
                      hintText: "Email Address",
                      controller: loginCubit.emailController,
                      keyboardType: TextInputType.emailAddress,
                      icon: Icons.email,
                      validator: loginCubit.validateEmail,
                      formFieldKey: loginCubit.emailFieldKey,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: CustomTextField(
                      hintText: "Password",
                      controller: loginCubit.passwordController,
                      isPassword: true,
                      icon: Icons.lock,
                      validator: loginCubit.validatePassword,
                      formFieldKey: loginCubit.passwordFieldKey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  BlocConsumer<LoginCubit, AuthState>(
                    listener: (context, state) {
                      if (state is AuthSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else if (state is AuthError) {
                        awesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          title: 'Error',
                          desc: state.message, // Updated to use message
                        );
                      } else if (state is FieldsError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            backgroundColor: Colors.red,
                          ),
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
                          final AuthMethod emailPasswordAuth =
                              EmailPasswordAuth(
                                isSignUp: false,
                                email: loginCubit.emailController.text,
                                password: loginCubit.passwordController.text,
                              );
                          loginCubit.login(context, emailPasswordAuth);
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
                          "Login",
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
                        "Don't have an account?",
                        style: TextStyle(color: Colors.green),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Color.fromARGB(255, 163, 81, 63),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      final AuthMethod googlrAuth = GoogleAuth();
                      loginCubit.authenticate(context, googlrAuth , isSignUp: false);
                    },
                    icon: Icon(Icons.login),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
