import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:restaurant_app/bloc/auth_bloc/register/register_event.dart';
import 'package:restaurant_app/bloc/auth_bloc/register/register_state.dart';
import 'package:restaurant_app/data/services/api_services.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterTextChangeEvent>(registerTextChangeEvent);
    on<RegisterSubmitEvent>(registerSubmitEvent);
  }

  FutureOr<void> registerTextChangeEvent(
    RegisterTextChangeEvent event,
    Emitter<RegisterState> emit,
  ) {
    if (event.name.trim().toString().isEmpty) {
      emit(RegisterErrorState(errorMessage: 'Please enter your name'));
    } else if (EmailValidator.validate(event.email) == false) {
      emit(RegisterErrorState(errorMessage: 'Please enter valid email'));
    } else if (event.password.trim().toString().isEmpty ||
        event.password.trim().toString().length < 6) {
      emit(RegisterErrorState(errorMessage: 'Please enter 6 digit password'));
    } else {
      emit(RegisterValidState());
    }
  }

  FutureOr<void> registerSubmitEvent(
    RegisterSubmitEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoadingState());
    if (event.name.isNotEmpty &&
        event.email.isNotEmpty &&
        event.password.isNotEmpty) {
      try {
        ApiServices.createAccount(event.name, event.email, event.password);
        await Future.delayed(Duration(milliseconds: 1200), () {
          emit(RegisterSuccessState());
        });
      } catch (e) {
        print("ERROR: $e");
        emit(RegisterErrorState(errorMessage: e.toString()));
      }
    }
  }
}
