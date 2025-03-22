import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'email_verification_state.dart';

class EmailVerificationCubit extends Cubit<EmailVerificationState> {
  Timer? _countdownTimer;
  Timer? _verificationTimer;
  int _countdown = 60;

  EmailVerificationCubit() : super(EmailVerificationInitial(60)) {
    _startCountdownTimer();
    _sendVerificationEmail();
    _checkEmailVerificationPeriodically();
  }

  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        _countdown--;
        emit(EmailVerificationInProgress(_countdown));
      } else {
        emit(EmailVerificationResendAvailable());
        _countdownTimer?.cancel();
      }
    });
  }

  void _sendVerificationEmail() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      emit(EmailVerificationFailure(e.toString()));
    }
  }

  void resendEmail() {
    if (state is EmailVerificationResendAvailable) {
      _countdown = 60;
      _sendVerificationEmail();
      _startCountdownTimer();
      emit(EmailVerificationInProgress(_countdown));
    }
  }

  void _checkEmailVerificationPeriodically() {
    // _verificationTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
    //   await FirebaseAuth.instance.currentUser?.reload();
    //   User? user = FirebaseAuth.instance.currentUser;
    //   if (user != null && user.emailVerified) {
    //     emit(EmailVerificationSuccess());
    //     _verificationTimer?.cancel();
    //     _countdownTimer?.cancel();
    //   }
    // });
  }

  @override
  Future<void> close() {
    _countdownTimer?.cancel();
    _verificationTimer?.cancel();
    return super.close();
  }
}