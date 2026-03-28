class RegisterEvent {}

class RegisterTextChangeEvent extends RegisterEvent {
  final String name;
  final String email;
  final String password;

  RegisterTextChangeEvent({
    required this.name,
    required this.email,
    required this.password,
  });
}

class RegisterSubmitEvent extends RegisterEvent {
  final String name;
  final String email;
  final String password;

  RegisterSubmitEvent({
    required this.name,
    required this.email,
    required this.password,
  });
}
