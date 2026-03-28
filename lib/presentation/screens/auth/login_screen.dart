import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/bloc/auth_bloc/login/login_bloc.dart';
import 'package:restaurant_app/bloc/auth_bloc/login/login_event.dart';
import 'package:restaurant_app/bloc/auth_bloc/login/login_state.dart';
import '../nav/nav_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final LoginBloc _loginBloc = LoginBloc();

  @override
  Widget build(BuildContext context) {
    final String error;

    return BlocConsumer<LoginBloc, LoginState>(
      bloc: _loginBloc,
      listener: (context, state) {
        if (state is LoginSuccessState) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => NavScreen()),
            (route) => false,
          );
        } else if (state is LoginSuccessErrorState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    /// 🔥 LOGO
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.green.shade100,
                      child: const Icon(
                        Icons.restaurant,
                        size: 40,
                        color: Colors.green,
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Text("Login to your account"),
                    const SizedBox(height: 10),
                    state is LoginErrorState
                        ? Text(
                            state.errorMessage.toString(),
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : SizedBox(),

                    const SizedBox(height: 30),

                    /// 📧 EMAIL
                    _textField(
                      onChanged: (value) {
                        _loginBloc.add(
                          LoginTextChangeEvent(
                            email: emailController.text.trim(),
                            password: passController.text.trim(),
                          ),
                        );
                      },
                      controller: emailController,
                      hint: "Email",
                      icon: Icons.email,
                    ),

                    const SizedBox(height: 15),

                    /// 🔒 PASSWORD
                    _textField(
                      onChanged: (value) {
                        _loginBloc.add(
                          LoginTextChangeEvent(
                            email: emailController.text.trim(),
                            password: passController.text.trim(),
                          ),
                        );
                      },
                      controller: passController,
                      hint: "Password",
                      icon: Icons.lock,
                      isPassword: true,
                    ),

                    const SizedBox(height: 25),

                    /// 🔥 LOGIN BUTTON
                    InkWell(
                      onTap:
                          state is LoginValidState &&
                              state is! LoginLoadingState
                          ? () {
                              _loginBloc.add(
                                LoginSubmitEvent(
                                  email: emailController.text,
                                  password: passController.text,
                                ),
                              );
                              passController.text = '';
                            }
                          : null,
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: state is LoginValidState
                              ? Colors.green
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: state is LoginLoadingState
                              ? Center(child: CircularProgressIndicator())
                              : Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text("Or continue with"),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _social(Icons.g_mobiledata),
                        const SizedBox(width: 20),
                        _social(Icons.facebook),
                      ],
                    ),

                    SizedBox(height: 40),

                    /// 🔄 GO TO REGISTER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 🔹 TEXT FIELD
  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    void Function(String)? onChanged,
  }) {
    return TextField(
      onChanged: onChanged,
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  /// 🔹 SOCIAL BUTTON
  Widget _social(IconData icon) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.grey.shade200,
      child: Icon(icon),
    );
  }
}
