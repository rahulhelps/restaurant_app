import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/bloc/order_bloc/order_history_bloc.dart';
import 'package:restaurant_app/data/services/order_service.dart';
import 'package:restaurant_app/presentation/screens/auth/login_screen.dart';
import 'package:restaurant_app/presentation/screens/order/order_history.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();

  static Widget _animatedTile(
    IconData icon,
    String text,
    void Function()? onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF1B5E20).withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFF1B5E20)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  static Widget _divider() {
    return const Divider(height: 1, indent: 70);
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "";
  String email = "";

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("name") ?? "No Name";
      email = prefs.getString("email") ?? "No Email";
    });
    print("Loaded Name: $name");
    print("Loaded Email: $email");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            /// 🔥 MODERN & ANIMATED HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 40, bottom: 40),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1B5E20),
                    Color(0xFF2E7D32),
                    Color(0xFF388E3C),
                  ],
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  // Profile Picture with Animation + Border
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Glow Effect
                      Container(
                        width: 108,
                        height: 108,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Colors.white, Colors.transparent],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.4),
                              blurRadius: 25,
                              spreadRadius: 8,
                            ),
                          ],
                        ),
                      ),
                      // Actual Profile Image
                      Hero(
                        tag: "profile_image",
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: const CircleAvatar(
                            radius: 48,
                            backgroundImage: NetworkImage(
                              'https://i.pinimg.com/736x/99/22/79/9922796b9c9445c09dbb4abe42219b99.jpg',
                            ),
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Name with subtle animation
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Email
                  Text(
                    email,
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListView(
                    children: [
                      const SizedBox(height: 10),
                      ProfileScreen._divider(),

                      ProfileScreen._animatedTile(
                        Icons.history,
                        "Order History",
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) =>
                                    OrderHistoryBloc(OrderService()),
                                child: OrderHistoryScreen(),
                              ),
                            ),
                          );
                        },
                      ),
                      ProfileScreen._divider(),
                      ProfileScreen._animatedTile(
                        Icons.help_outline,
                        "Help & Support",
                            () async {
                          const String phoneNumber = "8801889663816";
                          final Uri whatsappUri = Uri.parse("https://wa.me/$phoneNumber");

                          try {
                            await launchUrl(
                              whatsappUri,
                              mode: LaunchMode.externalApplication,
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error: $e")),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 30),

                      /// Logout Button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: const Text(
                                  "Logout",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                content: const Text(
                                  "Are you sure, do you want to logout?",
                                  style: TextStyle(fontSize: 16.5, height: 1.4),
                                ),
                                actionsPadding: const EdgeInsets.fromLTRB(
                                  16,
                                  0,
                                  24,
                                  24,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                    ),
                                    child: const Text(
                                      "No",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      await prefs.remove('token');
                                      await prefs.remove('userId');
                                      await prefs.remove('name');
                                      await prefs.remove('email');

                                      if (!mounted) return;

                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen(),
                                        ),
                                        (route) => false,
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                    ),
                                    child: const Text(
                                      "Yes",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Ink(
                            height: 52,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: const Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.logout, color: Colors.red),
                                  SizedBox(width: 10),
                                  Text(
                                    "Logout",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
