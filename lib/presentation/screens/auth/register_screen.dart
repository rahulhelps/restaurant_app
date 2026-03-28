import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/bloc/auth_bloc/register/register_bloc.dart';
import 'package:restaurant_app/bloc/auth_bloc/register/register_event.dart';
import 'package:restaurant_app/bloc/auth_bloc/register/register_state.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final RegisterBloc registerBloc = RegisterBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => registerBloc,
      child: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccessState) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
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
                        "Create Account",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Text("Register to get started"),
                      const SizedBox(height: 10),
                      state is RegisterErrorState
                          ? Text(
                              state.errorMessage.toString(),
                              style: TextStyle(color: Colors.red, fontSize: 15),
                            )
                          : SizedBox(),

                      const SizedBox(height: 30),

                      _textField(
                        onChanged: (value) {
                          registerBloc.add(
                            RegisterTextChangeEvent(
                              name: nameController.text,
                              email: emailController.text,
                              password: passController.text,
                            ),
                          );
                        },
                        controller: nameController,
                        hint: "Name",
                        icon: Icons.person,
                      ),

                      const SizedBox(height: 15),

                      _textField(
                        onChanged: (value) {
                          registerBloc.add(
                            RegisterTextChangeEvent(
                              name: nameController.text,
                              email: emailController.text,
                              password: passController.text,
                            ),
                          );
                        },
                        controller: emailController,
                        hint: "Email",
                        icon: Icons.email,
                      ),

                      const SizedBox(height: 15),

                      _textField(
                        onChanged: (value) {
                          registerBloc.add(
                            RegisterTextChangeEvent(
                              name: nameController.text,
                              email: emailController.text,
                              password: passController.text,
                            ),
                          );
                        },
                        controller: passController,
                        hint: "Password",
                        icon: Icons.lock,
                        isPassword: true,
                      ),

                      const SizedBox(height: 25),

                      InkWell(
                        onTap:
                            state is RegisterValidState &&
                                state is! RegisterLoadingState
                            ? () {
                                registerBloc.add(
                                  RegisterSubmitEvent(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passController.text,
                                  ),
                                );
                              }
                            : null,
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            color: state is! RegisterValidState
                                ? Colors.grey
                                : Colors.green,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: state is RegisterLoadingState
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.red,
                                    ),
                                  )
                                : Text(
                                    "Sign Up",
                                    style: TextStyle(color: Colors.white),
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
                          InkWell(
                            onTap: () {},
                            child: _social(Icons.g_mobiledata),
                          ),
                          const SizedBox(width: 20),
                          _social(Icons.facebook),
                        ],
                      ),

                      SizedBox(height: 40),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).viewInsets.bottom,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    required void Function(String) onChanged,
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

  Widget _social(IconData icon) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.grey.shade200,
      child: Icon(icon),
    );
  }
}
