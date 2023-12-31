import 'package:flutter/material.dart';
import 'package:story_app_flutter/model/login_response.dart';

import '../db/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  AuthProvider(this.authRepository);

  bool isLoadingLogin = false;
  bool isLoadingLogout = false;
  bool isLoadingRegister = false;
  bool isLoggedIn = false;

  Future<bool> login(LoginResult user) async {
    await authRepository.saveToken(user.token);
    await authRepository.login();
    isLoggedIn = await authRepository.isLoggedIn();

    isLoadingLogin = false;
    notifyListeners();

    return isLoggedIn;
  }

  Future<bool> logout() async {
    isLoadingLogout = true;
    notifyListeners();

    final logout = await authRepository.logout();
    if (logout) {
      await authRepository.deleteUser();
    }
    isLoggedIn = await authRepository.isLoggedIn();

    isLoadingLogout = false;
    notifyListeners();

    return !isLoggedIn;
  }

  Future<bool> registerComplete() async {
    isLoadingRegister = false;
    notifyListeners();
    return true;
  }

  void registerState(bool state) async {
    isLoadingRegister = state;
    notifyListeners();
  }

  void loginState(bool state) async {
    isLoadingLogin = state;
    notifyListeners();
  }
}
