import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_model.dart';

class CartService {
  static const String baseUrl = "http://10.0.2.2:2000";

 static Future<bool> addToCart({
    required String foodId,
    required int quantity,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      final userId = prefs.getString("userId");

      if (token == null || userId == null) {
        print("❌ Token or UserId not found");
        return false;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/cart/add'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "foodId": foodId,
          "userId": userId,
          "quantity": quantity,
        }),
      );

      print("Response: ${response.statusCode} - ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Error in addToCart: $e");
      return false;
    }
  }


  // ================== GET CART (সবচেয়ে গুরুত্বপূর্ণ) ==================
  /// এই মেথডটা Flutter থেকে userId পাঠিয়ে শুধু সেই ইউজারের কার্ট নিয়ে আসবে
  static Future<CartResponse?> getCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      final userId = prefs.getString("userId");

      // ================== Debug Print ==================
      print("🔍 Stored Token: ${token ?? 'NULL'}");
      print("🔍 Stored UserId: ${userId ?? 'NULL'}");

      if (token == null || token.isEmpty) {
        print("❌ No token found in SharedPreferences");
        return null;
      }

      if (userId == null || userId.isEmpty) {
        print("❌ No userId found");
        return null;
      }

      final uri = Uri.parse('$baseUrl/api/cart?userId=$userId');

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',     // ← সবচেয়ে গুরুত্বপূর্ণ
          'Content-Type': 'application/json',
        },
      );

      print("📡 Get Cart Status Code: ${response.statusCode}");
      print("📡 Get Cart Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return CartResponse.fromJson(jsonData);
      } else if (response.statusCode == 400 || response.statusCode == 401) {
        print("❌ Token related error from server");
        // এখানে token clear করে লগইন স্ক্রিনে পাঠাতে পারো পরে
        return null;
      } else {
        return null;
      }
    } catch (e) {
      print("❌ Get Cart Exception: $e");
      return null;
    }
  }



  // ================== UPDATE CART QUANTITY ==================
  static Future<bool> updateCartQuantity({
    required String cartItemId,
    required int quantity,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null || token.isEmpty) {
        print("❌ No token found for update");
        return false;
      }

      final response = await http.patch(
        Uri.parse('$baseUrl/api/cart/update/$cartItemId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "quantity": quantity,
        }),
      );

      print("Update Quantity Status: ${response.statusCode}");
      print("Update Response: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Update quantity error: $e");
      return false;
    }
  }



  // ================== DELETE CART ITEM ==================
  static Future<bool> deleteCartItem(String cartItemId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null || token.isEmpty) {
        print("❌ No token found for delete");
        return false;
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/api/cart/$cartItemId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print("Delete Item Status: ${response.statusCode}");
      print("Delete Response: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print("Delete cart item error: $e");
      return false;
    }
  }
}