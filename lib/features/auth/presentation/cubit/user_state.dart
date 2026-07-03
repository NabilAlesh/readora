abstract class UserStates {}
final class UserInitial extends UserStates {}

final class AuthLoading extends UserStates {}

final class AuthSuccess extends UserStates {}
class AuthError extends UserStates{
 final String error;
 AuthError({required this.error});
}

class ForgetPasswordLoading extends UserStates {}
class ForgetPasswordSuccess extends UserStates {}
class ForgetPasswordError extends UserStates {
  final String error;
  ForgetPasswordError({required this.error});
}

class VerifyOTPLoading extends UserStates {}
class VerifyOTPSuccess extends UserStates {}
class VerifyOTPError extends UserStates {
  final String error;
  VerifyOTPError({required this.error});
}

class ResetPasswordLoading extends UserStates {}
class ResetPasswordSuccess extends UserStates {}
class ResetPasswordError extends UserStates {
  final String error;
  ResetPasswordError({required this.error});
}

class VerifyEmailLoading extends UserStates {}
class VerifyEmailSuccess extends UserStates {}
class VerifyEmailError extends UserStates {
  final String error;
  VerifyEmailError({required this.error});
}