import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:rideshare/src/controllers/find_ride_controller.dart';
import 'package:rideshare/src/controllers/ride_controller.dart';
import 'package:rideshare/src/controllers/ride_map_controller.dart';
import 'package:rideshare/src/views/notification_view.dart';

class FindRideView extends StatelessWidget {
  FindRideView({super.key});

  final RideMapController rideMapController = Get.find<RideMapController>();
  final FindRideController findRideController = Get.put(FindRideController());
  final RideController rideController = Get.put(RideController());

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Get.delete<FindRideController>();
            Get.back();
          },
          icon: const Icon(Icons.arrow_back),
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.white),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Get.to(NotificationView()),
            icon: const Icon(Icons.notifications),
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.white),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          OSMFlutter(
            controller: rideMapController.mapController,
            osmOption: const OSMOption(
              userTrackingOption: UserTrackingOption(
                enableTracking: true,
                unFollowUser: false,
              ),
              zoomOption: ZoomOption(
                initZoom: 13,
                minZoomLevel: 5,
                maxZoomLevel: 19,
              ),
            ),
          ),
          Positioned(
            top: deviceHeight / 2,
            right: 5,
            child: Obx(
              () {
                return Visibility(
                  visible: findRideController.isSelectingLocation.value,
                  child: SizedBox(
                    height: 100.0,
                    width: 50.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            rideMapController.mapController.zoomIn();
                          },
                          child: Container(
                            height: 45.0,
                            width: 45.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.white,
                            ),
                            child: const Icon(Icons.add),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            rideMapController.mapController.zoomOut();
                          },
                          child: Container(
                            height: 45.0,
                            width: 45.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.white,
                            ),
                            child: const Icon(Icons.remove),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Obx(
              () {
                return Visibility(
                  visible: findRideController.isSelectingLocation.value,
                  child: Container(
                    width: deviceWidth,
                    height: deviceHeight * 0.1,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25.0,
                      vertical: 20.0,
                    ),
                    child: Center(
                      child: Container(
                        height: 2.5,
                        width: deviceWidth * 0.5,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Obx(
              () {
                return Visibility(
                  visible: !findRideController.isSelectingLocation.value,
                  child: Container(
                    width: deviceWidth,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25.0,
                      vertical: 20.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "From",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: TextField(
                            readOnly: true,
                            controller: TextEditingController(
                              text: findRideController
                                              .fromLocation.value.latitude ==
                                          0 &&
                                      findRideController
                                              .fromLocation.value.longitude ==
                                          0
                                  ? ''
                                  : 'Lat: ${findRideController.fromLocation.value.latitude.toStringAsFixed(3)}, Lng: ${findRideController.fromLocation.value.longitude.toStringAsFixed(3)}',
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: const Icon(Icons.location_on),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  findRideController.fromLocation.value
                                                  .latitude ==
                                              0 &&
                                          findRideController.fromLocation.value
                                                  .longitude ==
                                              0
                                      ? Icons.gps_not_fixed
                                      : Icons.gps_fixed,
                                ),
                                onPressed: () {
                                  findRideController.isSelectingLocation.value =
                                      true;
                                  findRideController.isFromLocation.value =
                                      true;
                                  rideMapController.enableLocationSelection();
                                },
                              ),
                              label: const Text("From Location"),
                              labelStyle: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                            onTap: () {
                              findRideController.isSelectingLocation.value =
                                  true;
                              findRideController.isFromLocation.value = true;
                              rideMapController.enableLocationSelection();
                            },
                          ),
                        ),
                        const Text(
                          "To",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: TextField(
                            readOnly: true,
                            // Make it read-only since we are using GeoPoints
                            controller: TextEditingController(
                              text: findRideController
                                              .toLocation.value.latitude ==
                                          0 &&
                                      findRideController
                                              .toLocation.value.longitude ==
                                          0
                                  ? ''
                                  : 'Lat: ${findRideController.toLocation.value.latitude.toStringAsFixed(3)}, Lng: ${findRideController.toLocation.value.longitude.toStringAsFixed(3)}',
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: const Icon(Icons.location_on),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  findRideController
                                                  .toLocation.value.latitude ==
                                              0 &&
                                          findRideController
                                                  .toLocation.value.longitude ==
                                              0
                                      ? Icons.gps_not_fixed
                                      : Icons.gps_fixed,
                                ),
                                onPressed: () {
                                  findRideController.isSelectingLocation.value =
                                      true;
                                  findRideController.isFromLocation.value =
                                      false;
                                  rideMapController.enableLocationSelection();
                                },
                              ),
                              label: const Text("To Location"),
                              labelStyle: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                            onTap: () {
                              findRideController.isSelectingLocation.value =
                                  true;
                              findRideController.isFromLocation.value = false;
                              rideMapController.enableLocationSelection();
                            },
                          ),
                        ),
                        Obx(
                          () => Container(
                            height: 50.0,
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(vertical: 10.0),
                            child: TextButton(
                              onPressed: () => findRideController.findRide(),
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  Colors.grey.shade100,
                                ),
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                              child: findRideController.isLoading.value
                                  ? CircularProgressIndicator(
                                      color: Colors.black,
                                    )
                                  : const Text(
                                      "Find Now",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
