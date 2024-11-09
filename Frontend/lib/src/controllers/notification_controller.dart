import 'package:get/get.dart';
import 'package:rideshare/src/services/notif_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rideshare/src/models/notification_model.dart';

class NotificationController extends GetxController {
  final NotificationService notificationService = NotificationService();
  var notifications = <NotificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      if (userId != null) {
        var loadedNotifications =
            await notificationService.getNotificationById(userId);

        // Filter notifications based on conditions:
        var filteredNotifications = loadedNotifications.where((notification) {
          if (notification.type == 'request' &&
              notification.driver.id == userId) {
            return true; // Show notification if it's a request and user is the driver
          } else if (notification.type == 'response' &&
              notification.user.id == userId) {
            return true; // Show notification if it's a response and user is the passenger
          }
          return false; // Hide other notifications
        }).toList();

        notifications.value = filteredNotifications;
        print("Loaded ${filteredNotifications.length} notifications");
      } else {
        print("User ID not found in SharedPreferences.");
      }
    } catch (e) {
      print("Error loading notifications: $e");
    }
  }

  Future<void> handleResponse(
      String notificationId, String driverId, String response) async {
    try {
      // Call the service to send the response
      await notificationService.sendResponse(
          notificationId, driverId, response);
      print("Notification response sent: $response");
      // You can perform other actions here (e.g., update UI, show success message, etc.)
    } catch (e) {
      print("Error handling response: $e");
    }
  }

  @override
  void onClose() {
    super.onClose();
    notifications.clear();
    print("Notifications list cleared on controller close.");
  }
}
