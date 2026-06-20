abstract class UserStates {}
final class UserInitial extends UserStates {}

final class AuthLoading extends UserStates {}

final class AuthSuccess extends UserStates {}
class AuthError extends UserStates{
 final String error;
 AuthError({required this.error});
}