import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rideshare/src/controllers/user_controller.dart';
import 'package:rideshare/src/services/auth_service.dart';
import 'package:rideshare/src/views/main_view.dart';

class LoginController extends GetxController {
  final AuthService authService = AuthService();
  final UserController userController = Get.put(UserController());

  var email = "".obs;
  var password = "".obs;
  var isPasswordVisible = false.obs;
  var isLoading = false.obs;

  void setEmail(String value) {
    email.value = value;
  }

  void setPassword(String value) {
    password.value = value;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> loginUser() async {
    if (email.value.isEmpty || password.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all required fields!",
        backgroundColor: Colors.white.withOpacity(0.7),
        colorText: Colors.black,
      );
      return;
    }

    isLoading.value = true;
    var response = await authService.login(email.value, password.value);
    if (response != null) {
      var jsonData = jsonDecode(response.body);
      if (jsonData['message'] == "Login successful") {
        await userController.saveUserData(jsonData['user']);
        Get.snackbar(
          "Success",
          "Login successful!",
          backgroundColor: Colors.white.withOpacity(0.7),
          colorText: Colors.black,
        );
        Get.offAll(MainView());
      } else {
        Get.snackbar(
          "Error",
          "Login failed.",
          backgroundColor: Colors.white.withOpacity(0.7),
          colorText: Colors.black,
        );
      }
    } else {
      Get.snackbar(
        "Error",
        "Login failed.",
        backgroundColor: Colors.white.withOpacity(0.7),
        colorText: Colors.black,
      );
    }
    isLoading.value = false;
  }
}
