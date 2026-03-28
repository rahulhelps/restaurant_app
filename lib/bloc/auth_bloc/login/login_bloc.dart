import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:restaurant_app/data/services/api_services.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginTextChangeEvent>(loginTextChangeEvent);
    on<LoginSubmitEvent>(loginSubmitEvent);
  }

  FutureOr<void> loginTextChangeEvent(
    LoginTextChangeEvent event,
    Emitter<LoginState> emit,
  ) {
    if (EmailValidator.validate(event.email) == false) {
      emit(LoginErrorState(errorMessage: 'Please enter a valid email'));
    } else if (event.password.trim().toString().isEmpty ||
        event.password.trim().toString().length < 6) {
      emit(LoginErrorState(errorMessage: 'Please enter 6 digit password'));
    } else {
      emit(LoginValidState());
    }
  }

  FutureOr<void> loginSubmitEvent(
    LoginSubmitEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoadingState());

    try {
      final success = await ApiServices.loginAccount(
        event.email,
        event.password,
      );

      if (success == true) {
        emit(LoginSuccessState());
      } else {
        emit(LoginSuccessErrorState(errorMessage: "Invalid credentials"));
      }
    } catch (e) {
      emit(LoginSuccessErrorState(errorMessage: e.toString()));
    }
  }
}
