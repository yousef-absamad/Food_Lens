import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_lens/features/auth/logic/auth_state.dart';
import 'package:food_lens/features/auth/logic/login_cubit.dart';
import 'package:food_lens/features/auth/repo/auth_method.dart';
import 'package:food_lens/features/auth/repo/email_password_auth.dart';
import 'package:food_lens/features/auth/repo/google_auth.dart';
import 'package:food_lens/features/auth/screens/sign_up_screen.dart';

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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    const Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      width: 400,
                      child: SvgPicture.asset(
                        'assets/image/Healthy lifestyle-bro.svg',
                      ),
                    ),
                    Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: CustomTextField(
                        textFieldName: 'Email',
                        hintText: "Enter Email Address",
                        controller: loginCubit.emailController,
                        keyboardType: TextInputType.emailAddress,
                        icon: Icons.email,
                        validator: loginCubit.validateEmail,
                        formFieldKey: loginCubit.emailFieldKey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: CustomTextField(
                        textFieldName: 'Password',
                        hintText: "Enter Password",
                        controller: loginCubit.passwordController,
                        isPassword: true,
                        icon: Icons.lock,
                        validator: loginCubit.validatePassword,
                        formFieldKey: loginCubit.passwordFieldKey,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {
                          loginCubit.sendForgetPassword();
                        },
                        child: Text(
                          'Forget Password ?',
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
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
                        } else if (state is AuthForgetPassSuccess) {
                          awesomeDialog(
                            context: context,
                            dialogType: DialogType.success,
                            title: 'Password Reset',
                            desc: 'Check your email to reset your passwords.',
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return Center(
                            child: const CircularProgressIndicator(
                              color: Colors.green,
                            ),
                          );
                        }
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              final AuthMethod
                              emailPasswordAuth = EmailPasswordAuth(
                                isSignUp: false,
                                email: loginCubit.emailController.text,
                                password: loginCubit.passwordController.text,
                                fullName: loginCubit.fullNameController.text,
                              );
                              loginCubit.login(context, emailPasswordAuth);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(color: Colors.grey, thickness: 1),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text('OR'),
                        ),
                        Expanded(
                          child: Divider(color: Colors.grey, thickness: 1),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        final AuthMethod googlrAuth = GoogleAuth();
                        loginCubit.authenticate(
                          context,
                          googlrAuth,
                          isSignUp: false,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.symmetric(vertical: 10),
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.all(
                            Radius.elliptical(10, 10),
                          ),
                        ),
                        child: SvgPicture.asset(
                          'assets/image/google-icon-logo-svgrepo-com.svg',
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.black),
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
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
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
