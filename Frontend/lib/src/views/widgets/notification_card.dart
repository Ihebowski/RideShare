import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rideshare/src/controllers/notification_controller.dart';

class NotificationCard extends StatelessWidget {
  final String notificationId;
  final String driverId;
  final String message;
  final String status;
  final String type;

  const NotificationCard({
    super.key,
    required this.message,
    required this.status,
    required this.type,
    required this.notificationId,
    required this.driverId,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData statusIcon;
    String statusText;
    String titleText;

    switch (status) {
      case "pending":
        statusColor = Colors.grey.shade600;
        statusIcon = Icons.timer_outlined;
        statusText = "Pending";
        break;
      case "accepted":
        statusColor = Colors.black;
        statusIcon = Icons.check_circle_outline;
        statusText = "Accepted";
        break;
      case "declined":
        statusColor = Colors.black;
        statusIcon = Icons.cancel_outlined;
        statusText = "Rejected";
        break;
      default:
        statusColor = Colors.grey.shade600;
        statusIcon = Icons.help_outline;
        statusText = "Unknown";
    }

    statusText =
        statusText[0].toUpperCase() + statusText.substring(1).toLowerCase();

    if (type == "request") {
      titleText = "Join Request";
    } else if (type == "response") {
      titleText = "Join Response";
    } else {
      titleText = "Unknown Type";
    }

    return GestureDetector(
      onTap: () {
        if (type == "request") {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  titleText,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.black),
                ),
                content: Text(
                  message,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.find<NotificationController>()
                          .handleResponse(notificationId, driverId, "decline");
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Decline',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.find<NotificationController>()
                          .handleResponse(notificationId, driverId, "accept");
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Accept',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 10.0),
        padding: EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 15.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  titleText,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 7.5, horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        statusIcon,
                        size: 16.0,
                        color: Colors.white,
                      ),
                      SizedBox(width: 5.0),
                      Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Text(
              message,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
