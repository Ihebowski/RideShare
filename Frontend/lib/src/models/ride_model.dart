import 'package:rideshare/src/models/user_model.dart';

class Ride {
  final String id;
  final List<double> startLocation;
  final List<double> endLocation;
  final String date;
  final String time;
  final int availableSeats;
  final User user;
  final String status;
  final List<String> passengers;

  Ride({
    required this.id,
    required this.startLocation,
    required this.endLocation,
    required this.date,
    required this.time,
    required this.availableSeats,
    required this.user,
    required this.status,
    required this.passengers,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['_id'] ?? '', // Provide a default value if null
      startLocation: List<double>.from(json['startLocation'] ?? []),
      endLocation: List<double>.from(json['endLocation'] ?? []),
      date: json['date'] ?? '', // Provide a default value if null
      time: json['time'] ?? '', // Provide a default value if null
      availableSeats: json['availableSeats'] ?? 0, // Provide a default value if null
      user: User.fromJson(json['user'] ?? {}), // Ensure User is instantiated correctly
      status: json['status'] ?? '', // Provide a default value if null
      passengers: List<String>.from(json['passengers'] ?? []),
    );
  }
}
