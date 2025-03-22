import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_lens/features/auth/emailVerification/views/email_verification_screen.dart';
import 'package:food_lens/features/auth/logic/auth_state.dart';
import 'package:food_lens/features/auth/repo/auth_method.dart';
import 'package:food_lens/features/auth/repo/email_password_auth.dart';
import 'package:food_lens/features/home/home.dart';


abstract class BaseAuthCubit extends Cubit<AuthState> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormFieldState> emailFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> passwordFieldKey = GlobalKey<FormFieldState>();

  BaseAuthCubit(super.initialState);

  Future<void> authenticate(BuildContext context, AuthMethod authMethod, {required bool isSignUp}) async {
    try {
      if (authMethod is EmailPasswordAuth && !isAllFieldsValidate()) {
        emit(FieldsError("Please fill in all fields"));
        return;
      }

      emit(AuthLoading());

      await authMethod.authenticate(); // No boolean check, relies on exceptions

      emit(AuthSuccess(isSignUp ? "Sign Up Successful" : "Login Successful"));

      if (authMethod is EmailPasswordAuth && isSignUp) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const EmailVerificationScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          emit(AuthError("The email address is badly formatted."));
          break;
        case 'user-not-found':
          emit(AuthError("No user found with this email."));
          break;
        case 'wrong-password':
          emit(AuthError("Incorrect password. Please try again."));
          break;
        case 'email-already-in-use':
          emit(AuthError("This email is already registered."));
          break;
        case 'weak-password':
          emit(AuthError("The password is too weak. Use at least 6 characters."));
          break;
        case 'operation-not-allowed':
          emit(AuthError("This sign-in method is not enabled."));
          break;
        case 'too-many-requests':
          emit(AuthError("Too many attempts. Please try again later."));
          break;
        case 'user-disabled':
          emit(AuthError("This account has been disabled."));
          break;
        default:
          emit(AuthError("Authentication failed: ${e.message ?? 'Unknown error'}"));
      }
    } on FirebaseException catch (e) {
      emit(AuthError("A Firebase error occurred: ${e.message ?? 'Please check your connection.'}"));
    } catch (e) {
      if (e.toString().contains("Google Sign-In was canceled")) {
        emit(AuthError("Google Sign-In was canceled."));
      } else {
        emit(AuthError("An unexpected error occurred: ${e.toString()}"));
        print("An unexpected error occurred: ${e.toString()}");
      }
    }
  }

  String? validateEmail(String? value);

  String? validatePassword(String? value);

  bool isAllFieldsValidate();
}