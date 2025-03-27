import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_lens/features/Profile/repo/user_epository.dart';
import 'package:food_lens/features/Profile/screens/complete_user_profile.dart';
import 'package:food_lens/features/auth/emailVerification/views/email_verification_screen.dart';
import 'package:food_lens/features/auth/logic/auth_state.dart';
import 'package:food_lens/features/auth/repo/auth_method.dart';
import 'package:food_lens/features/auth/repo/email_password_auth.dart';
import 'package:food_lens/features/home/home.dart';

abstract class BaseAuthCubit extends Cubit<AuthState> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();

  final GlobalKey<FormFieldState> fullNameFieldKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> emailFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> passwordFieldKey =
      GlobalKey<FormFieldState>();

  BaseAuthCubit(super.initialState);

  Future<User?> authenticate(
    BuildContext context,
    AuthMethod authMethod, {
    required bool isSignUp,
  }) async {
    try {
      if (authMethod is EmailPasswordAuth && !isAllFieldsValidate()) {
        emit(FieldsError("Please fill in all fields"));
        return null;
      }

      emit(AuthLoading());

      final User? user = await authMethod.authenticate();

      if (user == null) {
        emit(AuthError("Authentication failed. Please try again."));
        return null;
      }

      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .get();

      final bool isNewUser = !userDoc.exists;

      emit(AuthSuccess(isSignUp ? "Sign Up Successful" : "Login Successful"));

      await _handleUserNavigation(context, user, isSignUp, isNewUser);
      return user;
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
          emit(
            AuthError("The password is too weak. Use at least 6 characters."),
          );
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
          emit(
            AuthError("Authentication failed: ${e.message ?? 'Unknown error'}"),
          );
      }
    } on FirebaseException catch (e) {
      emit(
        AuthError(
          "A Firebase error occurred: ${e.message ?? 'Please check your connection.'}",
        ),
      );
    } catch (e) {
      if (e.toString().contains("Google Sign-In was canceled")) {
        emit(AuthError("Google Sign-In was canceled."));
      } else {
        emit(AuthError("An unexpected error occurred: ${e.toString()}"));
        print("An unexpected error occurred: ${e.toString()}");
      }
    }
    return null;
  }

  Future<void> _handleUserNavigation(
    BuildContext context,
    User user,
    bool isSignUp,
    bool isNewUser,
  ) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    if (isNewUser) {
      await UserRepository().saveUserData(
        fullName: user.displayName ?? "",
        email: user.email ?? "",
      );
    }

    if (!user.emailVerified) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const EmailVerificationScreen(),
        ),
      );
      return;
    }

    final DocumentSnapshot userDoc = await _firestore.collection("users").doc(user.uid).get();

    final data = userDoc.data() as Map<String, dynamic>?;

    if (isNewUser ||
        data == null ||
        data["birthDate"] == null ||
        data["gender"] == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CompleteProfileScreen()),
      );
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Home()),
    );
  }

  String? validateEmail(String? value);

  String? validatePassword(String? value);

  bool isAllFieldsValidate();
}
