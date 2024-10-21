import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:rideshare/src/controllers/ride_map_controller.dart';
import 'package:rideshare/src/views/book_ride_view.dart';
import 'package:rideshare/src/views/notification_view.dart';

class ChooseRideView extends StatelessWidget {
  ChooseRideView({super.key});

  final RideMapController rideMapController = Get.find<RideMapController>();

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
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 50.0,
                          width: deviceWidth * 0.42,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.grey.shade100,
                          ),
                          child: const Center(
                            child: Text(
                              "Go Now",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 50.0,
                          width: deviceWidth * 0.42,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.grey.shade600,
                          ),
                          child: const Center(
                            child: Text(
                              "Schedule",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: SizedBox(
                      height: 300.0,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          _userRidesCard(
                            "Iheb Barrah",
                            true,
                            deviceWidth
                          ),
                          _userRidesCard(
                              "Iheb Barrah",
                              false,
                              deviceWidth
                          ),
                          _userRidesCard(
                              "Iheb Barrah",
                              false,
                              deviceWidth
                          ),
                        ],
                      ),
                    ),
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
                        Get.to(BookRideView());
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

  Widget _userRidesCard(String user, bool selected, double deviceWidth) {
    return Container(
      height: 100.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: selected ? Colors.black.withOpacity(0.025) : Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            radius: 35.0,
            backgroundColor: Colors.black.withOpacity(0.025),
          ),
          SizedBox(
            width: deviceWidth * 0.39,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "14 October",
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "10:40 PM",
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Image.asset(
            "assets/images/car.png",
            height: 100.0,
            width: 100.0,
          ),
        ],
      ),
    );
  }
}
