// lib/controllers/auth_controller.dart
import 'package:evana_event_management_app/Helpers/auth_service.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  final email = ''.obs;
  final password = ''.obs;
  final isLoading = false.obs;
  final isGoogleLoading = false.obs;

  void updateEmail(String value) => email.value = value;
  void updatePassword(String value) => password.value = value;

  Future<void> loginWithEmail() async {
    try {
      isLoading(true);
      await _authService.loginWithEmail(email.value, password.value);
      Get.offAllNamed('/home');
    } finally {
      isLoading(false);
    }
  }

  Future<void> registerWithEmail() async {
    try {
      isLoading(true);
      await _authService.registerWithEmail(email.value, password.value);
      Get.offAllNamed('/home');
    } finally {
      isLoading(false);
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      isGoogleLoading(true);
      await _authService.loginWithGoogle();
      Get.offAllNamed('/home');
    } finally {
      isGoogleLoading(false);
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    Get.offAllNamed('/login');
  }
}