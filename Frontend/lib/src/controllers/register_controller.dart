import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rideshare/src/controllers/user_controller.dart';
import 'package:rideshare/src/models/user_model.dart';
import 'package:rideshare/src/services/auth_service.dart';
import 'package:rideshare/src/views/login_view.dart';

class RegisterController extends GetxController {
  final AuthService authService = AuthService();
  final UserController userController = Get.put(UserController());

  var name = "".obs;
  var email = "".obs;
  var password = "".obs;
  var isPasswordVisible = false.obs;
  var phone = "".obs;
  var isChecked = false.obs;

  var isLoading = false.obs;

  void setName(String value) {
    name.value = value;
  }

  void setEmail(String value) {
    email.value = value;
  }

  void setPassword(String value) {
    password.value = value;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void setPhone(String value) {
    phone.value = value;
  }

  void toggleCheckbox(bool value) {
    isChecked.value = value;
  }

  Future<void> registerUser() async {
    if (email.value.isEmpty ||
        password.value.isEmpty ||
        name.value.isEmpty ||
        phone.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all required fields!",
        backgroundColor: Colors.white.withOpacity(0.7),
        colorText: Colors.black,
      );
      return;
    }

    if (!isChecked.value) {
      Get.snackbar(
        "Error",
        "Please read the term and conditions!",
        backgroundColor: Colors.white.withOpacity(0.7),
        colorText: Colors.black,
      );
      return;
    }

    isLoading.value = true;
    User user = User.withoutId(
      name: name.value,
      email: email.value,
      password: password.value,
      phone: phone.value
    );

    var response = await authService.register(user);
    if (response != null) {
      var jsonData = jsonDecode(response.body);
      if (jsonData['message'] == "User registered successfully") {
        Get.snackbar(
          "Success",
          "Registered successful!",
          backgroundColor: Colors.white.withOpacity(0.7),
          colorText: Colors.black,
        );
        Get.offAll(LoginView());
      } else {
        Get.snackbar(
          "Error",
          "Registration failed.",
          backgroundColor: Colors.white.withOpacity(0.7),
          colorText: Colors.black,
        );
      }
    } else {
      Get.snackbar(
        "Error",
        "Registration failed.",
        backgroundColor: Colors.white.withOpacity(0.7),
        colorText: Colors.black,
      );
    }
    isLoading.value = false;
  }
}
