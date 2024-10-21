import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';

class CreateRideController extends GetxController {
  var fromLocation = "".obs;
  var toLocation = "".obs;
  var selectedTime = "".obs;
  var selectedDate = "".obs;

  var isGoNowSelected = false.obs;
  var isScheduleSelected = false.obs;

  var isFromLocation = false.obs;
  var isSelectingLocation = false.obs;

  void setFromLocation(String location) {
    fromLocation.value = location;
  }

  void setToLocation(String location) {
    toLocation.value = location;
  }

  void setTime(String time) {
    selectedTime.value = time;
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
    print(
        "Publishing ride from ${fromLocation.value} to ${toLocation.value} at ${selectedTime.value} in ${selectedDate.value}.");
  }

  @override
  void onClose() {
    fromLocation.value = "";
    toLocation.value = "";
    selectedTime.value = "";
    selectedDate.value = "";
    super.onClose();
  }
}
