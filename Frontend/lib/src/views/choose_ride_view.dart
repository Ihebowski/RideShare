import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:rideshare/src/controllers/choose_ride_controller.dart';
import 'package:rideshare/src/controllers/ride_controller.dart';
import 'package:rideshare/src/controllers/ride_map_controller.dart';
import 'package:rideshare/src/views/book_ride_view.dart';
import 'package:rideshare/src/views/notification_view.dart';
import 'package:rideshare/src/views/widgets/user_ride_card.dart';

class ChooseRideView extends StatefulWidget {
  const ChooseRideView({super.key});

  @override
  State<ChooseRideView> createState() => _ChooseRideViewState();
}

class _ChooseRideViewState extends State<ChooseRideView> {
  final RideMapController rideMapController = Get.find<RideMapController>();
  final RideController rideController = Get.find<RideController>();
  final ChooseRideController chooseRideController =
      Get.put(ChooseRideController());
  int selectedRideIndex = -1;

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Get.back(),
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
                initZoom: 15,
                minZoomLevel: 10,
                maxZoomLevel: 19,
              ),
            ),
            onMapIsReady: (bool isReady) async {
              if (isReady) {
                rideMapController.isMapLoading.value = false;
              }
            },
            mapIsLoading: Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
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
                // horizontal: 25.0,
                vertical: 20.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 15.0),
                    child: Text(
                      "Available Rides",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Obx(() {
                      if (rideController.driversList.isEmpty) {
                        return SizedBox(
                          height: 100.0,
                          child: Center(
                            child: Text("No drivers available."),
                          ),
                        );
                      }
                      int driversCount = rideController.driversList.length;

                      double height;
                      if (driversCount > 3) {
                        height = 300.0;
                      } else if (driversCount == 2) {
                        height = 200.0;
                      } else if (driversCount <= 1) {
                        height = 100.0;
                      } else {
                        height = 150.0;
                      }
                      return SizedBox(
                        height: height,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: rideController.driversList.length,
                          itemBuilder: (context, index) {
                            final ride = rideController.driversList[index];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedRideIndex = index;
                                });
                              },
                              child: UserRideCard(
                                ride: ride,
                                selected: selectedRideIndex == index,
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ),
                  Container(
                    height: 50.0,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 25.0,
                    ),
                    child: TextButton(
                      onPressed: () {
                        if (selectedRideIndex != -1) {
                          Get.to(
                            BookRideView(
                              ride:
                                  rideController.driversList[selectedRideIndex],
                            ),
                          );
                        } else {
                          Get.snackbar(
                            "Error",
                            "Please select a ride!",
                            backgroundColor: Colors.white.withOpacity(0.7),
                            colorText: Colors.black,
                          );
                        }
                      },
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
                      child: const Text(
                        "Select Ride",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
