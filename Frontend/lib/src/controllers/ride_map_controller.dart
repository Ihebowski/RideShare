import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:rideshare/src/controllers/create_ride_controller.dart';
import 'package:rideshare/src/controllers/find_ride_controller.dart';

class RideMapController extends GetxController {
  late MapController mapController;

  RxBool isSelectingLocation = false.obs;
  final CreateRideController createRideController =
      Get.put(CreateRideController());
  final FindRideController findRideController = Get.put(FindRideController());

  @override
  void onInit() {
    mapController = MapController.customLayer(
      initPosition: GeoPoint(latitude: 36.8510313, longitude: 10.1591322),
      customTile: CustomTile(
        sourceName: "maptiler",
        tileExtension: ".png",
        urlsServers: [
          TileURLs(
            url: "https://api.maptiler.com/maps/dataviz/",
          ),
        ],
        tileSize: 256,
        keyApi: const MapEntry(
          "key",
          "PGtPsIii0XU0MH3Cry9i",
        ),
      ),
    );

    mapController.listenerMapLongTapping.addListener(() {
      var tappedLocation = handleMapLongTap();
      if (tappedLocation != null) {
        createRideController.setSelectedLocation(tappedLocation);
        findRideController.setSelectedLocation(tappedLocation);
        String location =
            "Lat: ${tappedLocation.latitude}, Lng: ${tappedLocation.longitude}";
        print("Selected location: $location");
      }
    });

    super.onInit();
  }

  GeoPoint? handleMapLongTap() {
    if (isSelectingLocation.value &&
        mapController.listenerMapLongTapping.value != null) {
      final GeoPoint? tappedLocation =
          mapController.listenerMapLongTapping.value;

      if (tappedLocation != null) {
        mapController.addMarker(
          GeoPoint(
              latitude: tappedLocation.latitude,
              longitude: tappedLocation.longitude),
          markerIcon: MarkerIcon(
            icon: Icon(
              Icons.location_on,
              color: Colors.black,
              size: 25.0,
            ),
          ),
        );
        isSelectingLocation.value = false;

        return tappedLocation;
      }
    }
    return null;
  }

  void enableLocationSelection() {
    isSelectingLocation.value = true;
  }
}
