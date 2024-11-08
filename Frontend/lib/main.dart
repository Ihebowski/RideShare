import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rideshare/src/controllers/user_controller.dart';
import 'package:rideshare/src/views/login_view.dart';
import 'package:rideshare/src/views/main_view.dart';
import 'package:rideshare/src/views/register_view.dart';
import 'package:rideshare/src/wrapper.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Wrapper(),
    );
  }
}
