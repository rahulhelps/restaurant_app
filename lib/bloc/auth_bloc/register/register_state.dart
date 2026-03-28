class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterValidState extends RegisterState {}

class RegisterInValidState extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

class RegisterSuccessState extends RegisterState {}
class RegisterErrorState extends RegisterState {
  final String errorMessage;

  RegisterErrorState({required this.errorMessage});
}
