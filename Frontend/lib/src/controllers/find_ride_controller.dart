import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';

class FindRideController extends GetxController {
  var fromLocation = "".obs;
  var toLocation = "".obs;

  var isFromLocation = false.obs;
  var isSelectingLocation = false.obs;

  void setFromLocation(String location) {
    fromLocation.value = location;
  }

  void setToLocation(String location) {
    toLocation.value = location;
  }

  void setSelectedLocation(GeoPoint geoPoint) {
    String location = "Lat: ${geoPoint.latitude}, Lng: ${geoPoint.longitude}";
    if (isFromLocation.value) {
      setFromLocation(location);
    } else {
      setToLocation(location);
    }
    isSelectingLocation.value = false;
  }

  void publishRide() {
    print("Looking for a ride from ${fromLocation.value} to ${toLocation.value}.");
  }

  @override
  void onClose() {
    fromLocation.value = "";
    toLocation.value = "";
    super.onClose();
  }
}
