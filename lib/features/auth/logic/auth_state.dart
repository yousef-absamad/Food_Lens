abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;
  AuthSuccess(this.message);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
class GoogleCanceled extends AuthState {
  final String message;
  GoogleCanceled(this.message);
}

class FieldsError extends AuthState {
  final String message;
  FieldsError(this.message);
}

class AuthForgetPassSuccess extends AuthState {
  final String message;
  AuthForgetPassSuccess(this.message);
}