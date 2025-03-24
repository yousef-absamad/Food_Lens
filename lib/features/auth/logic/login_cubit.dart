import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:food_lens/features/Profile/repo/user_epository.dart';
import 'package:food_lens/features/auth/logic/auth_cubit.dart';
import 'package:food_lens/features/auth/logic/auth_state.dart';
import 'package:food_lens/features/auth/repo/auth_method.dart';

class LoginCubit extends BaseAuthCubit {
  UserRepository userRepository = UserRepository();
  LoginCubit() : super(AuthInitial());

  Future<void> login(BuildContext context, AuthMethod authMethod) async {
    final User? user = await authenticate(context, authMethod, isSignUp: false);

    if (user != null) {
      userRepository.saveUserData(
        fullName: user.displayName ?? "",
        email: user.email ?? "",
      );
    }
  }

  Future<void> sendForgetPassword() async {
  if (isEmailValidate()) {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text,
      );
      emit(AuthForgetPassSuccess('Check your email to reset your password.'));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        emit(AuthError('Please enter a valid email address.'));
      } else if (e.code == 'too-many-requests') {
        emit(AuthError('Too many attempts. Try again later.'));
      } else {
        emit(AuthError('An unexpected error occurred. Please try again.'));
      }
    } catch (e) {
      emit(AuthError('Something went wrong. Please try again.'));
    }
  } else {
    emit(FieldsError('Please enter a valid email.'));
  }
}


  @override
  bool isAllFieldsValidate() {
    final isEmailValid = emailFieldKey.currentState?.validate() ?? false;
    final isPasswordValid = passwordFieldKey.currentState?.validate() ?? false;
    return isEmailValid && isPasswordValid;
  }

  @override
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Please enter your email";
    return null;
  }

  @override
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Please enter your password";
    return null;
  }

  bool isEmailValidate() {
    final isEmailValid = emailFieldKey.currentState?.validate() ?? false;
    return isEmailValid;
  }
}
