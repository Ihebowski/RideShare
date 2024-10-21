import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:rideshare/src/controllers/create_ride_controller.dart';
import 'package:rideshare/src/controllers/ride_map_controller.dart';
import 'package:rideshare/src/views/notification_view.dart';

class CreateRideView extends StatelessWidget {
  CreateRideView({super.key});

  final RideMapController rideMapController = Get.find<RideMapController>();
  final CreateRideController createRideController =
      Get.find<CreateRideController>();

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
                  visible: createRideController.isSelectingLocation.value,
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
                            child: Icon(Icons.add),
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
                            child: Icon(Icons.remove),
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
                  visible: createRideController.isSelectingLocation.value,
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
                  visible: !createRideController.isSelectingLocation.value,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _userDateCard(
                                "Go Now",
                                () {
                                  createRideController.isGoNowSelected.value =
                                      true;
                                  createRideController
                                      .isScheduleSelected.value = false;
                                  var todayDate = DateTime.now();
                                  String formattedDate =
                                      "${todayDate.day}/${todayDate.month}/${todayDate.year}";
                                  createRideController.selectedDate.value =
                                      formattedDate;
                                },
                                createRideController.isGoNowSelected.value,
                                deviceWidth,
                              ),
                              _userDateCard(
                                "Schedule",
                                () async {
                                  createRideController.isGoNowSelected.value =
                                      false;
                                  createRideController
                                      .isScheduleSelected.value = true;

                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2101),
                                  );

                                  if (pickedDate != null) {
                                    String formattedDate =
                                        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                                    createRideController.selectedDate.value =
                                        formattedDate;
                                  }
                                },
                                createRideController.isScheduleSelected.value,
                                deviceWidth,
                              ),
                            ],
                          ),
                        ),
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
                            controller: TextEditingController(
                                text: createRideController.fromLocation.value),
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
                                  createRideController
                                          .fromLocation.value.isEmpty
                                      ? Icons.gps_not_fixed
                                      : Icons.gps_fixed,
                                ),
                                onPressed: () {
                                  createRideController
                                      .isSelectingLocation.value = true;
                                  createRideController.isFromLocation.value =
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
                              createRideController.isSelectingLocation.value =
                                  true;
                              createRideController.isFromLocation.value = true;
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
                            controller: TextEditingController(
                                text: createRideController.toLocation.value),
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
                                  createRideController
                                          .fromLocation.value.isEmpty
                                      ? Icons.gps_not_fixed
                                      : Icons.gps_fixed,
                                ),
                                onPressed: () {
                                  createRideController
                                      .isSelectingLocation.value = true;

                                  createRideController.isFromLocation.value =
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
                              createRideController.isSelectingLocation.value =
                                  true;

                              createRideController.isFromLocation.value = false;
                              rideMapController.enableLocationSelection();
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: TextField(
                            controller: TextEditingController(
                                text: createRideController.selectedTime.value),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: const Icon(Icons.access_time),
                              label: const Text("Time"),
                              labelStyle: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                            onTap: () async {
                              FocusScope.of(context).requestFocus(FocusNode());

                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              if (pickedTime != null) {
                                String formattedTime =
                                    "${pickedTime.hour}:${pickedTime.minute.toString().padLeft(2, '0')}";
                                createRideController.selectedTime.value =
                                    formattedTime;
                              }
                            },
                          ),
                        ),
                        Container(
                          height: 50.0,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          child: TextButton(
                            onPressed: () {
                              if (createRideController.fromLocation.value.isEmpty ||
                                  createRideController
                                      .toLocation.value.isEmpty ||
                                  createRideController
                                      .selectedTime.value.isEmpty ||
                                  createRideController.selectedDate.isEmpty) {
                                Get.snackbar(
                                  "Error",
                                  "Please fill all required fields!",
                                  backgroundColor:
                                      Colors.white.withOpacity(0.7),
                                  colorText: Colors.black,
                                );
                              } else {
                                createRideController.publishRide();
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
                              "Publish Now",
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _userDateCard(
    String text,
    VoidCallback onTap,
    bool isSelected,
    deviceWidth,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.0,
        width: deviceWidth * 0.42,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: isSelected ? Colors.grey.shade600 : Colors.grey.shade100,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18.0,
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
