import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rideshare/src/models/notification_model.dart';
import 'package:rideshare/src/views/main_view.dart';

class NotificationService {
  final String baseUrl = 'http://10.0.2.2:5000/api/rides';

  Future<List<NotificationModel>> getNotificationById(String id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getnotifbyid'),
        body: jsonEncode({"id": id}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> notificationsJson = data['notifications'];
        return notificationsJson
            .map((notif) => NotificationModel.fromJson(notif))
            .toList();
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      print("Error fetching notifications: $e");
      return [];
    }
  }

  Future<void> sendResponse(
      String notificationId, String driverId, String responseChoice) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/response'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'notificationId': notificationId,
          'driverId': driverId,
          'response': responseChoice,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "Response sent successfully!",
          backgroundColor: Colors.white.withOpacity(0.7),
          colorText: Colors.black,
        );
        Get.off(() => MainView());
      } else {
        Get.snackbar(
          "Error",
          "Failed to send response: ${response.body}",
          backgroundColor: Colors.white.withOpacity(0.7),
          colorText: Colors.black,
        );
      }
    } catch (e) {
      print("Error sending response: $e");
    }
  }
}
