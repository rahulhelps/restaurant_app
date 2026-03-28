import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/bloc/auth_bloc/login/login_bloc.dart';
import 'package:restaurant_app/bloc/auth_bloc/register/register_bloc.dart';
import 'package:restaurant_app/bloc/cart_bloc/cart_bloc.dart';
import 'package:restaurant_app/bloc/food_bloc/food_bloc.dart';
import 'package:restaurant_app/bloc/network_bloc/network_bloc.dart';
import 'package:restaurant_app/bloc/order_bloc/order_history_bloc.dart';
import 'package:restaurant_app/data/services/order_service.dart';
import 'package:restaurant_app/presentation/screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NetworkBloc()),
        BlocProvider(create: (context) => RegisterBloc()),
        BlocProvider(create: (context) => LoginBloc()),
        BlocProvider(create: (context) => CartBloc()),
        BlocProvider(create: (context) => FoodBloc()),
        BlocProvider(create: (context) => OrderHistoryBloc(OrderService())),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
