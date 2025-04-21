import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  static const String endpoint = 'https://your-django-backend-url.com/chatbot/';

  static Future<String?> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'query': message}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['reply']; // Adjust if Django returns a different key
      } else {
        return 'Error: ${response.statusCode}';
      }
    } catch (e) {
      return 'Failed to connect: $e';
    }
  }
}
