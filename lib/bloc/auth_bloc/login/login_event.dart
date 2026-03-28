class LoginEvent {}

class LoginTextChangeEvent extends LoginEvent {
  final String email;
  final String password;

  LoginTextChangeEvent({required this.email, required this.password});
}

class LoginSubmitEvent extends LoginEvent {
  final String email;
  final String password;

  LoginSubmitEvent({required this.email, required this.password,});
}
