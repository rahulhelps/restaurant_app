import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static SharedPreferences? _prefs;

  /// 🔥 INIT (call once)
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future saveToken(String token) async {
    await _prefs?.setString("token", token);
  }

  static Future clearToken() async {
    await _prefs?.remove("token");
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("userId");
  }

}
