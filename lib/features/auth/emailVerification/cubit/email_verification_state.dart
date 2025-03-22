abstract class EmailVerificationState {}

class EmailVerificationInitial extends EmailVerificationState {
  final int countdown;
  EmailVerificationInitial(this.countdown);
}

class EmailVerificationInProgress extends EmailVerificationState {
  final int countdown;
  EmailVerificationInProgress(this.countdown);
}

class EmailVerificationSuccess extends EmailVerificationState {}

class EmailVerificationFailure extends EmailVerificationState {
  final String error;
  EmailVerificationFailure(this.error);
}

class EmailVerificationResendAvailable extends EmailVerificationState {}