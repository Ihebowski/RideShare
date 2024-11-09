import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rideshare/src/controllers/notification_controller.dart';
import 'package:rideshare/src/models/notification_model.dart';
import 'package:rideshare/src/views/widgets/notification_card.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final NotificationController notificationController =
      Get.put(NotificationController());

  @override
  void dispose() {
    Get.delete<NotificationController>();
    print("Widget is being disposed");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.white),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        child: Obx(
          () {
            if (notificationController.notifications.isEmpty) {
              return Center(child: Text("No notifications available"));
            }

            return ListView.builder(
              itemCount: notificationController.notifications.length,
              itemBuilder: (context, index) {
                NotificationModel notification =
                    notificationController.notifications[index];

                return NotificationCard(
                  message: notification.message,
                  status: notification.status,
                  type: notification.type,
                  notificationId: notification.id,
                  driverId: notification.driver.id,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
