import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final String stateKey = "state";

  Future<bool> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(stateKey) ?? false;
  }

  Future<bool> login() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setBool(stateKey, true);
  }

  Future<bool> logout() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setBool(stateKey, false);
  }

  final String userKey = "user";

  Future<bool> saveToken(String token) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setString(userKey, token);
  }

  Future<String> getToken() async {
    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString(userKey) ?? "";
    return token;
  }

  Future<bool> deleteUser() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setString(userKey, "");
  }
}
