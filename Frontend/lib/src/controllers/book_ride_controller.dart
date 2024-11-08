import 'package:get/get.dart';
import 'package:rideshare/src/services/ride_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookRideController extends GetxController {
  final RideService rideService = RideService();
  late String userId;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
  }

  Future<void> bookRide(String rideId) async {
    isLoading.value = true;
    await rideService.bookRide(rideId, userId);
    isLoading.value = false;
  }
}
