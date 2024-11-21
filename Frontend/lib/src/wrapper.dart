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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              height: 150.0,
              width: 150.0,
            ),
            Text(
              "RideShare",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 24.0,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
