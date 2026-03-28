class LoginState {}

class LoginInitial extends LoginState {}

class LoginValidState extends LoginState {}

class LoginInValidState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {}
class LoginSuccessErrorState extends LoginState {
  final String errorMessage;

  LoginSuccessErrorState({required this.errorMessage});
}

class LoginErrorState extends LoginState {
  final String errorMessage;

  LoginErrorState({required this.errorMessage});
}
