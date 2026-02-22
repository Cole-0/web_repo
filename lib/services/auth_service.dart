import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
 //Important Network Configuration:
  //
  // Android Emulator: Set baseUrl in lib/services/auth_service.dart to http://10.0.2.2:8000/api.
  //
  // Physical Device / Web: Set baseUrl to your computer's Local IP (e.g., http://192.168.1.XX:8000/api).

  static const String baseUrl = "http://192.168.1.9:8000/api";

 static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: {'email': email, 'password': password},
    );

    return json.decode(response.body);
  }
}