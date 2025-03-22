import 'package:flutter/widgets.dart';
import 'package:food_lens/features/auth/logic/auth_cubit.dart';
import 'package:food_lens/features/auth/logic/auth_state.dart';
import 'package:food_lens/features/auth/repo/auth_method.dart';

class LoginCubit extends BaseAuthCubit {
  LoginCubit() : super(AuthInitial());

  Future<void> login(BuildContext context, AuthMethod authMethod) async {
    authenticate(context, authMethod , isSignUp: false);
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
}