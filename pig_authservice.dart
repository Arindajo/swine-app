import 'dart:convert';
import 'package:http/http.dart' as http;

class PigService {
  final String baseUrl = 'http://127.0.0.1:8000/auth1app/api/';

  Future<void> addPig(String name, String token) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token', // replace with Bearer if you use JWT
      },
      body: jsonEncode({
        'name': name,
        'temperature': 'N/A',
        'activity': 'N/A',
        'growth': 'N/A',
        'health_status': 'Unknown',
      }),
    );

    if (response.statusCode == 201) {
      print("Pig added successfully");
    } else {
      print("Failed to add pig: ${response.body}");
    }
  }

  Future<List<Map<String, dynamic>>> fetchPigs(String token) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Failed to fetch pigs");
    }
  }
}
