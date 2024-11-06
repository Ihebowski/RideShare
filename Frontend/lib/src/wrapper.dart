import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rideshare/src/controllers/user_controller.dart';

class Wrapper extends StatelessWidget {
  final UserController userController = Get.put(UserController());

  Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    userController.checkUserLoggedIn();
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.black,
        ),
      ),
    );
  }
}
