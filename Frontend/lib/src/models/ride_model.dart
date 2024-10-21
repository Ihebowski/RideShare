class RideModel {
  String rideId;
  Map<String, String> startLocation;
  Map<String, String> destination;
  String date;
  String time;
  int availableSeats;

  RideModel({
    required this.rideId,
    required this.startLocation,
    required this.destination,
    required this.date,
    required this.time,
    required this.availableSeats,
  });
}
