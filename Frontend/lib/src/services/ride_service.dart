import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rideshare/src/views/main_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RideService {
  static final String baseUrl =
      (dotenv.env['API_URL'] ?? 'http://10.0.2.2:9001').replaceAll(RegExp(r'/$'), '') + "/api/rides";

  Future<http.Response?> fetchDrivers(List<double> startLocation, List<double> endLocation) async {
    final String url = '$baseUrl/fetch-drivers';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "startLocation": startLocation,
          "endLocation": endLocation,
        }),
      );
      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "Rides loaded successfully!",
          backgroundColor: Colors.white.withOpacity(0.7),
          colorText: Colors.black,
        );
        return response;
      } else {
        Get.snackbar(
          "Error",
          "Failed to fetch drivers: ${response.body}",
          backgroundColor: Colors.white.withOpacity(0.7),
          colorText: Colors.black,
        );
        return null;
      }
    } catch (e) {
      print("Error fetching drivers: $e");
      return null;
    }
  }

  Future<http.Response?> bookRide(String rideId, String userId) async {
    final String url = '$baseUrl/join';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "rideId": rideId,
          "userId": userId,
        }),
      );
      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "Ride booked successfully!",
          backgroundColor: Colors.white.withOpacity(0.7),
          colorText: Colors.black,
        );
        Get.offAll(MainView());
        return response;
      } else if (response.statusCode == 400) {
        Get.snackbar(
          "Error",
          "Notification already sent for this ride.",
          backgroundColor: Colors.white.withOpacity(0.7),
          colorText: Colors.black,
        );
      } else if (response.statusCode == 401) {
        Get.snackbar(
          "Error",
          "No more available seats in this ride.",
          backgroundColor: Colors.white.withOpacity(0.7),
          colorText: Colors.black,
        );
      } else {
        Get.snackbar(
          "Error",
          "Failed to book ride: ${response.body}",
          backgroundColor: Colors.white.withOpacity(0.7),
          colorText: Colors.black,
        );
      }
      return null;
    } catch (e) {
      print("Error joining ride: $e");
      return null;
    }
  }

  Future<http.Response?> createRide(
      List<double> startLocation,
      List<double> endLocation,
      String date,
      String time,
      int availableSeats,
      String userId) async {
    final String url = '$baseUrl/create';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "startLocation": startLocation,
          "endLocation": endLocation,
          "date": date,
          "time": time,
          "availableSeats": availableSeats,
          "user": userId,
        }),
      );
      if (response.statusCode == 201) {
        Get.snackbar(
          "Success",
          "Ride created successfully!",
          backgroundColor: Colors.white.withOpacity(0.7),
          colorText: Colors.black,
        );
        return response;
      } else {
        Get.snackbar(
          "Error",
          "Failed to create ride: ${response.body}",
          backgroundColor: Colors.white.withOpacity(0.7),
          colorText: Colors.black,
        );
        return null;
      }
    } catch (e) {
      print("Error creating ride: $e");
      return null;
    }
  }
}