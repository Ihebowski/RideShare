import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:rideshare/src/services/ride_service.dart';
import 'package:rideshare/src/views/main_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ride_map_controller.dart';

class CreateRideController extends GetxController {
  late String userId;
  var fromLocation = GeoPoint(latitude: 0, longitude: 0).obs;
  var toLocation = GeoPoint(latitude: 0, longitude: 0).obs;
  var selectedTime = "".obs;
  var selectedDate = "".obs;
  var seats = 0.obs;
  var isLoading = false.obs;

  var isGoNowSelected = false.obs;
  var isScheduleSelected = false.obs;

  var isFromLocation = false.obs;
  var isSelectingLocation = false.obs;

  final RideMapController rideMapController = Get.find<RideMapController>();
  final RideService rideService = RideService();

  @override
  void onInit() {
    super.onInit();

    loadUserData();

    ever(rideMapController.selectedLocation, (GeoPoint? geoPoint) {
      if (geoPoint != null) {
        setSelectedLocation(geoPoint);
      }
    });
  }

  void setFromLocation(GeoPoint geoPoint) {
    fromLocation.value = geoPoint;
  }

  void setToLocation(GeoPoint geoPoint) {
    toLocation.value = geoPoint;
  }

  void setTime(String time) {
    selectedTime.value = time;
  }

  void setSeats(int seatCount) {
    seats.value = seatCount;
  }

  void setSelectedLocation(GeoPoint geoPoint) {
    if (isFromLocation.value) {
      setFromLocation(geoPoint);
    } else {
      setToLocation(geoPoint);
    }
    isSelectingLocation.value = false;
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
  }

  Future<void> publishRide() async {
    if (fromLocation.value.latitude == 0 ||
        fromLocation.value.longitude == 0 ||
        toLocation.value.latitude == 0 ||
        toLocation.value.longitude == 0 ||
        selectedTime.value.isEmpty ||
        selectedDate.isEmpty ||
        seats.value == 0) {
      Get.snackbar(
        "Error",
        "Please fill all required fields!",
        backgroundColor: Colors.white.withOpacity(0.7),
        colorText: Colors.black,
      );
      return;
    }

    isLoading.value = true;
    List<double> startLocation = [
      fromLocation.value.latitude,
      fromLocation.value.longitude
    ];
    List<double> endLocation = [
      toLocation.value.latitude,
      toLocation.value.longitude
    ];

    var response = await rideService.createRide(
      startLocation,
      endLocation,
      selectedDate.value,
      selectedTime.value,
      seats.value,
      userId,
    );

    isLoading.value = false;

    if (response != null) {
        Get.offAll(() => MainView());
      }
  }

  void resetRideData() {
    fromLocation.value = GeoPoint(latitude: 0, longitude: 0);
    toLocation.value = GeoPoint(latitude: 0, longitude: 0);
    selectedTime.value = "";
    selectedDate.value = "";
    seats.value = 0;
    isGoNowSelected.value = false;
    isScheduleSelected.value = false;
    isFromLocation.value = false;
    isSelectingLocation.value = false;
  }

  @override
  void onClose() {
    super.onClose();
    resetRideData();
  }
}
