import 'package:get/get.dart';
import 'package:rideshare/src/views/login_view.dart';
import 'package:rideshare/src/views/main_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  var userId = ''.obs;
  var name = ''.obs;
  var email = ''.obs;
  var phone = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> checkUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('userId') != null) {
      Get.offAll(() => MainView());
    } else {
      Get.offAll(() => LoginView());
    }
  }

  Future<void> saveUserData(Map<String, dynamic> user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', user['_id']);
    await prefs.setString('name', user['name']);
    await prefs.setString('email', user['email']);
    await prefs.setString('phone', user['phone']);

    userId.value = user['_id'];
    name.value = user['name'];
    email.value = user['email'];
    phone.value = user['phone'];
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId.value = prefs.getString('userId') ?? '';
    name.value = prefs.getString('name') ?? '';
    email.value = prefs.getString('email') ?? '';
    phone.value = prefs.getString('phone') ?? '';
  }

  Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('name');
    await prefs.remove('email');
    await prefs.remove('phone');

    userId.value = '';
    name.value = '';
    email.value = '';
    phone.value = '';
  }
}
