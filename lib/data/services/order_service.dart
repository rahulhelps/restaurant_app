// data/services/order_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order_model.dart';

class OrderService {
  static const String baseUrl = 'http://10.0.2.2:2000/api';

  Future<List<OrderModel>> getUserOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      final userId = prefs.getString("userId");

      if (token == null || userId == null) {
        throw Exception("User not authenticated");
      }

      print("🔄 Fetching Orders for userId: $userId");

      final response = await http.get(
        Uri.parse('$baseUrl/orders/user/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("📡 Get Orders Status Code: ${response.statusCode}");
      print("📡 Get Orders Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        final List<dynamic> ordersList = data['data'] ?? [];

        print("✅ Orders found: ${ordersList.length}");

        return ordersList.map((json) => OrderModel.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load orders: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ OrderService Error: $e");
      rethrow;
    }
  }
}