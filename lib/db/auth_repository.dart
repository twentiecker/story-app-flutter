import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app_flutter/model/login_response.dart';

import '../model/user.dart';

/// todo 3: create Auth Repository and
/// add some method for auth process
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

  /// todo 4: add user manager to handle user information like email and password
  final String userKey = "user";

  // Future<bool> saveUser(User user) async {
  //   final preferences = await SharedPreferences.getInstance();
  //   await Future.delayed(const Duration(seconds: 2));
  //   return preferences.setString(userKey, user.toJson());
  // }

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

// Future<User?> getUser() async {
//   final preferences = await SharedPreferences.getInstance();
//   await Future.delayed(const Duration(seconds: 2));
//   final json = preferences.getString(userKey) ?? "";
//   User? user;
//   try {
//     user = User.fromJson(json);
//   } catch (e) {
//     user = null;
//   }
//   return user;
// }
}
