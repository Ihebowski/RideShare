import 'package:get/get.dart';
import 'package:rideshare/src/controllers/ride_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseRideController extends GetxController {
  final RideController rideController = Get.find<RideController>();

  @override
  void onInit() async {
    super.onInit();

    await removeRidesByLoggedInUser();
  }

  Future<void> removeRidesByLoggedInUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? loggedInUserId = prefs.getString('userId');

      if (loggedInUserId != null) {
        rideController.driversList.removeWhere((ride) => ride.user.id == loggedInUserId);

        print("Rides created by user with ID $loggedInUserId have been removed.");
      } else {
        print("Logged-in user ID not found in SharedPreferences.");
      }
    } catch (e) {
      print("Error removing rides by logged-in user: $e");
    }
  }

  @override
  void onClose() {
    super.onClose();

  }
}
