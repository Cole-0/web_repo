import 'dart:convert';
import 'package:http/http.dart' as http;

class IpService {
  static const String _geoUrl = "https://ipinfo.io";

  // Fetches data for current user if ip is null, or specific IP if provided
  static Future<Map<String, dynamic>> fetchIpDetails([String? ip]) async {
    final url = (ip == null || ip.isEmpty)
        ? "$_geoUrl/json"
        : "$_geoUrl/$ip/json";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Invalid IP or API Error");
    }
  }
}