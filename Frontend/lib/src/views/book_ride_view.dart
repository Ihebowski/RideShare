import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rideshare/src/views/notification_view.dart';

class BookRideView extends StatelessWidget {
  const BookRideView({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  height: 130.0,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 15.0),
                  padding: EdgeInsets.symmetric(
                    vertical: 25.0,
                    horizontal: 15.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.place,
                            size: 28.0,
                          ),
                          VerticalDivider(),
                          Icon(
                            Icons.flag,
                            size: 28.0,
                          ),
                        ],
                      ),
                      SizedBox(width: 15.0),
                      SizedBox(
                        width: deviceWidth * 0.7,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              "Lat: 36.81278304355647, Lng: 10.168033946644158",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                            Divider(
                              color: Colors.grey.shade100,
                            ),
                            Text(
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              "Lat: 36.76559195343551, Lng: 10.196873057972283",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 175.0,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 15.0),
                  padding: EdgeInsets.symmetric(
                    vertical: 25.0,
                    horizontal: 15.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Date",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            "18 October 2024",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Time",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            "10:20AM",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Seats",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            "4",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 125.0,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 15.0),
                  padding: EdgeInsets.symmetric(
                    vertical: 25.0,
                    horizontal: 15.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32.0,
                      ),
                      SizedBox(width: 20.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Iheb Barrah",
                            style: TextStyle(
                              fontSize: 24.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 20.0,
                              ),
                              SizedBox(width: 5.0),
                              Text(
                                "4.9",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 10.0),
                              Text(
                                "(10+ Reviews)",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  height: 50.0,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Colors.grey.shade600,
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    child: const Text(
                      "Book Ride",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 50.0,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Colors.white,
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    child: const Text(
                      "Schedule Ride",
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
          ],
        ),
      ),
    );
  }
}
