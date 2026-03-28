import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/models/food_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiServices {
  static const baseUrl = 'http://10.0.2.2:2000/api';

  static createAccount(String name, String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/register');

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );

    final data = jsonDecode(res.body);

    print("STATUS: ${res.statusCode}");
    print("BODY: $data");

    if (res.statusCode == 201) {
      print(data['message']);
    } else {
      print(data);
    }
  }

  static loginAccount(String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/auth/login');

      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      final data = jsonDecode(res.body);

      print("STATUS: ${res.statusCode}");
      print("BODY: $data");

      if (res.statusCode == 200) {
        // ✅ success
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", data["token"]);
        await prefs.setString("userId", data["userId"]);
        await prefs.setString("email", data["email"]).toString();
        await prefs.setString("name", data["name"]).toString();

        print(data["token"]);
        print(data['name']);

        print("Login Success → Token Saved");
        return true;
      } else if (res.statusCode == 400 || res.statusCode == 404) {
        // ❌ invalid login
        print(data["message"]);

        return false;
      } else {
        print("Server Error");
        return false;
      }
    } catch (e) {
      print("ERROR: $e");
      return false;
    }
  }

  Future<List<FoodModel>> getFoods() async {
    final response = await http.get(Uri.parse('$baseUrl/foods'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => FoodModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load foods: ${response.statusCode}');
    }
  }

  static Future<bool> postCart(String foodId, int quantity) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final userId = prefs.getString("userId");
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/cart/add'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token.toString(), // ← Token এখানে যাবে
        },
        body: jsonEncode({
          "foodId": foodId,
          "userId": userId,
          "quantity": quantity,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Cart-এ যোগ হয়েছে");
        return true;
      } else {
        print("❌ Failed: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error adding to cart: $e");
      return false;
    }
  }
}
