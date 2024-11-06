import 'package:flutter/material.dart';
import 'package:rideshare/src/models/ride_model.dart';

class UserRideCard extends StatelessWidget {
  final Ride ride;
  final bool selected;
  const UserRideCard({super.key, required this.ride, required this.selected});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

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
                  ride.user.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  "${ride.date.split('T').first} Around ${ride.time}",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.7),
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
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
