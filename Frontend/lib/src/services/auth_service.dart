import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rideshare/src/models/user_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  static final String baseUrl =
      dotenv.env['API_URL'] ?? 'http://10.0.2.2:9001' + "/api/users/";

  Future<http.Response?> register(User user) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 201) {
        return response;
      } else {
        print("Failed to register: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error during registration: $e");
      return null;
    }
  }

  Future<http.Response?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        print("Failed to login: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error during login: $e");
      return null;
    }
  }
}