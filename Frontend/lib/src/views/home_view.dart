import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:rideshare/src/controllers/ride_map_controller.dart';
import 'package:rideshare/src/views/create_ride_view.dart';
import 'package:rideshare/src/views/find_ride_view.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final RideMapController rideMapController = Get.put(RideMapController());

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu),
          style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.white)),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications),
            style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.white)),
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
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0, bottom: 10.0),
                    child: const Text(
                      "What do you want?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.search),
                        label: const Text("Search anything..."),
                        labelStyle: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black.withOpacity(0.05),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0,bottom: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _userChoiceCard(
                          "Driver",
                          () => Get.to(CreateRideView()),
                          deviceHeight,
                          deviceWidth,
                        ),
                        _userChoiceCard(
                          "Rider",
                          () => Get.to(FindRideView()),
                          deviceHeight,
                          deviceWidth,
                        ),
                      ],
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

  Widget _userChoiceCard(
    String title,
    VoidCallback? onTap,
    double deviceHeight,
    double deviceWidth,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 65.0,
        width: deviceWidth * 0.41,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 20.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/${title.toLowerCase()}.png",
              height: 25.0,
              width: 25.0,
              color: Colors.grey,
            ),
            SizedBox(width: 15.0),
            Text(
              title,
              style: TextStyle(
                color: Colors.black.withOpacity(0.8),
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
