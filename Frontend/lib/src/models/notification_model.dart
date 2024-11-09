import 'package:rideshare/src/models/ride_model.dart';
import 'package:rideshare/src/models/user_model.dart';

class NotificationModel {
  final String id;
  final String message;
  final String status;
  final String type;
  final String createdAt;
  final String updatedAt;
  final User user;
  final Ride ride;
  final User driver;

  NotificationModel({
    required this.id,
    required this.message,
    required this.status,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.ride,
    required this.driver,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'],
      message: json['message'],
      status: json['status'],
      type: json['type'] as String,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      user: User.fromJson(json['userId']),
      ride: Ride.fromJson(json['rideId']),
      driver: User.fromJson(json['driverId']),
    );
  }
}