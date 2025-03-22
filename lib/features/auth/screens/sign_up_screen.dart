import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_lens/core/awesome_dialog.dart';
import 'package:food_lens/core/cutom_text_field.dart';
import 'package:food_lens/features/auth/logic/auth_state.dart';
import 'package:food_lens/features/auth/logic/sign_up_cubit.dart';
import 'package:food_lens/features/auth/repo/auth_method.dart';
import 'package:food_lens/features/auth/repo/email_password_auth.dart';
import 'package:food_lens/features/auth/repo/google_auth.dart';

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
                    SizedBox(height: 50),
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
                    SizedBox(
                      height: 200,
                      width: 400,
                      child: SvgPicture.asset(
                        'assets/image/Healthy options-amico.svg',
                      ),
                    ),
                    Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: CustomTextField(
                        textFieldName: 'Full name',
                        formFieldKey: signUpCubit.nameFieldKey,
                        hintText: "Enter Name",
                        controller: signUpCubit.nameController,
                        keyboardType: TextInputType.text,
                        icon: Icons.person,
                        validator: signUpCubit.validateName,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: CustomTextField(
                        textFieldName: 'Email',
                        formFieldKey: signUpCubit.emailFieldKey,
                        hintText: "Enter Email Address",
                        controller: signUpCubit.emailController,
                        keyboardType: TextInputType.emailAddress,
                        icon: Icons.email,
                        validator: signUpCubit.validateEmail,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: CustomTextField(
                        textFieldName: 'Password',
                        formFieldKey: signUpCubit.passwordFieldKey,
                        hintText: "Enter Password",
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
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              final AuthMethod emailPasswordAuth =
                                  EmailPasswordAuth(
                                    email: signUpCubit.emailController.text,
                                    password:
                                        signUpCubit.passwordController.text,
                                    isSignUp: true,
                                  );
                              signUpCubit.signUp(context, emailPasswordAuth);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 15),
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
                        signUpCubit.authenticate(
                          context,
                          googlrAuth,
                          isSignUp: true,
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
                          "Already have an account?",
                          style: TextStyle(color: Colors.black),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
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
