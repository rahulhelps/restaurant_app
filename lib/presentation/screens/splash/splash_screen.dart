import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/presentation/screens/nav/nav_screen.dart';
import '../../../bloc/network_bloc/network_bloc.dart';
import '../../../bloc/network_bloc/network_state.dart';
import '../../../core/utils/token_storage.dart';
import '../auth/login_screen.dart';
import '../no_internet/no_internet_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NetworkBloc, NetworkState>(
      listener: (context, state) {
        if (state is NetworkConnectedState) {
          Future.delayed(const Duration(milliseconds: 2000), () async {
            await checkAuthAndNavigate(context);
          });
        }

        // if (state is NetworkConnectedState){
        //   Future.delayed(const Duration(milliseconds: 2000), () {
        //     Navigator.pushAndRemoveUntil(
        //       context,
        //       MaterialPageRoute(builder: (context) => const RegisterScreen()),
        //       (route) => false,
        //     );
        //   });
        // }
      },
      builder: (context, state) {
        if (state is NetworkConnectedState) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.restaurant, size: 80, color: Colors.orange),
                      SizedBox(height: 20),
                      Text(
                        "Bouna Restaurant",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        if (state is NetworkDisconnectedState) {
          return NoInternetScreen();
        } else {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Future<void> checkAuthAndNavigate(BuildContext context) async {
    final token = await TokenStorage.getToken(); // or SharedPreferences

    if (token != null && token.isNotEmpty) {
      // ✅ Already logged in
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => NavScreen()),
        (route) => false,
      );
    } else {
      // ❌ Not logged in
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false,
      );
    }
  }
}
