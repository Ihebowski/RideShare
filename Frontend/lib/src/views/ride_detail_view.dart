import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rideshare/src/views/notification_view.dart';

class RideDetailView extends StatelessWidget {
  const RideDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.025),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.white),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Get.to(NotificationView()),
            icon: const Icon(Icons.notifications),
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.white),
            ),
          ),
        ],
      ),
      body: Stack(),
    );
  }
}
