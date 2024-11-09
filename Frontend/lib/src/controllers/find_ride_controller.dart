import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:rideshare/src/controllers/ride_controller.dart';
import 'package:rideshare/src/controllers/ride_map_controller.dart';
import 'package:rideshare/src/models/ride_model.dart';
import 'package:rideshare/src/services/ride_service.dart';
import 'package:rideshare/src/views/choose_ride_view.dart';

class FindRideController extends GetxController {
  final RideMapController rideMapController = Get.find<RideMapController>();
  final RideController rideController = Get.put(RideController());
  final RideService rideService = RideService();

  var fromLocation = GeoPoint(latitude: 0, longitude: 0).obs;
  var toLocation = GeoPoint(latitude: 0, longitude: 0).obs;
  var isFromLocation = false.obs;
  var isSelectingLocation = false.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    ever(rideMapController.selectedLocation, (GeoPoint? geoPoint) {
      if (geoPoint != null) {
        setSelectedLocation(geoPoint);
      }
    });
  }

  void setFromLocation(GeoPoint geoPoint) {
    fromLocation.value = GeoPoint(latitude: 0, longitude: 0);
    fromLocation.value = geoPoint;
  }

  void setToLocation(GeoPoint geoPoint) {
    toLocation.value = GeoPoint(latitude: 0, longitude: 0);
    toLocation.value = geoPoint;
  }

  void setSelectedLocation(GeoPoint geoPoint) {
    if (isFromLocation.value) {
      setFromLocation(geoPoint);
    } else {
      setToLocation(geoPoint);
    }
    isSelectingLocation.value = false;
  }

  Future<void> findRide() async {
    if (fromLocation.value.latitude == 0 ||
        fromLocation.value.longitude == 0 ||
        toLocation.value.latitude == 0 ||
        toLocation.value.longitude == 0) {
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

    var response = await rideService.fetchDrivers(startLocation, endLocation);
    isLoading.value = false;

    if (response != null) {
      var jsonData = jsonDecode(response.body);
      if (jsonData["status"] == "success") {
        List rides = jsonData["rides"];
        rideController.driversList.value =
            rides.map((ride) => Ride.fromJson(ride)).toList();
        Get.to(() => ChooseRideView());
      } else {
        Get.snackbar(
          "No Drivers Found",
          "Try again later!",
          backgroundColor: Colors.white.withOpacity(0.7),
          colorText: Colors.black,
        );
      }
    } else {
      Get.snackbar(
        "Error",
        "Failed to fetch drivers.",
        backgroundColor: Colors.white.withOpacity(0.7),
        colorText: Colors.black,
      );
    }
  }

  void resetRideData(){
    fromLocation.value = GeoPoint(latitude: 0, longitude: 0);
    toLocation.value = GeoPoint(latitude: 0, longitude: 0);
    isFromLocation.value = false;
    isSelectingLocation.value = false;
    isLoading.value = false;
    rideController.driversList.clear();
  }

  @override
  void onClose() {
    resetRideData();
    super.onClose();
  }
}
